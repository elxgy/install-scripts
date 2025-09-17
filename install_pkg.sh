#!/bin/bash

PKG_LST="pkg.lst"
AUR_PKG_LST="aur_pkg.lst"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [[ ! -f "$PKG_LST" ]]; then
    echo "Package list file not found: $PKG_LST"
    exit 1
fi

echo "Installing packages from $PKG_LST..."
pacman -Syu --noconfirm --needed $(cat "$PKG_LST")

if ! command -v yay &> /dev/null
then
    echo "yay could not be found, installing it now..."
    if [ ! -z "$SUDO_USER" ]; then
        sudo -u $SUDO_USER bash -c 'cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm'
    else
        echo "SUDO_USER is not set. Cannot install yay."
        exit 1
    fi
fi

if [[ ! -f "$AUR_PKG_LST" ]]; then
    echo "AUR Package list file not found: $AUR_PKG_LST"
    exit 1
fi

echo "Installing AUR packages from $AUR_PKG_LST..."
if [ ! -z "$SUDO_USER" ]; then
    sudo -u $SUDO_USER yay -S --noconfirm --needed - < "$AUR_PKG_LST"
else
    echo "SUDO_USER is not set. Cannot install AUR packages."
    exit 1
fi

echo "Installation complete."