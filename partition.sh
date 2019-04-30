#!/usr/bin/env bash

device="$1"
boot_type="$2"
table_type="$3"
root_size="$4"
home_size="$5"

echo -e "\e[1;32m"
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
echo -e "\e[0m"

prefix=""

if [[ "$device" =~ ^nvme.*$ ]]; then
	prefix="p"
fi

if [ "$boot_type" = "bios" ]
then
	if [ "$table_type" = "mbr" ]
	then
		swap_size=$(echo "${root_size} + 1" | bc)
		home_size=$(echo "${swap_size} + ${home_size}" | bc)

		parted --script "/dev/${device}" mklabel msdos
		parted --script "/dev/${device}" mkpart primary            "1MiB" "${root_size}GiB"
		parted --script "/dev/${device}" mkpart primary "${root_size}GiB" "${swap_size}GiB"
		parted --script "/dev/${device}" mkpart primary "${swap_size}GiB" "${home_size}GiB"

		parted --script "/dev/${device}" set 1 boot on
		parted --script "/dev/${device}" set 1 root on
		parted --script "/dev/${device}" set 2 swap on

		mkswap "/dev/${device}${prefix}2"
		swapon "/dev/${device}${prefix}2"
	elif [ "$table_type" = "gpt" ]
	then
		swap_size=$(echo "${root_size} + 1" | bc)
		home_size=$(echo "${swap_size} + ${home_size}" | bc)

		parted --script "/dev/${device}" mklabel gpt
		parted --script "/dev/${device}" mkpart primary            "1MiB"            "2MiB"
		parted --script "/dev/${device}" mkpart primary            "2MiB" "${root_size}GiB"
		parted --script "/dev/${device}" mkpart primary "${root_size}GiB" "${swap_size}GiB"
		parted --script "/dev/${device}" mkpart primary "${swap_size}GiB" "${home_size}GiB"

		parted --script "/dev/${device}" set 1 bios_grub on
		parted --script "/dev/${device}" set 2 boot on
		parted --script "/dev/${device}" set 2 root on
		parted --script "/dev/${device}" set 3 swap on

		mkswap "/dev/${device}${prefix}3"
		swapon "/dev/${device}${prefix}3"
	fi
elif [ "$boot_type" = "uefi" ]
then
	swap_size=$(echo "${root_size} + 1" | bc)
	home_size=$(echo "${swap_size} + ${home_size}" | bc)

	parted --script "/dev/${device}" mklabel gpt
	parted --script "/dev/${device}" mkpart primary            "1MiB"            "1GiB"
	parted --script "/dev/${device}" mkpart primary            "1GiB" "${root_size}GiB"
	parted --script "/dev/${device}" mkpart primary "${root_size}GiB" "${swap_size}GiB"
	parted --script "/dev/${device}" mkpart primary "${swap_size}GiB" "${home_size}GiB"

	parted --script "/dev/${device}" set 2 boot on
	parted --script "/dev/${device}" set 2 root on
	parted --script "/dev/${device}" set 3 swap on

	mkswap "/dev/${device}${prefix}3"
	swapon "/dev/${device}${prefix}3"
fi

partprobe "/dev/$device"
