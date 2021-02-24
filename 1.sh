#!/bin/bash
echo "Well, i see here you are again... kek"
echo "==>timedatectl set-ntp true"
timedatectl set-ntp true

read -p "!!! Well, I hope you configured your partitions on the disk, if it isn't, press ctrl+C to leave, or type anything to continue, if you did it" shit

echo 'lsblk configuration'

read -p "!!! boot on: " partboot
read -p "!!! root on: " partroot
read -p "!!! swap on: " partswap

echo '==> formatting boot, root and swap'
mkfs.fat -F32  $partboot -L boot
mkfs.ext4  $partroot -L root
mkswap $partswap -L swap

echo '==> mounting boot, root and swap'
mount $partroot /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount $partboot /mnt/boot/efi
swapon $partswap

echo '==> pacstrap'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl sudo

echo '==> genfstab'
umount /mnt/boot/efi
genfstab -pU /mnt >> /mnt/etc/fstab
mount $partboot /mnt/boot/efi

echo '==> changing root and launch second script'
arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/09Reiku/RK09AIS/main/2.sh)"
