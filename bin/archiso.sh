#!/bin/zsh
################################################################################
AR="-->"
LOG="LOG $AR"
ERR="ERROR $AR"
YN="[Y/n]?"
CONT="Y"
################################################################################
function checkcont() {
  echo "$LOG Continue? $YN"
  read CONT
  if [[ $CONT -eq "Y" ]]; then
    echo "$LOG Continuing..."
  else
    echo "$LOG Exiting..."
    exit
  fi
}
################################################################################
# Using the steps found in the Arch Wiki:
# https://wiki.archlinux.org/title/Installation_guide
################################################################################
# Verify Boot Mode
################################################################################
if [[ -d "/sys/firmware/efi/efivars" ]]; then
  echo "$LOG Booted into EFI mode..."
else
  echo "$ERR Non-EFI mode detected..."
  exit
fi 
################################################################################
# Check Internet is Up
################################################################################
CONNECTED="1 packets transmitted, 1 received"
echo "$LOG Testing internet..."
if [[ $(ping -c 1 google.com | grep "$CONNECTED" | wc -l) -eq 1 ]]; then
  echo "$LOG Internet Connected..."
else
  echo "$ERR Internet not connected..."
fi
# Update and install ufw and enable firewall
pacman -Syu ufw --noconfirm
ufw enable
################################################################################
# Update System Clock
################################################################################
echo "$LOG Verify the clock is correct..."
timedatectl status
echo "$LOG Continue $YN"
checkcont
################################################################################
# Edit Mirrorlist
################################################################################
COUNTRY="country=US"
if [[ -f "/etc/pacman.d/mirrorlist" ]]; then
  echo "$LOG Downloading and Modifying mirrorlist..."
  # Download Country's Mirrorlist
  curl -o /etc/pacman.d/mirrorlist "https://archlinux.org/mirrorlist/?$COUNTRY"
  sed -i "s/\#Server/Server/g" /etc/pacman.d/mirrorlist
else
  echo "$ARR /etc/pacman.d/mirrorlist not found..."
  exit
fi
less /etc/pacman.d/mirrorlist
checkcont
################################################################################
# Partition and Format Disks
################################################################################
# Defaults
INSTALLDISK="/dev/$(lsblk -x SIZE -d -o NAME | tail -1)"
INSTALLDISKSIZE="$(lsblk -x SIZE -d -o SIZE | tail -1)"
echo "$LOG Default Drive: $INSTALLDISK of size $INSTALLDISKSIZE"
checkcont

# Wipe Disk
wipefs -a $INSTALLDISK

# Create Partitions
sfdisk $INSTALLDISK

################################################################################
# Pre-install Arch Packages using pacstrap
################################################################################
# Install the base package, Linux kernel, and firmware.
pacstrap -K /mnt base linux linux-firmware
# Install Simple Pacakges
pacstrap -K /mnt vim htop dhcpcd zsh ufw sudo iwd
# Install KDE
pacstrap -K /mnt xorg sddm plasma
# Install manual pages
pacstrap -K /mnt man-db man-pages texinfo
# Install Bootloader
packstrap -K /mnt grub efibootmgr os-prober
################################################################################
# Setup Fstab
################################################################################
genfstab -U /mnt >> /mnt/etc/fstab
################################################################################
# CHROOT
################################################################################