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

read    -p "Installation Device: /dev/"  device
read    -p "Partition Size: "            partsize
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

sleep 2

(
echo 'n'         # Add new partition
echo 'p'         # Make new partition primary
echo             # Set default partition number
echo             # First sector (Accept default: 1)
echo "$partsize" # Last sector (Accept default: varies)
echo 'w'         # Write changes
) | sudo fdisk "/dev/$device"

sudo partprobe "/dev/$device"

echo "

  _____           _        _ _ _                         ______ _ _                     _                 
 |_   _|         | |      | | (_)                       |  ____(_) |                   | |                
   | |  _ __  ___| |_ __ _| | |_ _ __   __ _     __ _   | |__   _| | ___  ___ _   _ ___| |_ ___ _ __ ___  
   | | | '_ \/ __| __/ _' | | | | '_ \ / _' |   / _' |  |  __| | | |/ _ \/ __| | | / __| __/ _ \ '_ ' _ \ 
  _| |_| | | \__ \ || (_| | | | | | | | (_| |  | (_| |  | |    | | |  __/\__ \ |_| \__ \ ||  __/ | | | | |
 |_____|_| |_|___/\__\__,_|_|_|_|_| |_|\__, |   \__,_|  |_|    |_|_|\___||___/\__, |___/\__\___|_| |_| |_|
                                        __/ |                                  __/ |                      
                                       |___/                                  |___/                       
"

partnum=$(grep -c "$device[0-9]" /proc/partitions)

sudo mkfs.ext4 "/dev/$device$partnum"

sudo mount "/dev/$device$partnum" /mnt

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

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Athens /etc/localtime 

sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/# el_GR.UTF-8 UTF-8/el_GR.UTF-8 UTF-8/' /etc/locale.gen

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf

export LANG=en_US.UTF-8

echo "$hostname" > /etc/hostname

pacman -S grub os-prober
grub-install "/dev/$device$partnum"
grub-mkconfig -o /boot/grub/grub.cfg

echo "$password1" | passwd --stdin

useradd -m -G users,wheel -s /bin/bash "$username"

echo "$password1" | passwd "$username" --stdin

sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/locale.gen
