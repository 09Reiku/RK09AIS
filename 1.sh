#!/bin/bash
echo "Well, i see here you are again... kek"
echo "==>timedatectl set-ntp true"
timedatectl set-ntp true

read -p "!!! Now you need to configurate partiptions via cfdisk like this: sdb1 - bootloader; sdb2 - root; sdb3 - swap; Type anything here now: " shit

cfdisk /dev/sdb

echo 'lsblk configuration'
fdisk -l

echo '==> formatting boot, root and swap'
mkfs.ext2  /dev/sdb1 -L boot
mkfs.ext4  /dev/sdb2 -L root
mkswap /dev/sdb3 -L swap

echo '==> mounting boot, root and swap'
mount /dev/sdb2 /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount /dev/sdb1 /mnt/boot/efi
swapon /dev/sda3

echo '==> pacstrap'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl sudo

echo '==> genfstab'
genfstab -pU /mnt >> /mnt/etc/fstab

echo '==> changing root and launch second script'
arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/09Reiku/RK09AIS/main/2.sh)"
