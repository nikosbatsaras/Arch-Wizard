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

echo "Fill in the necessary information before installation begins:"

echo; echo

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

echo -n "

  _____           _   _       _             _             
 |  __ \         | | (_)     (_)           (_)            
 | |__) |_ _ _ __| |_ _ _ __  _  ___  _ __  _ _ __   __ _ 
 |  ___/ _' | '__| __| | '_ \| |/ _ \| '_ \| | '_ \ / _' |
 | |  | (_| | |  | |_| | | | | | (_) | | | | | | | | (_| |
 |_|   \__,_|_|   \__|_|_| |_|_|\___/|_| |_|_|_| |_|\__, |
                                                     __/ |
                                                    |___/
"
echo '
  _____             _          
 |  __ \           (_)         
 | |  | | _____   ___  ___ ___ 
 | |  | |/ _ \ \ / / |/ __/ _ \
 | |__| |  __/\ V /| | (_|  __/
 |_____/ \___| \_/ |_|\___\___|
                               
                      
'

sleep 2

(
echo 'n'         # Add new partition
echo 'p'         # Make new partition primary
echo             # Set default partition number
echo             # First sector (Accept default: 1)
echo "$partsize" # Last sector (Accept default: varies)
echo 'w'         # Write changes
) | sudo fdisk "$device"
