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
	firefox                \
	dmenu                  \
	networkmanager         \
	network-manager-applet \
	sxiv                   \
	zathura                \
	zathura-pdf-poppler    \
	bc                     \
	zip                    \
	unzip                  \
	htop                   \
	openssh                \
	bash-completion        \
	arandr                 \
	ctags                  \
	openvpn                \
	cdrtools               \
	xorg-xsetroot          \
	notification-daemon    \
	)

for util in ${extras[@]}
do
	sudo pacman -S "$util" --noconfirm
done

sudo systemctl enable NetworkManager.service

git clone https://aur.archlinux.org/ttf-ms-fonts.git

cd ttf-ms-fonts  && makepkg -si --noconfirm && cd .. && rm -rf ttf-ms-fonts/

echo "blacklist pcspkr" | sudo tee --append /etc/modprobe.d/nobeep.conf
