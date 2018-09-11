#!/bin/sh

VERSION=006
clear
sleep 0.2
echo "================================================================"
echo "=====                Valiceemo adlists.list                ====="
echo "=====                   Credit to Wally3K                  ====="
echo "================================================================"

sleep 0.5
echo
echo "Script written by Valiceemo https://github.com/Valiceemo"
echo "All credit to Wally3K"
echo "The script is a simple means to add the lists compiled & managed by Wally3K to your own Pi-Hole install"
echo
echo "This list will take the lists from https://wally3k.github.io/ and add them to your pi-hole install"
echo
sleep 3
echo "Creating backup copy of adlists.list ==> /etc/pihole/adlists.list.bk"
sleep 0.5
sudo cp /etc/pihole/adlists.list /etc/pihole/adlists.list.bk
sleep 0.5
echo
echo "Done, backup is at /etc/pihole/adlists.list.bk"
echo
sleep 1
DOMAINS_BLOCKED_BEFORE=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
sleep 0.5

## Add Wally3K lists to Pi-hole, default is type=nocross, modify at own will / risk
echo "Adding lists to /etc/pihole/adlists.list..."
echo | sudo tee --append /etc/pihole/adlists.list
echo "#### Adlists modified by manunal script @ $(date)" | sudo tee --append /etc/pihole/adlists.list
echo | sudo tee --append /etc/pihole/adlists.list
curl --silent https://v.firebog.net/hosts/lists.php?type=nocross | sudo tee --append /etc/pihole/adlists.list 
sleep 2
echo "Done."
echo
sleep 1
## run pihole gravity update
echo "Starting pihole gravity...Please be patient"
echo "......"
sleep 0.2
sudo bash /etc/.pihole/gravity.sh
echo
echo "Completed, Pihole Gravity has been run with the added lists"
echo
echo "Checking No of blocked domains..."
sleep 3
DOMAINS_BLOCKED_AFTER=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
echo
echo "Domains being blocked before update:" $DOMAINS_BLOCKED_BEFORE
echo
echo "Domains being blocked after update:" $DOMAINS_BLOCKED_AFTER
sleep 0.5
