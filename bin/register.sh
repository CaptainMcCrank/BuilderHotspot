#!/bin/sh
# Device Registration Script
# 2/26/22
# Patrick McCanna

# This script is a one shot device registration script.  Its purpose is to gather activation metrics about uptake recipes.
# The script collects the device's eth0 mac address as a unique id.  This value is hashed to protect your privacy & submitted to a web service.
# Since I only recieve a hash value, I do not have access to your actual mac address.
# I do not use salting in this solution, as it makes distinguishing new devices from reinstallations challenging. 
# Additionally, I register the os-release, and version data from /boot/device.ver that is only populated by my recipes.
# This data will help me determine if this project is successful and determine where to invest more time that creates value for others
# This script is meant to be run once & deactivated.
# I value your privacy.  I hope you understand that I collect this data to discover where others see value in my work.  It helps me 
# discover how to deliver solutions that the world needs.  I hope you will consider it a fair value-for-value trade.
# -Patrick

verFile="/boot/device.ver"
test=amazon.com
if nc -zw1 $test 443 && echo | openssl s_client -connect $test:443 2>&1 |awk '
  handshake && $1 == "Verification" { if ($2=="OK") exit; exit 1 } 
  $1 $2 == "SSLhandshake" { handshake = 1 }'
then
  hash=$(tail -c 9 /sys/class/net/eth0/address | sed 's/://g' | sha224sum) #grab a sha value of the eth0 mac address 
   
  modifiedhash=${hash%???} # Remove the last 3 characters, which will be " -" from the above line for reasons which I haven't identified.
  #cat /etc/os-release | grep PRETTY_NAME | sed 's/PRETTY_NAME=//' | sed 's/"//g'
  #Cat the file	       | get the PRETTY* line| use sed to remove PRETTY_name | use sed to remove all " from the string (via g)
  osrelease=$(cat /etc/os-release | grep PRETTY_NAME | sed 's/PRETTY_NAME=//' | sed 's/"//g')
  ver=$(cat $verFile | grep Ver: | sed 's/Ver: //')
  Build=$(cat $verFile | grep Build: | sed 's/Build: //')
  BuildDate=$(cat $verFile | grep BuildDate: | sed 's/BuildDate: //')
  Author=$(cat $verFile | grep Author: | sed 's/Author: //')


  poststring="{\"deviceID\":{\"DeviceID\":\"$modifiedhash\",\"Build\":\"$Build\",\"Ver\":\"$ver\",\"BuildDate\":\"$BuildDate\",\"Author\":\"$Author\",\"OS-Release\":\"$osrelease\"}}"
  echo "Sending: "$poststring
  curl -i \
	  -H "Accept: application/json" \
	  -H "Content-Type:application/json" \
	  -X POST --data "$poststring" https://4btgclxzmj.execute-api.us-west-2.amazonaws.com/DeviceMetrics/metricscollector 
	  
  echo "\n"
  systemctl --user disable register-device.timer --now
  systemctl --user disable register-device.service --now
fi
