# Arch Linux Installation Scripts

This repository contains a script to automate the installation of packages on Arch Linux.

## How to Use

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/install-scripts.git
    cd install-scripts
    ```

2.  **Review and modify the package lists:**
    -   `pkg.lst`: This file contains a list of packages to be installed from the official Arch Linux repositories.
    -   `aur_pkg.lst`: This file contains a list of packages to be installed from the Arch User Repository (AUR).

    You can add or remove packages from these files to suit your needs.

3.  **Run the installation script:**
    ```bash
    sudo ./install_pkg.sh
    ```

    The script will:
    -   Install packages from `pkg.lst` using `pacman`.
    -   Install `yay` (an AUR helper) if it's not already installed.
    -   Install packages from `aur_pkg.lst` using `yay`.

## Modifying Packages

To add or remove packages, simply edit the `pkg.lst` or `aur_pkg.lst` file and add or remove the package names, with one package per line.

### Official Repositories

For packages from the official repositories, edit `pkg.lst`.

### AUR Packages

For packages from the AUR, edit `aur_pkg.lst`.

## Disclaimer

This script is intended for use on Arch Linux. Please review the script and the package lists before running it on your system.
