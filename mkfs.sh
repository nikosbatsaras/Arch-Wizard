#!/usr/bin/env bash

device="$1"
boot_type="$2"
table_type="$3"

echo -e "\e[1;32m"
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
echo -e "\e[0m"

prefix=""

if [[ "$device" =~ ^nvme.*$ ]]; then
	prefix="p"
fi

if [ "$boot_type" = "bios" ]
then
	if [ "$table_type" = "mbr" ]
	then
		mkfs.ext4 -F "/dev/${device}${prefix}1"
		mkfs.ext4 -F "/dev/${device}${prefix}3"

		mount "/dev/${device}${prefix}1" /mnt

		mkdir /mnt/home

		mount "/dev/${device}${prefix}3" /mnt/home
	elif [ "$table_type" = "gpt" ]
	then
		mkfs.ext4 -F "/dev/${device}${prefix}2"
		mkfs.ext4 -F "/dev/${device}${prefix}4"

		mount "/dev/${device}${prefix}2" /mnt

		mkdir /mnt/home

		mount "/dev/${device}${prefix}4" /mnt/home
	fi
elif [ "$boot_type" = "uefi" ]
then
	mkfs.fat -F 32 "/dev/${device}${prefix}1"
	mkfs.ext4 -F "/dev/${device}${prefix}2"
	mkfs.ext4 -F "/dev/${device}${prefix}4"

	mount "/dev/${device}${prefix}2" /mnt

	mkdir /mnt/efi
	mkdir /mnt/home

	mount "/dev/${device}${prefix}1" /mnt/efi
	mount "/dev/${device}${prefix}4" /mnt/home
fi
