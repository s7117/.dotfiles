#!/bin/bash

echo "THIS SCRIPT HAS NOT BEEN TESTED!"
exit

INSTALLDISK=/dev/sdc

echo "WARNING: This will erase ${INSTALLDISK}!"
echo "Are you sure you wish to continue? USE CTRL+C TO TERMINATE!"
read TEMP

fdisk -l $INSTALLDISK

echo "ARE YOU POSITIVE? USE CTRL+C TO TERMINATE!"
read TEMP

SWAPSZ="16GiB"

wipefs -a $INSTALLDISK

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
27
w
"
echo $DRIVECONF | fdisk -w always -W always $INSTALLDISK

NVMESUFFIX=""
if [[ $INSTALLDISK == *"nvme"* ]]; then
  NVMESUFFIX="p"
fi

# Format the partitions
mkfs.ext4 "${INSTALLDISK}${NVMESUFFIX}3"
mkswap "${INSTALLDISK}${NVMESUFFIX}2"
mkfs.fat -F 32 "${INSTALLDISK}${NVMESUFFIX}1"

# Mount the file systems
mount --mkdir "${INSTALLDISK}${NVMESUFFIX}3" /temparchmnt/root
mount --mkdir "${INSTALLDISK}${NVMESUFFIX}1" /temparchmnt/boot
swapon "${INSTALLDISK}${NVMESUFFIX}2"

# Get the files
# wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz
# wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz.sig
# wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz.md5

# Check the md5 checksum
cat *.md5 | md5sum --check

# Extract the rootfs
tar -xvf ArchLinuxARM-rpi-aarch64-latest.tar.gz -C /temparchmnt/root

# Move the boot files
mv /temparchmnt/root/boot/* /temparchmnt/boot

# Edit the boot.txt config file to
# change the default root parition to partition number 3
sed -i 's/2/3/g' /temparchmnt/boot/boot.txt

# Reconfigure boot files with changes
cd /temparchmnt/boot
./mkscr
cd /

# unmount
umount "${INSTALLDISK}${NVMESUFFIX}3"
umount "${INSTALLDISK}${NVMESUFFIX}1"
swapoff "${INSTALLDISK}${NVMESUFFIX}2"
