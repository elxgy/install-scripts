#!/bin/bash

set -eo pipefail

readonly PKG_LST="pkg.lst"
readonly AUR_PKG_LST="aur_pkg.lst"
readonly AUR_HELPER="yay"

log_info() {
    echo "INFO: $1"
}

log_error() {
    echo "ERROR: $1" >&2
    exit 1
}

if [[ "$EUID" -ne 0 ]]; then
    log_error "This script must be run with sudo."
fi

if [[ -z "$SUDO_USER" ]]; then
    log_error "This script must be run via sudo, not in a direct root shell."
fi

if [[ ! -f "$PKG_LST" ]]; then
    log_error "Package list file not found: $PKG_LST"
fi
if [[ ! -f "$AUR_PKG_LST" ]]; then
    log_error "AUR package list file not found: $AUR_PKG_LST"
fi

log_info "Ensuring build dependencies (git, base-devel) are installed..."
pacman -S --noconfirm --needed git base-devel

log_info "Updating system and installing packages from '$PKG_LST'..."
pacman -Syu --noconfirm --needed -- < "$PKG_LST"

if ! command -v "$AUR_HELPER" &> /dev/null; then
    log_info "'$AUR_HELPER' not found. Installing it now..."
    
    build_dir=$(mktemp -d)
    
    sudo -u "$SUDO_USER" bash -c "git clone https://aur.archlinux.org/${AUR_HELPER}.git '$build_dir' && cd '$build_dir' && makepkg -si --noconfirm"
    
    rm -rf "$build_dir"
fi

log_info "Installing AUR packages from '$AUR_PKG_LST'..."
sudo -u "$SUDO_USER" "$AUR_HELPER" -S --noconfirm --needed - < "$AUR_PKG_LST"

log_info "Installation complete."