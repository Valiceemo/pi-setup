#!/bin/bash

today=$(date +%Y%m%d)
TIMESTAMP=`date +%Y/%m/%d_%H:%M:%S`

LogFile=/home/pi/logs/pihole.log
PiholeDir=/etc/pihole

TICK="[\e[32m ? \e[0m]"
INFO="[i]"

## Check for Log file, if missing create
if [ ! -e $LogFile ]
then
  echo -e "  ${INFO} \e[32m Creating log file... \e[0m"
  mkdir /home/pi/logs
  touch $LogFile
  echo "### Log file created $today | tee -a $LogFile >/dev/null
fi

echo -n "  ${INFO) \e[32m Backing up existing adlists.list...\e[0m"
sudo cp /etc/pihole/adlists.list /etc/adlists.list.bk.$TIMESTAMP
sleep 1
echo -e "\\r  ${TICK} \e[32m Backup made to /etc/pihole/adlists.list.bk.$TIMESTAMP  \e[0m"

echo -n "  ${INFO} \e[32m Restoring adlists.list to installation default \e0[m"
echo "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" | sudo tee /etc/pihole/adlists.list >/dev/null
echo "https://mirror1.malwaredomains.com/files/justdomains" | sudo tee -a /etc/pihole/adlists.list >/dev/null

echo -e "\\r  ${TICK} \e[32m Lists returned to default  \e[0m"
echo -n "  ${INFO} \e[32m Running Pi-Hole gravity to apply changes \e0[m"

echo -e "\\r  ${TICK} Pi-hole Gravity is completed"
### Default lists
#https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
#https://mirror1.malwaredomains.com/files/justdomains
#http://sysctl.org/cameleon/hosts
#https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist
#https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
#https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
#https://hosts-file.net/ad_servers.txt
