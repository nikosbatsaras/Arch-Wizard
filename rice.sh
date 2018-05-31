#!/usr/bin/env bash

bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/X11/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/i3/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/bash/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/urxvt/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/tmux/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/vim/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/ranger/install.sh -O -)"
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/dotfiles/master/git/install.sh -O -)"

# exit # as user to root
