#!/bin/sh

VERSION=004

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
sudo wget -qO - https://v.firebog.net/hosts/lists.php?type=tick | sudo tee /etc/pihole/adlists.list
sleep 2

echo "DONE"

## run pihole gravity update
echo "Running pihole gravity..."
sleep 3
sudo bash /etc/.pihole/gravity.sh > /dev/null 2>&1
echo "Completed, Pihole Gravity has been run with the added lists"

DOMAINS_BLOCKED_AFTER=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
DOMAINS_BLOCKED_BEFORE=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
echo "Domains being blocked before update:" $DOMAINS_BLOCKED_BEFORE
echo "Domains being blocked after update:" $DOMAINS_BLOCKED_AFTER
sleep 1

echo "Gathering detailed Pi-Hole stats..."
sleep 2
sudo /home/pi/scripts/system/network/pihole-stats.sh
