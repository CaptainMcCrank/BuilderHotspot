#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}**********************************************************"
echo -e "checking if ip_forwarding is active.  Value should be 1: "
echo -e "**********************************************************${NC}"
more /proc/sys/net/ipv4/ip_forward

echo -e "${RED}**********************************************************"
echo "flushing iptables forwarding & postrouting rules.  "
echo -e "**********************************************************${NC}"
iptables -t nat -F
iptables -F

echo -e "${RED}**********************************************************"
echo "Setting iptables rules.  "
echo -e "**********************************************************${NC}"
echo -e "set wlan0 as the outbound interface for NATing ${NC}"

iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -A FORWARD -i wlan1 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o wlan1 -j ACCEPT
iptables-save > /etc/iptables.rules


echo -e "${RED}**********************************************************"
echo "Checking iptables Forward, Prerouting & postrouting rules.  "
echo -e "**********************************************************${NC}"
iptables -L FORWARD --line-numbers
iptables -t nat -L POSTROUTING --line-numbers
iptables -t nat -L PREROUTING --line-numbers



