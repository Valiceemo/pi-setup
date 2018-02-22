#!/bin/sh

VERSION=005

echo "================================================================"
echo "=====                Valiceemo adlists.list                ====="
echo "=====                   Credit to Wally3K                  ====="
echo "================================================================"

sleep 1

echo "This list will take the lists from https://wally3k.github.io/ and add them to your pi-hole install"
sleep 3
echo "Creating backup copy of adlists.list ==> /etc/pihole/adlists.list.bk"
DOMAINS_BLOCKED_BEFORE=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
sleep 0.5

sudo cp /etc/pihole/adlists.list /etc/pihole/adlists.list.bk
echo "DONE"
sleep 2
echo "Adding lists to /etc/pihole/adlists.list..."
echo "## Adlists modified by manunal script" | sudo tee --append /etc/pihole/adlists.list
sudo curl -s https://v.firebog.net/hosts/lists.php?type=nocross | sudo tee --append /etc/pihole/adlists.list 
sleep 2

echo "DONE"

## run pihole gravity update
echo "Starting pihole gravity...Please be patient"
sleep 0.2
sudo bash /etc/.pihole/gravity.sh >/dev/null 2>&1 &
pid=$! # Process Id of the previous running command
spin[0]="-"
spin[1]="\\"
spin[2]="|"
spin[3]="/"
echo -n "[Gravitating] ${spin[0]}"
while [ kill -0 $pid ]
do  
  for i in "${spin[@]}" 
  do        
        echo -ne "\b$i"        
        sleep 0.1  
  done
done

echo "Completed, Pihole Gravity has been run with the added lists"

DOMAINS_BLOCKED_AFTER=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
echo "Domains being blocked before update:" $DOMAINS_BLOCKED_BEFORE
echo "Domains being blocked after update:" $DOMAINS_BLOCKED_AFTER
sleep 0.5

echo "Gathering detailed Pi-Hole stats..."
sleep 2
sudo /home/pi/scripts/system/network/pihole-stats.sh
