#!/usr/bin/env bash

clear

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
echo
echo
echo "Fill out some information before installation begins:"

echo; echo; lsblk; echo; echo

read -p "Installation Device: /dev/" device

if [ ! -b "/dev/$device" ]; then
	echo; echo
	echo "Invalid device."
	echo
	exit 1
fi

read -p "Boot (bios or uefi): " boot_type

if [ ! "$boot_type" = "bios" ] && [ ! "$boot_type" = "uefi" ]
then
	echo; echo
	echo "Invalid boot type."
	echo
	exit 1
fi

if [ "$boot_type" = "bios" ]
then
	read -p "Partition table type (mbr or gpt): " table_type

	if [ ! "$table_type" = "mbr" ] && [ ! "$table_type" = "gpt" ]
	then
		echo; echo
		echo "Invalid partition table type."
		echo
		exit 1
	fi
fi

read -p "Root partition size in GBs (e.g. 20G): " root_size
read -p "Home partition size in GBs (e.g. 30G): " home_size

if [ "$root_size" -le 0 ] || [ "$home_size" -le 0 ]
then
	echo; echo
	echo "Invalid partition size."
	echo
	exit 1
fi

read    -p "Hostname: " hostname
read    -p "Username: " username
read -s -p "Password: " password1
echo
read -s -p "Retype Password: " password2

if [ ! "$password1" = "$password2" ]
then
	echo; echo
	echo "Passwords do not match."
	echo
	exit 1
fi

exit 1

wget https://raw.githubusercontent.com/nikosbatsaras/Arch-Wizard/master/partition.sh
wget https://raw.githubusercontent.com/nikosbatsaras/Arch-Wizard/master/mkfs.sh

bash partition.sh "$device" "$boot_type" "$table_type" "$root_size" "$home_size"
bash mkfs.sh      "$device" "$boot_type" "$table_type"

echo "  ____              _       _                    ";
echo " |  _ \            | |     | |                   ";
echo " | |_) | ___   ___ | |_ ___| |_ _ __ __ _ _ __   ";
echo " |  _ < / _ \ / _ \| __/ __| __| '__/ _\` | '_ \ ";
echo " | |_) | (_) | (_) | |_\__ \ |_| | | (_| | |_) | ";
echo " |____/ \___/ \___/ \__|___/\__|_|  \__,_| .__/  ";
echo "                                         | |     ";
echo "                                         |_|     ";

sed -i '7iServer = http://ftp.otenet.gr/linux/archlinux/$repo/os/$arch'               /etc/pacman.d/mirrorlist
sed -i '7iServer = http://foss.aueb.gr/mirrors/linux/archlinux/$repo/os/$arch'        /etc/pacman.d/mirrorlist
sed -i '7iServer = http://mirrors.myaegean.gr/linux/archlinux/$repo/os/$arch'         /etc/pacman.d/mirrorlist
sed -i '7iServer = http://ftp.ntua.gr/pub/linux/archlinux/$repo/os/$arch'             /etc/pacman.d/mirrorlist
sed -i '12iServer = http://mi.mirror.garr.it/mirrors/archlinux/$repo/os/$arch'        /etc/pacman.d/mirrorlist
sed -i '13iServer = http://ftp.hosteurope.de/mirror/ftp.archlinux.org/$repo/os/$arch' /etc/pacman.d/mirrorlist
sed -i '14iServer = http://mirror.cyberbits.eu/archlinux/$repo/os/$arch'              /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab

wget https://raw.githubusercontent.com/nikosbatsaras/Arch-Wizard/master/chroot.sh
wget https://raw.githubusercontent.com/nikosbatsaras/Arch-Wizard/master/rice.sh
wget https://raw.githubusercontent.com/nikosbatsaras/Arch-Wizard/master/extras.sh

cp chroot.sh rice.sh extras.sh /etc/pacman.d/mirrorlist /mnt

arch-chroot /mnt bash chroot.sh "$username" "$password1" "$device" "$hostname"

rm /mnt/chroot.sh /mnt/rice.sh /mnt/extras.sh

umount -R /mnt

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
