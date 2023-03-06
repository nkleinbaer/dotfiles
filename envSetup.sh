#!/usr/bin/env bash

# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# pacman -S --no-confirm linux linux-headers
# pacman -S --no-confirm base-devel openssh networkmanager wpa_supplicant wireless_tools netctl linux-firmware dialog lvm2 sudo man-db
# pacman -S --no-confirm grub efibootmgr dosfstools os-prober mtools
# pacman -S --no-confirm intel-ucode
# pacman -S --no-confirm xorg mesa xorg-xinit
# pacman -S --no-confirm i3 ttf-dejavu alacritty firefox dmenu zsh feh python-pip python-pywal neofetch picom polybar git ttf-meslo-nerd rofi calc python-gobject htop code wget imagemagick scrot lightdm lightdm-slick-greeter
# 
# 
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# pacman -S  zsh-theme-powerlevel10k

ln -sf $SCRIPT_DIR/zsh/zshrc ~/.zshrc
ln -sf $SCRIPT_DIR/zsh/zshrc.zni ~/.zshrc.zni
ln -sf $SCRIPT_DIR/zsh/oh-my-zsh ~/.oh-my-zsh
ln -sf $SCRIPT_DIR/zsh/p10k.zsh ~/.p10k.zsh
ln -sf $SCRIPT_DIR/xinit/xinitrc ~/.xinitrc 
ln -sf $SCRIPT_DIR/git/gitconfig ~/.gitconfig 
ln -sf $SCRIPT_DIR/lightdm/lightdm.conf /etc/lightdm/lightdm.conf 
ln -sf $SCRIPT_DIR/lightdm/slick-greeter.conf /etc/lightdm/slick-greeter.conf  
