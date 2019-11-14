#!/usr/bin/env bash

clear

echo -e "\e[32m"
echo "                    _               __          ___                  _   ";
echo "     /\            | |              \ \        / (_)                | |  ";
echo "    /  \   _ __ ___| |__    ______   \ \  /\  / / _ ______ _ _ __ __| |  ";
echo "   / /\ \ | '__/ __| '_ \  |______|   \ \/  \/ / | |_  / _\` | '__/ _\` |";
echo "  / ____ \| | | (__| | | |             \  /\  /  | |/ / (_| | | | (_| |  ";
echo " /_/    \_\_|  \___|_| |_|              \/  \/   |_/___\__,_|_|  \__,_|  ";
echo "                                                                         ";
echo "                                                                         ";
echo
echo "              This script will install Arch Linux and apply              ";
echo "        configurations found at: https://github.com/nikosbatsaras        ";
echo
echo -e "\e[0m"
echo
echo "Fill out some information before installation begins:"

echo; echo; lsblk; echo; echo

read -p $'\e[32mInstallation Device:\e[0m /dev/' device

if [ ! -b "/dev/$device" ]; then
	echo; echo -e "\e[1;31m"
	echo "Invalid device."
	echo
	echo -e "\e[0m"
	exit 1
fi

read -p $'\e[32mBoot (bios or uefi):\e[0m ' boot_type

if [ ! "$boot_type" = "bios" ] && [ ! "$boot_type" = "uefi" ]
then
	echo; echo -e "\e[1;31m"
	echo "Invalid boot type."
	echo
	echo -e "\e[0m"
	exit 1
fi

if [ "$boot_type" = "bios" ]
then
	read -p $'\e[32mPartition table type (mbr or gpt):\e[0m ' table_type

	if [ ! "$table_type" = "mbr" ] && [ ! "$table_type" = "gpt" ]
	then
		echo; echo -e "\e[1;31m"
		echo "Invalid partition table type."
		echo
		echo -e "\e[0m"
		exit 1
	fi
fi

read -p $'\e[32mRoot partition size in GBs (e.g. 20):\e[0m ' root_size
read -p $'\e[32mHome partition size in GBs (e.g. 30):\e[0m ' home_size

if [ "$root_size" -le 0 ] || [ "$home_size" -le 0 ]
then
	echo; echo -e "\e[1;31m"
	echo "Invalid partition size."
	echo
	echo -e "\e[0m"
	exit 1
fi

read    -p $'\e[32mHostname:\e[0m ' hostname
read    -p $'\e[32mUsername:\e[0m ' username
read -s -p $'\e[32mPassword:\e[0m ' password1
echo
read -s -p $'\e[32mRetype Password:\e[0m ' password2

if [ ! "$password1" = "$password2" ]
then
	echo; echo -e "\e[1;31m"
	echo "Passwords do not match."
	echo
	echo -e "\e[0m"
	exit 1
fi

wget https://raw.githubusercontent.com/nikosbatsaras/Arch-Wizard/master/partition.sh
wget https://raw.githubusercontent.com/nikosbatsaras/Arch-Wizard/master/mkfs.sh

bash partition.sh "$device" "$boot_type" "$table_type" "$root_size" "$home_size"
bash mkfs.sh      "$device" "$boot_type" "$table_type"

echo -e "\e[32m"
echo "  ____              _       _                    ";
echo " |  _ \            | |     | |                   ";
echo " | |_) | ___   ___ | |_ ___| |_ _ __ __ _ _ __   ";
echo " |  _ < / _ \ / _ \| __/ __| __| '__/ _\` | '_ \ ";
echo " | |_) | (_) | (_) | |_\__ \ |_| | | (_| | |_) | ";
echo " |____/ \___/ \___/ \__|___/\__|_|  \__,_| .__/  ";
echo "                                         | |     ";
echo "                                         |_|     ";
echo -e "\e[0m"

sed -i '7iServer = http://ftp.otenet.gr/linux/archlinux/$repo/os/$arch'               /etc/pacman.d/mirrorlist
sed -i '7iServer = http://foss.aueb.gr/mirrors/linux/archlinux/$repo/os/$arch'        /etc/pacman.d/mirrorlist
sed -i '7iServer = http://mirrors.myaegean.gr/linux/archlinux/$repo/os/$arch'         /etc/pacman.d/mirrorlist
sed -i '7iServer = http://ftp.ntua.gr/pub/linux/archlinux/$repo/os/$arch'             /etc/pacman.d/mirrorlist
sed -i '12iServer = http://mi.mirror.garr.it/mirrors/archlinux/$repo/os/$arch'        /etc/pacman.d/mirrorlist
sed -i '13iServer = http://ftp.hosteurope.de/mirror/ftp.archlinux.org/$repo/os/$arch' /etc/pacman.d/mirrorlist
sed -i '14iServer = http://mirror.cyberbits.eu/archlinux/$repo/os/$arch'              /etc/pacman.d/mirrorlist

pacstrap /mnt base linux linux-firmware base-devel

genfstab -U /mnt >> /mnt/etc/fstab

wget https://raw.githubusercontent.com/nikosbatsaras/Arch-Wizard/master/chroot.sh
wget https://raw.githubusercontent.com/nikosbatsaras/Arch-Wizard/master/rice.sh
wget https://raw.githubusercontent.com/nikosbatsaras/Arch-Wizard/master/extras.sh

cp chroot.sh rice.sh extras.sh /etc/pacman.d/mirrorlist /mnt

arch-chroot /mnt bash chroot.sh "$username" "$password1" "$device" "$hostname"

rm /mnt/chroot.sh /mnt/rice.sh /mnt/extras.sh

umount -R /mnt

echo -e "\e[32m"
echo "  _____           _        _ _       _   _               ";
echo " |_   _|         | |      | | |     | | (_)              ";
echo "   | |  _ __  ___| |_ __ _| | | __ _| |_ _  ___  _ __    ";
echo "   | | | '_ \/ __| __/ _\` | | |/ _\` | __| |/ _ \| '_ \ ";
echo "  _| |_| | | \__ \ || (_| | | | (_| | |_| | (_) | | | |  ";
echo " |_____|_| |_|___/\__\__,_|_|_|\__,_|\__|_|\___/|_| |_|  ";
echo "   _____                      _      _         _ _ _     ";
echo "  / ____|                    | |    | |       | | | |    ";
echo " | |     ___  _ __ ___  _ __ | | ___| |_ ___  | | | |    ";
echo " | |    / _ \| '_ \` _ \| '_ \| |/ _ \ __/ _ \ | | | |   ";
echo " | |___| (_) | | | | | | |_) | |  __/ ||  __/ |_|_|_|    ";
echo "  \_____\___/|_| |_| |_| .__/|_|\___|\__\___| (_|_|_)    ";
echo "                       | |                               ";
echo "                       |_|                               ";

echo; echo "  You can now reboot ..."; echo
echo -e "\e[0m"
