#!/usr/bin/env bash

echo "  ______      _                  ";
echo " |  ____|    | |                 ";
echo " | |__  __  _| |_ _ __ __ _ ___  ";
echo " |  __| \ \/ / __| '__/ _\` / __|";
echo " | |____ >  <| |_| | | (_| \__ \\";
echo " |______/_/\_\\__|_|  \__,_|___/ ";
echo "                                 ";
echo "                                 ";

extras=(                       \
	dmenu                  \
	firefox                \
	networkmanager         \
	network-manager-applet \
	bash-completion        \
	xorg-xprop             \
	bc                     \
	zip                    \
	unzip                  \
	htop                   \
	openssh                \
	openvpn                \
	arandr                 \
	ctags                  \
	cdrtools               \
	cups                   \
	system-config-printer  \
	)

for util in ${extras[@]}
do
	sudo pacman -S "$util" --noconfirm
done

sudo systemctl enable NetworkManager.service
sudo systemctl enable org.cups.cupsd.service

git clone https://aur.archlinux.org/yay.git
git clone https://aur.archlinux.org/ttf-ms-fonts.git

cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
cd ttf-ms-fonts && makepkg -si --noconfirm && cd .. && rm -rf ttf-ms-fonts/

echo "blacklist pcspkr" | sudo tee --append /etc/modprobe.d/nobeep.conf
