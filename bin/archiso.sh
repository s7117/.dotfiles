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
  if [ `echo $CONT | awk '{print toupper($0)}'` = "Y" ]; then
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
#pacman -Syu ufw --noconfirm
ufw enable
################################################################################
# Update System Clock
################################################################################
echo "$LOG Verify the clock is correct..."
timedatectl status
checkcont
################################################################################
# Edit Mirrorlist
################################################################################
COUNTRY="country=US"
if [[ -f "/etc/pacman.d/mirrorlist" ]]; then
  echo "$LOG Downloading and Modifying mirrorlist..."
  # Download Country's Mirrorlist
  curl "https://archlinux.org/mirrorlist/?$COUNTRY" | \
  sed "s/\#Server/Server/g" > /etc/pacman.d/mirrorlist
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
INSTALLDISK="$(lsblk -x SIZE -d -o PATH | tail -1)"
INSTALLDISKSIZE="$(lsblk -x SIZE -d -o SIZE | tail -1)"
echo "$LOG Default Drive: $INSTALLDISK of size $INSTALLDISKSIZE"
echo "$LOG Continue with erasing $INSTALLDISK $YN Enter N to specify disk."
read CONT
while [ `echo $CONT | awk '{print toupper($0)}'` != "Y" ]; do
  # List the available drives and their sizes
  echo "$LOG Available disks:"
  lsblk -d -o PATH,SIZE -x SIZE
  echo "$LOG Enter Arch install destination disk..."
  read INSTALLDISK
  if [[ -b $INSTALLDISK ]]; then
    echo "$LOG New Arch install destination disk: $INSTALLDISK"
    checkcont
    break
  fi
  echo "$ERR Disk Device not found..."
done

# Unmount disk
umount -f ${INSTALLDISK}*
sleep 1
# Swap size
SWAPSZ="32GiB"

# Wipe Disk
wipefs -a $INSTALLDISK

# Create Partitions
DRIVECONF="g
n
1

+1GiB
n
2

+$SWAPSZ
n
3


t
1
1
t
2
19
t
3
23
w
"
echo $DRIVECONF | fdisk -w always -W always $INSTALLDISK

# Format the partitions
mkfs.ext4 "${INSTALLDISK}1"
mkswap "${INSTALLDISK}2"
mkfs.fat -F 32 "${INSTALLDISK}3"

# Mount the file systems
mount "${INSTALLDISK}3" /mnt
mount --mkdir "${INSTALLDISK}1" /mnt/boot
swapon "${INSTALLDISK}2"

# Check the partitions
echo "$LOG Showing newly created partitions..."
fdisk -l $INSTALLDISK
checkcont

################################################################################
# Pre-install Arch Packages using pacstrap
################################################################################
# Install the base package, Linux kernel, and firmware.
#pacstrap -K /mnt base linux linux-firmware
# Install Simple Pacakges
#pacstrap -K /mnt vim htop dhcpcd zsh ufw sudo iwd
# Install KDE
#pacstrap -K /mnt xorg sddm plasma
# Install manual pages
#pacstrap -K /mnt man-db man-pages texinfo
# Install Bootloader
#pacstrap -K /mnt grub efibootmgr os-prober
################################################################################
# Setup Fstab
################################################################################
genfstab -U /mnt >> /mnt/etc/fstab
################################################################################
# CHROOT
################################################################################