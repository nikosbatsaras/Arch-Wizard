#!/usr/bin/env bash

echo "
  _____  _      _               _ 
 |  __ \(_)    (_)             | |
 | |__) |_  ___ _ _ __   __ _  | |
 |  _  /| |/ __| | '_ \ / _' | | |
 | | \ \| | (__| | | | | (_| | |_|
 |_|  \_\_|\___|_|_| |_|\__, | (_)
                         __/ |    
                        |___/     
"

repo='https://raw.githubusercontent.com/nickbatsaras/dotfiles/master'

bash -c "$(wget $repo/X11/install.sh      -O -)"
bash -c "$(wget $repo/bin/install.sh      -O -)"
bash -c "$(wget $repo/i3/install.sh       -O -)"
bash -c "$(wget $repo/bash/install.sh     -O -)"
bash -c "$(wget $repo/urxvt/install.sh    -O -)"
bash -c "$(wget $repo/tmux/install.sh     -O -)"
bash -c "$(wget $repo/vim/install.sh      -O -)"
bash -c "$(wget $repo/ranger/install.sh   -O -)"
bash -c "$(wget $repo/mpv/install.sh      -O -)"
bash -c "$(wget $repo/newsboat/install.sh -O -)"
bash -c "$(wget $repo/git/install.sh      -O -)"
