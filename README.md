# BuilderHotspot
A solution for automating Raspberry Pi Development with Ansible from a wifi Hotspot running apt-cacher-ng

---
If you are looking for a better way to automate the development of Raspberry pis, this is the guide for you.
--- 


The Raspberry Pi is an optimal platform for hobbyists who want to build prototypes and learn about computers.  It does not make it easy for people who want to implement the guides they find on the Internet.  Users who follow  Internet-hosted Raspberry pi projects spend almost as much time troubleshooting stale documentation as they do troubleshooting their actual device.  I have fixed this problem by providing Raspberry Pi Developers an easier way to develop and share Raspberry pi IoT projects.  I present to you the Totally Rad Ansible Builder Wifi Hotspot.  You can use this platform in your Continuous development process to create a recipe that enables reproducible builds* of your raspberry pi project.

---

This guide will help you get your own Ansible Builder Hotspot up and running on a raspberry pi.  The builder hotspot’s primary features are:

- **A wifi network which can host target raspberry pis for automation**
- **An easy-to-use Ansible automation environment** that provisions configurations & customizations to raspberry pis attached to the wifi network
- **Build process acceleration** by locally hosting redundant software downloads via apt-cacher-ng 

If you do raspberry pi development, you should consider using this tooling to help you:
- **Start caching redundant package downloads via apt-cacher-ng embedded in the hotspot.**  The builder hotspot does this by caching unchanged Apt-get packages locally.  Apt-cacher-ng watches for updates and stores them local to your network them when they’re available. This means that after you’ve downloaded the packages for one device- they’re faster to be applied to the next device.
- **Make your projects more accessible to other developers via Ansible Build Scripts.**  Build automation helps you get closer to being a 10x developer.  10x developers make it easier for other people to take advantage of your projects.  Many pi projects ask users to install their projects via dangerous combinations of wget’ing a shell script and piping it to the shell. This is DANGEROUS and asks the end-user to extend an unreasonable amount of trust.  (e.g. wget -q -O - example.com/dontrunme.sh | bash).   Ansible scripts are transparent
- **Reduce insecure software embedded in your projects by applying the most recent security patches.**  The builder hotspot uses apt for pulling the most up-to-date software packages in your project.  This will ensure that the most recent versions of software dependencies are installed on your system without modifications to your build scripts or your local store of ready-to-compile packages. 
- **Inspect network traffic during package installs.** Sometimes devices do unexpected things because of software installed on the system.  This environment gives you a simple way to quickly analyze device traffic via common network tools like tcpdump, iptraf-ng, etc. 
- **Deploy dynamic images to multiple raspberry pis concurrently.**  The normal raspberry pi image distribution flow involves downloading an image, ripping it to an sd card and installing it.  If you have only one SDwriter, you’ll have to wait through the writing process for each card and manually intervene for each new device.  With this solution, you install lean Rasbpian images into each device and then push the deployed image to every device simultaneously. 


This recipe generates the builder hotspot.  It can be used to apply ansible playbooks to hosts attached to it's wifi network

This recipe has the following primary features
1. Hostapd preconfigured to produce a 802.11g wifi network with the ssid "Builderhotspot"
2. Preconfigured iptables ip forwarding rules so you can attach it to a an existing network via wifi or ethernet for network connectivity
3. Installation of Ansible & some preconfiguration for easy device management  
4. Installation & configuration of apt-cacher-ng for proxied downloads
5. Installation & configuration of afp, which gives mac users an AFP share to access directly from a dev workstation


# Prerequisites: 
- Raspberry Pi 3 B+ (x2) One runs a built version of the builder image downloadable at #URL#.  The second one will be used for receiving a build.)
- An internet connection (Wifi or ethernet work)
- Optional: If you want to use an existing wireless network for backhaul connectivity instead of the ethernet port on your Pi)
- The Panda wireless PAU05 is easy to source and is the device I test with.  https://www.amazon.com/Panda-300Mbps-Wireless-USB-Adapter/dp/B00EQT0YK2
- Raspberry Pi Imager software: https://www.raspberrypi.com/software/ 
- (x2+) 8gb SD cards (one that recieves the Builder image, and a second that will get a vanilla raspbian build.


# Setup steps:
1. Use Raspberry Pi imager to apply the "builder image" to your first SDCard.  The running builder image can be accessed via ssh at pi@builderhotspot.local on your home network.  The default password is ChangeDefaultPwd3331333
2. Use Raspberry Pi imager to apply a 32 bit Rasbperry Pi "recipient image" to your second SDCard.
3. Modify the image by launching advanced options (Ctrl+Shift+X).  The following changes configure the image to attach to the builder hotspot's wifi on powerup and prepare it for receiving recipes: 
    - Set the hostname to AnsibleDest.local  
    - Set the password to be ChangeDefaultPwd3331333 
    - Enable "Configure Wifi" and set an SSID of BuilderHotspot and a password of 8 p's "pppppppp"
    - Set the timezone & Locale as appropriate.  Please note that this recipe builds with the assumption that you want en_US.UTF-8 for your locale & language.  (If you want a different locale, you'll need to update the SetupRecipient.sh destination preparation script.

4. Install the builder image sdcard on the PI you'd like to use as your BuilderHotspot.  Attach an ethernet cable connected to your DHCP-enabled LAN to the ethernet port of your pi.  Power up!
5. After the builder device has fully booted, Install the recipient image sdcard on the Pi you'd like to use as your recipient.  If you'd like it to use wifi as backhaul, install your Panda wireless wifi adapter on the USB and power up!
6. ssh into the Builder hotspot (ssh pi@BuilderHotspot.local:ChangeDefaultPwd3331333) 
- CD into Playbooks/BuilderHotspot
- Confirm that the recipient image has attached to your wifi (arp -a | grep wlan0).  you should see a device called AnsibleDest attached.
- Prepare the recipient image for accepting ansible by running SetupRecipient.sh (./SetupRecipient.sh).  This script resets a few commonly used ssh keys for the local network, copies an ssh id to the recipient device and sets the Locale on the target to en_US.UTF-8 (as of October, 2021, the new Rasbian images still default to en_GB.UTF8, even if you set the locale to LosAngeles in the Raspbian imager. 
- After the recipient image reboots, you're ready to go!  Install the Builder Recipient image with the following command: 
`ansible-playbook -i /etc/ansible/hosts -u pi BuilderHotspot.yml`


Here's an image of the playbook build process in action:

![BuilderHotspotPlaybook](builderdemo.gif)

Move along.