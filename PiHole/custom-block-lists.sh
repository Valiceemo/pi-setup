#!/bin/sh

echo "Adding lists to /etc/pihole/adlists.list..."

sudo echo "## HenningVanRaumle Youtube Ads" | sudo tee --append /etc/pihole/adlists.list
sudo echo "https://raw.githubusercontent.com/HenningVanRaumle/pihole-ytadblock/master/ytadblock.txt" | sudo tee --append /etc/pihole/adlists.list

sudo echo "## DeathByBandAid's piholeparser list" | sudo tee --append /etc/pihole/adlists.list
sudo echo "https://raw.githubusercontent.com/deathbybandaid/piholeparser/master/parsedall/1111ALLPARSEDLISTS1111edited.txt" | sudo tee --append /etc/pihole/adlists.list

## run pihole gravity update
echo "Running piholegravity..."
sudo bash /etc/.pihole/gravity.sh

echo "...all done..."
sudo /home/pi/scripts/system/network/pihole-stats.sh
