#!/bin/sh

NOW=$(date +"%y_%m_%d")

{ if 
(whiptail --title "Memory Split" --yes-button "Skip" --no-button "Proceed" --yesno "Do you want to set the gpu memory split." 10 80) 
then
echo "Cancelled"
else

MEM_SPLIT=$(whiptail --inputbox "Enter amount of memory to assign to the GPU - for headless go with 16." 10 80 "16" 3>&1 1>&2 2>&3)
sudo cp /boot/config.txt /home/pi/backups/boot/config-$NOW.txt.bk
sudo sed -i '/gpu_mem/ d' /boot/config.txt
sudo echo "gpu_mem=$MEM_SPLIT" | sudo tee --append /boot/config.txt

## End of install
fi }
