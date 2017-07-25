#!/bin/sh

VERSION=002

DOMAINS_BLOCKED_BEFORE=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
sleep 1
echo echo "Domains being blocked before update:" $DOMAINS_BLOCKED_BEFORE
sleep 3

echo "Creating backup copy of adlists.list ==> /etc/pihole/adlists.list.bk"
sleep 1

echo "..."

sudo cp /etc/pihole/adlists.list /etc/pihole/adlists.pihole.bk
sleep 3
echo "Adding lists to /etc/pihole/adlists.list..."
sudo wget https://raw.githubusercontent.com/Valiceemo/pi-setup/master/PiHole/Valiceemo-adlists.list /etc/pihole
sleep 3
cat /etc/pihole/Valiceemo-adlists.list | sudo tee --append /etc/pihole/adlists.list
sleep 3

## Cleanup
sudo rm -f /etc/pihole/Valiceemo-adlists.list

## run pihole gravity update
echo "Running pihole gravity..."
sleep 3
sudo bash /etc/.pihole/gravity.sh
sleep 2
echo "...all done..."
DOMAINS_BLOCKED_AFTER=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
DIFF=$(expr $DOMAINS_BLOCKED_AFTER - $DOMAINS_BLOCKED_BEFORE)

sleep 1
echo "Now blocking" $DOMAINS_BLOCKED_AFTER "domains"
echo $DIFF "domains added"

sleep 2
echo "Gathering detailed Pi-Hole stats..."
sleep 2
sudo /home/pi/scripts/system/network/pihole-stats.sh
