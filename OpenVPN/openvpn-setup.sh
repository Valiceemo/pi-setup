#!/bin/sh

# Author: Richard Wallace // Valiceemo

# Scripted suetup of OpenVpn, allowing connection to PIA

clear
VERSION=002
sleep 1
echo "================================================================"
echo "=====                Valiceemo PIA + OpenVPN Setup         ====="
echo "================================================================"

sleep 1
echo "This script will help setup up Private internet Accesss with OpenVpn"
sleep 1

if [ -d "/etc/openvpn" ]
then
    echo "Creating Private Internet Access folder in /etc/openvpn"
    sudo mkdir /etc/openvpn/pia
    sleep 0.5
    echo "done"
else
    echo "OpenVpn does not appear to be installed"
    echo "Please install before running this script"
    sleep 0.5
    echo "Exiting"
    sleep 0.5
    exit
fi

echo "Downloading and unzipping PIA config files to /etc/openvpn/pia
sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip /etc/openvpn/pia
sudo unzip openvpn.zip -d /etc/openvpn/pia

# Copy desired .ovpn connection to .conf file
sudo cp sudo cp /etc/openvpn/pia/UK\ Southampton.ovpn /etc/openvpn/pia/uk.conf

## Create login details
whiptail --msgbox "Creating automated Private Internet Access Login..." 10 80 1
USER=$(whiptail --inputbox "Please enter your PIA username" 10 80 "" 3>&1 1>&2 2>&3)
PASSWORD=$(whiptail --inputbox "Please enter your PIA password" 10 80 "" 3>&1 1>&2 2>&3)

sudo nano /etc/openvpn/pia/login
sudo echo "$USER" | sudo tee --append /etc/openvpn/pia/login
sudo echo "$PASSWORD" | sudo tee --append /etc/openvpn/pia/login

## Edit .conf file to point to login and cert details

sudo sed -i 's/auth-user-pass/auth-user-pass /etc/openvpn/pia/login/g' /etc/openvpn/pia/uk.conf
sudo sed -i 's/ca ca.rsa.2048.crt/ca ca.rsa.2048.crt /etc/openvpn/pia/ca.rsa.2048.crt/g' /etc/openvpn/pia/uk.conf
sudo sed -i 's/crl-verif crl.rsa.2048.pem/crl-verif crl.rsa.2048.pem /etc/openvpn/pia/crl.rsa.2048.pem/g' /etc/openvpn/pia/uk.conf

## Connect now?

if (whiptail --title "Connect to PIA VPN now?" --yesno "Choose between Yes and No." 10 80)
then
sudo openvpn --config /etc/openvpn/pia/uk.conf
else
pass
fi
