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

echo "Fill out some information before installation begins:"

echo; echo

read    -p "Installation Device: /dev/"  device
read    -p "Partition Size (e.g. 15G): " partsize
read    -p "Hostname: "                  hostname
read    -p "Username: "                  username
read -s -p "Password: "                  password1
echo
read -s -p "Retype Password: "           password2

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

parttable=$(parted "/dev/$device" print | grep 'Partition Table' | awk '{print $3}')

if [ ! "$parttable" = "msdos" ]
then
	echo; echo
	echo "MBR partition table needed"
	echo "$parttable found"
	echo
	exit 1
fi

primaries=$(parted -s "/dev/$device" print | grep -c 'primary')

if [ "$primaries" -le 2 ]
then
	(
	echo 'n'          # Add new partition
	echo 'p'          # Make new partition primary
	echo              # Set default partition number
	echo              # First sector (Accept default: 1)
	echo "+$partsize" # Last sector (Accept default: varies)
	echo 'a'          # Mark partition bootable
	echo              # Pick default partition number
	echo 'w'          # Write changes
	) | fdisk "/dev/$device"
elif [ "$primaries" = 3 ]
then
	(
	echo 'n'          # Add new partition
	echo 'p'          # Make new partition primary
	echo              # First sector (Accept default: 1)
	echo "+$partsize" # Last sector (Accept default: varies)
	echo 'a'          # Mark partition bootable
	echo              # Pick default partition number
	echo 'w'          # Write changes
	) | fdisk "/dev/$device"
else
	echo; echo
	echo "Can't create more primary partitions"
	echo
	exit 1
fi

sudo partprobe "/dev/$device"

echo "

  _____           _        _ _ _                      
 |_   _|         | |      | | (_)                     
   | |  _ __  ___| |_ __ _| | |_ _ __   __ _     __ _ 
   | | | '_ \/ __| __/ _' | | | | '_ \ / _' |   / _' |
  _| |_| | | \__ \ || (_| | | | | | | | (_| |  | (_| |
 |_____|_| |_|___/\__\__,_|_|_|_|_| |_|\__, |   \__,_|
                                        __/ |         
                                       |___/          
  ______ _ _                     _                 
 |  ____(_) |                   | |                
 | |__   _| | ___  ___ _   _ ___| |_ ___ _ __ ___  
 |  __| | | |/ _ \/ __| | | / __| __/ _ \ '_ ' _ \ 
 | |    | | |  __/\__ \ |_| \__ \ ||  __/ | | | | |
 |_|    |_|_|\___||___/\__, |___/\__\___|_| |_| |_|
                        __/ |                      
                       |___/                       
"

partnum=$(grep -c "$device[0-9]" /proc/partitions)

mkfs.ext4 "/dev/$device$partnum"

mount "/dev/$device$partnum" /mnt

echo "
  ____              _       _                   
 |  _ \            | |     | |                  
 | |_) | ___   ___ | |_ ___| |_ _ __ __ _ _ __  
 |  _ < / _ \ / _ \| __/ __| __| '__/ _' | '_ \ 
 | |_) | (_) | (_) | |_\__ \ |_| | | (_| | |_) |
 |____/ \___/ \___/ \__|___/\__|_|  \__,_| .__/ 
                                         | |    
                                         |_|    
"

pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab

wget https://raw.githubusercontent.com/nickbatsaras/Arch-Wizard/master/chroot.sh
wget https://raw.githubusercontent.com/nickbatsaras/Arch-Wizard/master/rice.sh
wget https://raw.githubusercontent.com/nickbatsaras/Arch-Wizard/master/extras.sh

cp chroot.sh /mnt
cp rice.sh   /mnt
cp extras.sh /mnt

arch-chroot /mnt bash chroot.sh "$username" "$password1" "$device" "$hostname" "$partnum"

umount /mnt

echo "
  _____           _        _ _       _   _               
 |_   _|         | |      | | |     | | (_)              
   | |  _ __  ___| |_ __ _| | | __ _| |_ _  ___  _ __    
   | | | '_ \/ __| __/ _' | | |/ _' | __| |/ _ \| '_ \   
  _| |_| | | \__ \ || (_| | | | (_| | |_| | (_) | | | |  
 |_____|_| |_|___/\__\__,_|_|_|\__,_|\__|_|\___/|_|_|_|_ 
  / ____|                    | |    | |       | | | | | |
 | |     ___  _ __ ___  _ __ | | ___| |_ ___  | | | | | |
 | |    / _ \| '_ ' _ \| '_ \| |/ _ \ __/ _ \ | | | | | |
 | |___| (_) | | | | | | |_) | |  __/ ||  __/ |_| |_| |_|
  \_____\___/|_| |_| |_| .__/|_|\___|\__\___| (_) (_) (_)
                       | |                               
                       |_|                               
"

echo; echo "  You can now reboot ..."; echo
