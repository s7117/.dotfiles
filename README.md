# .dotfiles

![Terminal Preview](terminal.png)

This repository contains my personal development environment setup files and scripts. Please feel free to use it as you wish.

## Installing Tools:
I setup my environment primarily using the Makefile and passing in the corresponding platform name. As of now the following Makefile targets are supported which runs their respective setup scripts:
- [arch](https://github.com/s7117/.dotfiles/blob/main/README.md#arch-pre-os-install)
- ubuntu
- docker
- mac

Simply run `make <target>` to use call the respective scripts.

## Cleanup Tools:
Not Implemented Yet! Coming soon!

You can run `make clean` to revert the changes made by running one of the setup targets.


## (ARCH) Pre-OS Install:  
A pre-OS install script has been included for Arch Linux. This pre-install script performs most of the Arch Linux install steps described on the Arch Wiki. To use the pre-install `archiso.sh` script: 
1. Download Arch Linux and create a bootable-USB using the [pre-installation](https://wiki.archlinux.org/title/installation_guide#Pre-installation) instructions. 
2. [Boot](https://wiki.archlinux.org/title/installation_guide#Boot_the_live_environment) to the Arch Live USB and then [connect to the internet](https://wiki.archlinux.org/title/installation_guide#Connect_to_the_internet).
3. Use one of the following methods to run the `archiso.sh` script:

- `zsh <(curl -s https://raw.githubusercontent.com/s7117/.dotfiles/main/bin/archiso.sh)`  
- Download the script to a separate USB and run using `./archiso.sh`  

4. While running the script will prompt you multiple times to continue. Enter `Y` to continue or anything else to exit the script.

Some of the Arch Install Script:
- Checks EFI boot mode.
- Verifies internet connectivity.
- Checks system clock time.
- Partitions the install drive (largest drive is default).
- Formats the partitions.
- Mounts the new file system.
- Changes the mirrors to the US mirrors only.
- Installs several packages via pacstrap.
- Checks and installs CPU microcode.
- Checks and Installs GPU driver.
- Configures some post-install (using arch-chroot) options.
- Prompts for root password change.
- Shows post install instructions.

During the first boot into Arch Linux do the following:
1. `systemctl enable iptables`
2. `systemctl enable dhcpcd`
3. `systemctl enable ufw`
4. `systemctl enable sddm`
5. `systemctl enable iwd # for wi-fi`
6. `ufw enable # start firewall`
7. `visudo # Uncomment %wheel ALL=(ALL:ALL) ALL`
8. `useradd -m username # create user`
9. `passwd username # change user's password`
10. `usermod -aG wheel username # add user to sudoer's list`

## Current Features Included:
The following features are currently implemented. Some features are not implemented in Docker to reduce any added performance overhead.
- Sets up .zshrc with history and pointing to the ./etc/zshrc_custom file for aliases and functions.
- Sets up ZSH syntax-highlighting and autosuggestions.
- Installs [Miniforge3](https://github.com/conda-forge/miniforge).
- Copies the contents of ./etc/vimrc to home.
- Custom Oh-My-Posh prompt theme.
- Copies SSH config file to ~/.ssh
- Downloads Fira Code Nerd Font
- Installs Google Chrome and VSCode
- Downloads grub2-themes for simple grub theme customization.
