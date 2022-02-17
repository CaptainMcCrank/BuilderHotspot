#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
service hostapd stop
echo -e "${RED}**********************************************************${NC}"
echo -e "checking if ip_forwarding is active.  Value should be 1: "
echo -e "${RED}**********************************************************${NC}"
more /proc/sys/net/ipv4/ip_forward

echo -e "${RED}**********************************************************${NC}"
echo "flushing iptables forwarding & postrouting rules.  "
echo -e "${RED}**********************************************************${NC}"
iptables -t nat -F
iptables -F


echo -e "${RED}**********************************************************${NC}"
echo "Setting iptables rules.  "
echo -e "${RED}**********************************************************${NC}"

iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE                                       
iptables -A FORWARD -i wlan0 -o wlan1 -m state --state RELATED,ESTABLISHED -j ACCEPT         
iptables -A FORWARD -i wlan1 -o wlan0 -j ACCEPT      

bash -c "iptables-save > /etc/iptables.rules"

echo -e "${RED}**********************************************************${NC}"
echo "Launching hostapd with verbose logging.  "
echo -e "${RED}**********************************************************${NC}"

sudo /etc/init.d/hostapd status

echo -e "${RED}**********************************************************${NC}"
echo "Changing /etc/init.d/hostapd to password access point configuration  "
echo -e "${RED}**********************************************************${NC}"

#sed -i -e 's/DAEMON_CONF=\/etc\/hostapd\/openHostAPD.conf/DAEMON_CONF=\/etc\/hostapd\/privateHostAPD.conf/g' /etc/init.d/hostapd
sed -i -e 's/DAEMON_CONF=.*/DAEMON_CONF=\/etc\/hostapd\/privateFWDHostAPD.conf/g' /etc/default/hostapd #/etc/default/hostapd 

systemctl daemon-reload
/etc/init.d/hostapd start
