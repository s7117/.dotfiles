#!/bin/zsh
################################################################################
# Using the steps found in the Arch Wiki:
# https://wiki.archlinux.org/title/Installation_guide
################################################################################
AR="-->"
LOG="LOG $AR"
WARN="WARNING $AR"
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
ufw status
checkcont
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
# Non-Default Setup
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
MOUNTPT=$(df | grep $INSTALLDISK | sort | tail -n 1 | awk '{print $6}')
swapoff -a
if [[ "$MOUNTPT" != "" ]]; then
  umount -R $MOUNTPT
fi
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
mkfs.ext4 "${INSTALLDISK}3"
mkswap "${INSTALLDISK}2"
mkfs.fat -F 32 "${INSTALLDISK}1"

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
echo "$LOG Installing packages"
# Install the base package, Linux kernel, and firmware.
pacstrap -K /mnt base linux linux-firmware
# Install Simple Pacakges
pacstrap -K /mnt vim htop dhcpcd zsh ufw sudo git
# Install KDE
pacstrap -K /mnt xorg sddm plasma
# Install manual pages
pacstrap -K /mnt man-db man-pages texinfo
# Install Bootloader
pacstrap -K /mnt grub efibootmgr os-prober
# Install WiFi CLI package if needed
# TODO: Check for wlan0 and install iwd
pacstrap -K /mnt iwd
# Install CPU Microcode
CPUVENDORID=$(lscpu | grep "^Vendor ID:" | awk '{print $3}')
if [[ "$VENDORID" == "GenuineIntel" ]]; then
  echo "$LOG Intel CPU Installed..."
  pacstrap -K /mnt intel-ucode
elif [[ "$VENDORID" == "AuthenticAMD" ]]; then
  echo "$LOG AMD CPU Installed..."
  pacstrap -K /mnt amd-ucode
else
  echo "$WARN Vendor ID not Intel or AMD..."
fi
# Install GPU Drivers
if [[ "$(lspci | grep "VGA" | grep "NVIDIA")" != "" ]]; then
  echo "Found NVIDIA GPU..."
  pacstrap -K /mnt nvidia
else
  echo "Defaulting to mesa driver..."
  pacstrap -K /mnt mesa
fi
################################################################################
# Setup Fstab
################################################################################
echo "$LOG Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
################################################################################
# CHROOT Commands
################################################################################
# TODO: Disable Internet Here First
USERNAME="user"
# Set time zone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
arch-chroot /mnt hwclock --systohc
# Localization
arch-chroot /mnt sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" \
/etc/locale.gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
# Change Hostname
echo "newarchmachine" > /mnt/etc/hostname
# Create User
arch-chroot /mnt useradd -m -p "temp2022abc%123" $USERNAME
# Give User Sudo Access
arch-chroot /mnt usermod -aG wheel $USERNAME
# Change SDDM Theme
echo "[Theme]
Current=breeze" >> /mnt/usr/lib/sddm/sddm.conf.d/default.conf
################################################################################
# Grub Setup
################################################################################
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot \
--bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
################################################################################
# DONE
################################################################################
echo "$LOG End of script reached..."
echo "$LOG Shutting down..."
checkcont
shutdown -h now
