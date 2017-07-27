#!/bin/sh

VERSION=003

echo "================================================================"
echo "=====                Valiceemo adlists.list                ====="
echo "=====                   Credit to Wally3K                  ====="
echo "================================================================"

sleep 1

echo "Creating backup copy of adlists.list ==> /etc/pihole/adlists.list.bk"
sleep 1

sudo cp /etc/pihole/adlists.list /etc/pihole/adlists.list.bk
echo "DONE"
sleep 2
echo "Adding lists to /etc/pihole/adlists.list..."
sudo wget -s https://raw.githubusercontent.com/Valiceemo/pi-setup/master/PiHole/Valiceemo-adlists.list -P /etc/pihole
sleep 2
cat /etc/pihole/Valiceemo-adlists.list | sudo tee --append /etc/pihole/adlists.list
sleep 3
echo "DONE"

## Cleanup
echo "Cleaning up..."
sudo rm -f /etc/pihole/Valiceemo-adlists.list

## run pihole gravity update
echo "Running pihole gravity..."
sleep 3
sudo bash /etc/.pihole/gravity.sh &>/dev/null
echo "Completed, Pihole Gravity has been run with the added lists"

DOMAINS_BLOCKED_AFTER=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
DOMAINS_BLOCKED_BEFORE=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
echo "Domains being blocked before update:" $DOMAINS_BLOCKED_BEFORE
echo "Domains being blocked after update:" $DOMAINS_BLOCKED_AFTER
sleep 1

echo "Gathering detailed Pi-Hole stats..."
sleep 2
sudo /home/pi/scripts/system/network/pihole-stats.sh
