#!/usr/bin/env bash

ln -sf /usr/share/zoneinfo/Europe/Athens /etc/localtime 

sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/# el_GR.UTF-8 UTF-8/el_GR.UTF-8 UTF-8/' /etc/locale.gen

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf

export LANG=en_US.UTF-8

echo "$hostname" > /etc/hostname

pacman -S grub os-prober
grub-install "/dev/$device$partnum"
grub-mkconfig -o /boot/grub/grub.cfg

echo "$password1" | passwd --stdin

useradd -m -G users,wheel -s /bin/bash "$username"

echo "$password1" | passwd "$username" --stdin

sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/locale.gen

echo "

  _____            _    _              
 |  __ \          | |  | |             
 | |  | | ___  ___| | _| |_ ___  _ __  
 | |  | |/ _ \/ __| |/ / __/ _ \| '_ \ 
 | |__| |  __/\__ \   <| || (_) | |_) |
 |_____/ \___||___/_|\_\\__\___/| .__/ 
  / ____|    | |                | |    
 | (___   ___| |_ _   _ _ __    |_|    
  \___ \ / _ \ __| | | | '_ \          
  ____) |  __/ |_| |_| | |_) |         
 |_____/ \___|\__|\__,_| .__/          
                       | |             
                       |_|             
"

pacman -S xorg-server xorg-xinit dialog wpa_supplicant
pacman -S xf86-video-intel
pacman -S xf86-input-synaptics

echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

su "$username"

bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/X11/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/i3/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/bash/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/urxvt/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/tmux/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/vim/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/ranger/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/git/install.sh -O -)"

sed -i "/$username ALL=(ALL) NOPASSWD: ALL/d" /etc/sudoers

# exit # as user to root
# exit # as root to live-media

echo; echo
echo "  Installation complete! You can now reboot ..."
echo; echo

