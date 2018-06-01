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
	keepassx2              \
	unzip                  \
)

for util in ${extras[@]}
do
	sudo pacman -S "$util" --noconfirm
done
