#!/usr/bin/env bash

echo '
  ______      _                 
 |  ____|    | |                
 | |__  __  _| |_ _ __ __ _ ___ 
 |  __| \ \/ / __|  __/ _" / __|
 | |____ >  <| |_| | | (_| \__ \
 |______/_/\_\\__|_|  \__"_|___/
                                

'

extras=(                       \
	firefox                \
	dmenu                  \
	networkmanager         \
	network-manager-applet \
	sxiv                   \
	zathura                \
	zathura-pdf-poppler    \
	keepassx2              \
	unzip                  \
	htop                   \
	openssh                \
	bash-completion        \
	texlive-core           \
	arandr                 \
)

for util in ${extras[@]}
do
	sudo pacman -S "$util" --noconfirm
done

sudo systemctl enable NetworkManager.service

git clone https://aur.archlinux.org/ttf-ms-fonts.git
git clone https://aur.archlinux.org/consolas-font.git

cd ttf-ms-fonts  && makepkg -si --noconfirm && cd ..
cd consolas-font && makepkg -si --noconfirm && cd ..

rm -rf consolas-font/ ttf-ms-fonts/
