#!/usr/bin/env bash

username="$1"
password="$2"
device="$3"
hostname="$4"

echo "  _______ _                           ";
echo " |__   __(_)                  ___     ";
echo "    | |   _ _ __ ___   ___   ( _ )    ";
echo "    | |  | | '_ \` _ \ / _ \  / _ \/\\";
echo "    | |  | | | | | | |  __/ | (_>  <  ";
echo "    |_|  |_|_| |_| |_|\___|  \___/\/  ";
echo "  _                     _             ";
echo " | |                   | |            ";
echo " | |     ___   ___ __ _| | ___  ___   ";
echo " | |    / _ \ / __/ _\` | |/ _ \/ __| ";
echo " | |___| (_) | (_| (_| | |  __/\__ \\ ";
echo " |______\___/ \___\__,_|_|\___||___/  ";
echo "                                      ";
echo "                                      ";

ln -sf /usr/share/zoneinfo/Europe/Athens /etc/localtime 

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#el_GR.UTF-8 UTF-8/el_GR.UTF-8 UTF-8/' /etc/locale.gen

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf

export LANG=en_US.UTF-8

echo "$hostname" > /etc/hostname

mv /mirrorlist /etc/pacman.d/mirrorlist

echo "  ____              _   _                 _             ";
echo " |  _ \            | | | |               | |            ";
echo " | |_) | ___   ___ | |_| | ___   __ _  __| | ___ _ __   ";
echo " |  _ < / _ \ / _ \| __| |/ _ \ / _\` |/ _\` |/ _ \ '__|";
echo " | |_) | (_) | (_) | |_| | (_) | (_| | (_| |  __/ |     ";
echo " |____/ \___/ \___/ \__|_|\___/ \__,_|\__,_|\___|_|     ";
echo "                                                        ";
echo "                                                        ";

pacman -S grub os-prober --noconfirm

grub-install "/dev/$device"
grub-mkconfig -o /boot/grub/grub.cfg

echo "  _    _                  _____             __ _        ";
echo " | |  | |                / ____|           / _(_)       ";
echo " | |  | |___  ___ _ __  | |     ___  _ __ | |_ _  __ _  ";
echo " | |  | / __|/ _ \ '__| | |    / _ \| '_ \|  _| |/ _\` |";
echo " | |__| \__ \  __/ |    | |___| (_) | | | | | | | (_| | ";
echo "  \____/|___/\___|_|     \_____\___/|_| |_|_| |_|\__, | ";
echo "                                                  __/ | ";
echo "                                                 |___/  ";

echo "root:$password" | chpasswd

useradd -m -G users,wheel -s /bin/bash "$username"

echo "$username:$password" | chpasswd

sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

echo "  _____            _    _              ";
echo " |  __ \          | |  | |             ";
echo " | |  | | ___  ___| | _| |_ ___  _ __  ";
echo " | |  | |/ _ \/ __| |/ / __/ _ \| '_ \ ";
echo " | |__| |  __/\__ \   <| || (_) | |_) |";
echo " |_____/ \___||___/_|\_\\__\___/| .__/ ";
echo "   _____      _                 | |    ";
echo "  / ____|    | |                |_|    ";
echo " | (___   ___| |_ _   _ _ __           ";
echo "  \___ \ / _ \ __| | | | '_ \          ";
echo "  ____) |  __/ |_| |_| | |_) |         ";
echo " |_____/ \___|\__|\__,_| .__/          ";
echo "                       | |             ";
echo "                       |_|             ";

pacman -S xorg-server xorg-xinit     --noconfirm
pacman -S wget dialog wpa_supplicant --noconfirm
pacman -S xf86-video-intel           --noconfirm
pacman -S xf86-input-libinput        --noconfirm

echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

su - "$username" -c "bash /rice.sh"
su - "$username" -c "bash /extras.sh"

sed -i "/$username ALL=(ALL) NOPASSWD: ALL/d" /etc/sudoers

exit # exit chroot
