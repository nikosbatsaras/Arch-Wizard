#!/usr/bin/env bash

device="$1"
boot_type="$2"
table_type="$3"

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

if [ "$boot_type" = "bios" ]
then
	if [ "$table_type" = "mbr" ]
	then
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
	elif [ "$table_type" = "gpt" ]
	then
		if [[ "$device" =~ ^nvme.*$ ]]
		then
			mkfs.ext4 -F "/dev/${device}p2"
			mkfs.ext4 -F "/dev/${device}p4"

			mount "/dev/${device}p2" /mnt

			mkdir /mnt/home

			mount "/dev/${device}p4" /mnt/home
		else
			mkfs.ext4 -F "/dev/${device}2"
			mkfs.ext4 -F "/dev/${device}4"

			mount "/dev/${device}2" /mnt

			mkdir /mnt/home

			mount "/dev/${device}4" /mnt/home
		fi
	fi
elif [ "$boot_type" = "uefi" ]
then
	if [[ "$device" =~ ^nvme.*$ ]]
	then
		mkfs.fat -F 32 "/dev/${device}p1"
		mkfs.ext4 -F "/dev/${device}p2"
		mkfs.ext4 -F "/dev/${device}p4"

		mount "/dev/${device}p2" /mnt

		mkdir /mnt/efi
		mkdir /mnt/home

		mount "/dev/${device}p1" /mnt/efi
		mount "/dev/${device}p4" /mnt/home
	else
		mkfs.fat -F 32 "/dev/${device}1"
		mkfs.ext4 -F "/dev/${device}2"
		mkfs.ext4 -F "/dev/${device}4"

		mount "/dev/${device}2" /mnt

		mkdir /mnt/efi
		mkdir /mnt/home

		mount "/dev/${device}1" /mnt/efi
		mount "/dev/${device}4" /mnt/home
	fi
fi
