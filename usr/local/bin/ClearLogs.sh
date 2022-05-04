RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}**********************************************************${NC}"
echo -e "Clearing dns history"
echo -e "${RED}**********************************************************${NC}"

rm /tmp/dnsmasq.log

echo -e "${RED}**********************************************************${NC}"
echo -e "Clearing kern.log & syslog logs"
echo -e "${RED}**********************************************************${NC}"

echo > /dev/null | sudo tee /var/log/syslog
echo > /dev/null | sudo tee /var/log/kern.log

echo -e "${RED}**********************************************************${NC}"
echo -e "Run the following command to clear your bash history:"
echo -e "cat /dev/null > ~/.bash_history && history -c && exit"
echo -e "${RED}**********************************************************${NC}"
