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
echo "                This script will install Arch Linux and apply            ";
echo "           configurations found at: https://github.com/nickbatsaras      ";
echo
echo
echo
echo "Fill out some information before installation begins:"

echo; echo; lsblk; echo; echo

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
	partnum=p$(grep -c "${device}p[0-9]" /proc/partitions)
else
	partnum=$(grep -c "$device[0-9]" /proc/partitions)
fi

mkfs.ext4 -F "/dev/$device$partnum"

mount "/dev/$device$partnum" /mnt

echo "  ____              _       _                    ";
echo " |  _ \            | |     | |                   ";
echo " | |_) | ___   ___ | |_ ___| |_ _ __ __ _ _ __   ";
echo " |  _ < / _ \ / _ \| __/ __| __| '__/ _\` | '_ \ ";
echo " | |_) | (_) | (_) | |_\__ \ |_| | | (_| | |_) | ";
echo " |____/ \___/ \___/ \__|___/\__|_|  \__,_| .__/  ";
echo "                                         | |     ";
echo "                                         |_|     ";

sed -i '7iServer = http://ftp.otenet.gr/linux/archlinux/$repo/os/$arch'               /etc/pacman.d/mirrorlist
sed -i '7iServer = http://ftp.ntua.gr/pub/linux/archlinux/$repo/os/$arch'             /etc/pacman.d/mirrorlist
sed -i '7iServer = http://foss.aueb.gr/mirrors/linux/archlinux/$repo/os/$arch'        /etc/pacman.d/mirrorlist
sed -i '7iServer = http://mirrors.myaegean.gr/linux/archlinux/$repo/os/$arch'         /etc/pacman.d/mirrorlist
sed -i '7iServer = http://ftp.cc.uoc.gr/mirrors/linux/archlinux/$repo/os/$arch'       /etc/pacman.d/mirrorlist
sed -i '12iServer = http://mi.mirror.garr.it/mirrors/archlinux/$repo/os/$arch'        /etc/pacman.d/mirrorlist
sed -i '13iServer = http://ftp.hosteurope.de/mirror/ftp.archlinux.org/$repo/os/$arch' /etc/pacman.d/mirrorlist
sed -i '14iServer = http://mirror.cyberbits.eu/archlinux/$repo/os/$arch'              /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab

wget https://raw.githubusercontent.com/nickbatsaras/Arch-Wizard/master/chroot.sh
wget https://raw.githubusercontent.com/nickbatsaras/Arch-Wizard/master/rice.sh
wget https://raw.githubusercontent.com/nickbatsaras/Arch-Wizard/master/extras.sh

cp chroot.sh rice.sh extras.sh /mnt

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
