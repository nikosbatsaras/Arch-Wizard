#!/usr/bin/env bash

echo "
                    _       _____           _        _  _           
     /\            | |     |_   _|         | |      | || |          
    /  \   _ __ ___| |__     | |  _ __  ___| |_ __ _| || | ___ _ __ 
   / /\ \ | '__/ __| '_ \    | | | '_ \/ __| __/ _' | || |/ _ \ '__|
  / ____ \| | | (__| | | |  _| |_| | | \__ \ || (_| | || |  __/ |   
 /_/    \_\_|  \___|_| |_| |_____|_| |_|___/\__\__,_|_||_|\___|_|   
                                                                   
"


echo
echo "This script will install Arch Linux and apply
configurations found at: https://github.com/nickbatsaras"

echo

echo "The installation process can go unattended."
echo
echo "Fill in the necessary information before installation begins:"

echo
echo

read    -p "Installation Device: "  device
read    -p "Partition Size: "       partsize
read    -p "Hostname: "             hostname
read    -p "Username: "             username
read -s -p "Password: "             password1
echo
read -s -p "Retype Password: "      password2

if [ ! "$password1" = "$password2" ]
then
	echo; echo
	echo "Passwords do not match"
	echo
	exit 1
fi

echo
