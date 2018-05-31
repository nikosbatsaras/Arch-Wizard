#!/usr/bin/env bash

username="$1"
password="$2"
device="$3"
hostname="$4"
partnum="$5"

echo '
  _______ _                         
 |__   __(_)                  ___   
    | |   _ _ __ ___   ___   ( _ )  
    | |  | | "_ " _ \ / _ \  / _ \/\
    | |  | | | | | | |  __/ | (_>  <
  _ |_|  |_|_| |_| |_|\___|  \___/\/
 | |                   | |          
 | |     ___   ___ __ _| | ___  ___ 
 | |    / _ \ / __/ _, | |/ _ \/ __|
 | |___| (_) | (_| (_| | |  __/\__ \
 |______\___/ \___\__,_|_|\___||___/
                                    
'

ln -sf /usr/share/zoneinfo/Europe/Athens /etc/localtime 

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#el_GR.UTF-8 UTF-8/el_GR.UTF-8 UTF-8/' /etc/locale.gen

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf

export LANG=en_US.UTF-8

echo "$hostname" > /etc/hostname

echo "
  ____              _   _                 _           
 |  _ \            | | | |               | |          
 | |_) | ___   ___ | |_| | ___   __ _  __| | ___ _ __ 
 |  _ < / _ \ / _ \| __| |/ _ \ / _' |/ _' |/ _ \ '__|
 | |_) | (_) | (_) | |_| | (_) | (_| | (_| |  __/ |   
 |____/ \___/ \___/ \__|_|\___/ \__,_|\__,_|\___|_|   
                                                      
"

pacman -S grub os-prober

grub-install "/dev/$device"
grub-mkconfig -o /boot/grub/grub.cfg

echo "
  _    _                  _____             __ _       
 | |  | |                / ____|           / _(_)      
 | |  | |___  ___ _ __  | |     ___  _ __ | |_ _  __ _ 
 | |  | / __|/ _ \ '__| | |    / _ \| '_ \|  _| |/ _' |
 | |__| \__ \  __/ |    | |___| (_) | | | | | | | (_| |
  \____/|___/\___|_|     \_____\___/|_| |_|_| |_|\__, |
                                                  __/ |
                                                 |___/ 
"

echo "root:$password" | chpasswd

useradd -m -G users,wheel -s /bin/bash "$username"

echo "$username:$password" | chpasswd

sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

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

pacman -S xorg-server xorg-xinit wget dialog wpa_supplicant bash-completion
pacman -S xf86-video-intel
pacman -S xf86-input-synaptics

echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

su - "$username" -c "bash /rice.sh"

sed -i "/$username ALL=(ALL) NOPASSWD: ALL/d" /etc/sudoers

exit # exit chroot
