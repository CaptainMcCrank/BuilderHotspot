#!/bin/bash
echo "============================================================================================================================="
echo "clearing your known_hosts files of potentially stale keys"
echo "============================================================================================================================="
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "10.6.6.10"
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "10.6.6.11"
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "10.6.6.12"
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "10.6.6.13"
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "10.6.6.14"
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "BuilderHotspot.local"
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "BuilderHotspot"
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "ansibledest"

attachedHOSTS=($(arp -a | grep wlan1 | awk '$4!="<incomplete>" {print$2}' | sed 's/[()]//g'))
echo "============================================================================================================================="
echo "${#attachedHOSTS[@]} hosts detected."
echo "============================================================================================================================="
echo "" 

if [ ${#attachedHOSTS[@]} -gt 1 ]; then
	for h in ${attachedHOSTS[@]}; do
		echo ""
		echo "============================================================================================================================="
		echo "Configuring host at $h"
		echo "============================================================================================================================="
		echo ""
		echo "Copying an SSH key to the recipient image so we can do remote configurations"
		ssh-copy-id -f -i ~/.ssh/id_rsa.pub pi@$h > /dev/null
		echo "Pushing a wpa_supplicant file for wlan1 that ensures we don't have a dual-nic hostname race condition during ansible execution"
		scp ~/Playbooks/BuilderHotspot/etc/wpa_supplicant/wpa_supplicant-wlan1.conf pi@$h:~/. > /dev/null
		echo "Setting the locale on $h to en_US.UTF-8.  Takes ~20 seconds"
		scp ~/Playbooks/BuilderHotspot/etc/locale.gen pi@$h:~/locale.gen > /dev/null
		ssh pi@$h "sudo mv ~/wpa_supplicant-wlan1.conf /etc/wpa_supplicant/wpa_supplicant-wlan1.conf; sudo mv ~/locale.gen /etc/locale.gen; exit"
		ssh pi@$h "sudo localedef -i en_US -f UTF-8 en_US.UTF-8;"
		ssh pi@$h "sudo localectl set-locale LANG=en_US.utf8;"
		echo ""
		echo "============================================================================================================================="
		echo "Evaluating if we should change $h to have last 6 digits of mac address appended to hostname"
		echo "============================================================================================================================="
		echo ""
		SHORTMAC=$(ssh pi@$h "tail -c 9 /sys/class/net/eth0/address | sed 's/://g';")

		EXISTINGNAME=$(ssh pi@$h "tail /etc/hostname")
		COMBINED=$EXISTINGNAME$SHORTMAC
		if [[ "$EXISTINGNAME" == "AnsibleDest" ]];
		then
			echo "Changing $EXISTINGNAME hostname to $COMBINED"
    		ssh pi@$h "sudo sed -i 's/AnsibleDest/$COMBINED/g' /etc/hostname; sudo sed -i 's/AnsibleDest/$COMBINED/g' /etc/hosts"
		else
    		echo "Hostname is currently $EXISTINGNAME"
			echo "Unexpected hostname detected.  No change made."
		fi
		echo "Rebooting Ansibledest.  Takes about 40 seconds"
		ssh pi@$h "sudo reboot now;"
		HOSTNAMETODELETE=$(echo "$COMBINED" | tr '[:upper:]' '[:lower:]')
		ssh-keygen -f "/home/pi/.ssh/known_hosts" -R $HOSTNAMETODELETE
	done
else
	echo ""
	echo "============================================================================================================================="
	echo "Configuring single host at AnsibleDest"
	echo "============================================================================================================================="
	echo ""
	ssh-copy-id -f -i ~/.ssh/id_rsa.pub pi@ansibledest
	scp ~/Playbooks/BuilderHotspot/etc/wpa_supplicant/wpa_supplicant-wlan1.conf pi@ansibledest:~/.
	scp ~/Playbooks/BuilderHotspot/etc/locale.gen pi@ansibledest:~/locale.gen
	ssh pi@ansibledest "sudo mv ~/wpa_supplicant-wlan1.conf /etc/wpa_supplicant/wpa_supplicant-wlan1.conf; sudo mv ~/locale.gen /etc/locale.gen; exit;"
	echo "Using localedef to download the en_US.UTF-8 locale (takes about 18 seconds)"
	date
	ssh pi@ansibledest "sudo localedef -i en_US -f UTF-8 en_US.UTF-8;"
	echo "Using localectl to install the en_US.UTF-8 locale"
	date
	echo "Rebooting Ansibledest.  Takes about 40 seconds"
	ssh pi@ansibledest "sudo reboot now;"
	ssh-keygen -R $COMBINED
	ssh-keygen -R 10.6.6.10
	ssh-keygen -R ansibledest
	echo "Sending 4 pings, once every 10 seconds"
	ping -D -i 10 -c 4 ansibledest
fi
