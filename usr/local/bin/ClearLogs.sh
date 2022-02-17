RED='\033[0;31m'
NC='\033[0m'
echo -e "${RED}**********************************************************${NC}"
echo -e "Clearing sslsplit_connections directory & sslsplit.log file"
echo -e "${RED}**********************************************************${NC}"

rm -rf /var/www/html/sslsplit_connections/*
rm /var/www/html/sslsplit.log

echo -e "${RED}**********************************************************${NC}"
echo -e "Clearing dns history"
echo -e "${RED}**********************************************************${NC}"

rm /tmp/dnsmasq.log

echo -e "${RED}**********************************************************${NC}"
echo -e "Clearing HotspotStatusCollector logs"
echo -e "${RED}**********************************************************${NC}"

rm /var/log/HotspotStatusCollector.err.log
rm /var/log/HotspotStatusCollector.log

echo -e "${RED}**********************************************************${NC}"
echo -e "Clearing StateServer logs"
echo -e "${RED}**********************************************************${NC}"

rm /var/log/StateServer.err.log
rm /var/log/StateServer.log

echo -e "${RED}**********************************************************${NC}"
echo -e "Clearing webUI_server logs"
echo -e "${RED}**********************************************************${NC}"

rm /var/log/webUI_server.err.log
rm /var/log/webUI_server.log


echo -e "${RED}**********************************************************${NC}"
echo -e "Clearing kern.log & syslog logs"
echo -e "${RED}**********************************************************${NC}"

echo > /dev/null | sudo tee /var/log/syslog
echo > /dev/null | sudo tee /var/log/kern.log

echo -e "${RED}**********************************************************${NC}"
echo -e "Run the following command to clear your bash history:"
echo -e "cat /dev/null > ~/.bash_history && history -c && exit"
echo -e "${RED}**********************************************************${NC}"
