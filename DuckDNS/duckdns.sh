#!/bin/bash

whiptail --title "DuckDNS Update Script" --msgbox "This setup will create an update script to run via cron to ensure your external IP is kept upto date." 8 78
DOMAIN=$(whiptail --inputbox "What is your DuckDNS Domain Name?" 10 80 "" 3>&1 1>&2 2>&3)
TOKEN=$(whiptail --inputbox "What is your DuckDNS Token?" 10 80 "" 3>&1 1>&2 2>&3)

if [ -! d "/etc/duckdns" ]
then
    echo "Creating folder /etc/duckdns"
    sudo mkdir /etc/duckdns
    sleep 0.5
    echo "Done."
    sleep 0.5
fi
    
sudo touch /etc/duckdns/duckdns.sh

echo "#!/bin/sh" | sudo tee --append /etc/duckdns/duckdns.sh
echo "echo url="https://www.duckdns.org/update?domains=DOMAIN&token=TOKEN&ip=" | curl -k -o etc/duckdns/duck.log -K -" | sudo tee --append /etc/duckdns/duckdns.sh
sudo chmod 700 /etc/duckdns/duckdns.sh
RESPONSE=$(sudo /etc/duckdns/duckdns.sh)

if [ $RESPONSE == OK]
then
whiptail --title "DuckDNS Update Script" --msgbox "Success, all is working, a cronjob will now be added." 10 80
## add cronjob
(crontab -l ; echo "## DuckDNS Update") | crontab -
(crontab -l ; echo "*/5 * * * * /etc/duckdns/duckdns.sh >/dev/null 2>&1") | crontab -
(crontab -l ; echo "") | crontab -
else
whiptail --title "DuckDNS Update Script" --msgbox "Script has failed, please check your domain name and token carefully, and retrun" 10 80
fi


