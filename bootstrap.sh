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

read    -p "Installation Device: /dev/"              device
read    -p "Root partition size in GBs (e.g. 20G): " root_size
read    -p "Home partition size in GBs (e.g. 30G): " home_size
read    -p "Hostname: "                              hostname
read    -p "Username: "                              username
read -s -p "Password: "                              password1
echo
read -s -p "Retype Password: "                       password2

if [ ! "$password1" = "$password2" ]
then
	echo; echo
	echo "Passwords do not match"
	echo
	exit 1
fi

echo "  _____           _   _ _   _             _               ";
echo " |  __ \         | | (_) | (_)           (_)              ";
echo " | |__) |_ _ _ __| |_ _| |_ _  ___  _ __  _ _ __   __ _   ";
echo " |  ___/ _\` | '__| __| | __| |/ _ \| '_ \| | '_ \ / _\` |";
echo " | |  | (_| | |  | |_| | |_| | (_) | | | | | | | | (_| |  ";
echo " |_|   \__,_|_|   \__|_|\__|_|\___/|_| |_|_|_| |_|\__, |  ";
echo "  _____             _                              __/ |  ";
echo " |  __ \           (_)                            |___/   ";
echo " | |  | | _____   ___  ___ ___                            ";
echo " | |  | |/ _ \ \ / / |/ __/ _ \                           ";
echo " | |__| |  __/\ V /| | (_|  __/                           ";
echo " |_____/ \___| \_/ |_|\___\___|                           ";
echo "                                                          ";
echo "                                                          ";

swap_size=$(echo "${root_size} + 1" | bc)
home_size=$(echo "${swap_size} + ${home_size}" | bc)

parted --script "/dev/${device}" mklabel pgt
parted --script "/dev/${device}" mkpart primary            "1MiB" "${root_size}GiB"
parted --script "/dev/${device}" mkpart primary "${root_size}GiB" "${swap_size}GiB"
parted --script "/dev/${device}" mkpart primary "${swap_size}GiB" "${home_size}GiB"

parted --script "/dev/${device}" set 1 boot on

if [[ "$device" =~ ^nvme.*$ ]]; then
	mkswap "/dev/${device}p2"
	swapon "/dev/${device}p2"
else
	mkswap "/dev/${device}2"
	swapon "/dev/${device}2"
fi

partprobe "/dev/$device"

echo "  _____           _        _ _ _                        ";
echo " |_   _|         | |      | | (_)                       ";
echo "   | |  _ __  ___| |_ __ _| | |_ _ __   __ _    __ _    ";
echo "   | | | '_ \/ __| __/ _\` | | | | '_ \ / _\` |  / _\` |";
echo "  _| |_| | | \__ \ || (_| | | | | | | | (_| | | (_| |   ";
echo " |_____|_| |_|___/\__\__,_|_|_|_|_| |_|\__, |  \__,_|   ";
echo "  ______ _ _                     _      __/ |           ";
echo " |  ____(_) |                   | |    |___/            ";
echo " | |__   _| | ___  ___ _   _ ___| |_ ___ _ __ ___       ";
echo " |  __| | | |/ _ \/ __| | | / __| __/ _ \ '_ \` _ \     ";
echo " | |    | | |  __/\__ \ |_| \__ \ ||  __/ | | | | |     ";
echo " |_|    |_|_|\___||___/\__, |___/\__\___|_| |_| |_|     ";
echo "                        __/ |                           ";
echo "                       |___/                            ";

if [[ "$device" =~ ^nvme.*$ ]]
then
	mkfs.ext4 -F "/dev/${device}p1"
	mkfs.ext4 -F "/dev/${device}p3"

	mount "/dev/${device}p1" /mnt

	mkdir /mnt/home

	mount "/dev/${device}p3" /mnt/home
else
	mkfs.ext4 -F "/dev/${device}1"
	mkfs.ext4 -F "/dev/${device}3"

	mount "/dev/${device}1" /mnt

	mkdir /mnt/home

	mount "/dev/${device}3" /mnt/home
fi

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

umount /mnt

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
