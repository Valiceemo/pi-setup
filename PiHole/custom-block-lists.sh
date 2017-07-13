#!/bin/sh

VERSION=001

echo "Adding lists to /etc/pihole/adlists.list..."
sleep 1
sudo echo "## HenningVanRaumle Youtube Ads" | sudo tee --append /etc/pihole/adlists.list
sudo echo "https://raw.githubusercontent.com/HenningVanRaumle/pihole-ytadblock/master/ytadblock.txt" | sudo tee --append /etc/pihole/adlists.list
sleep 1
sudo echo "## DeathByBandAid's piholeparser list" | sudo tee --append /etc/pihole/adlists.list
sudo echo "https://raw.githubusercontent.com/deathbybandaid/piholeparser/master/parsedall/1111ALLPARSEDLISTS1111edited.txt" | sudo tee --append /etc/pihole/adlists.list

## run pihole gravity update
echo "Running piholegravity..."
sleep 3
sudo bash /etc/.pihole/gravity.sh
sleep 2
echo "...all done..."
echo "Gathering Pi-Hole stats..."
sleep 2
sudo /home/pi/scripts/system/network/pihole-stats.sh
