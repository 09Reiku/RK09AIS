#!/bin/bash
read -p "!!! hostname: " hostname
read -p "!!! username: " username
echo $hostname > /etc/hostname
echo "127.0.1.1 localhost.localdomain $hostname"

echo "==> timezone"
ln -svf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc --utc

echo "==> generating locale"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo 'LANG="en_US.UTF-8"' > /etc/locale.conf

echo '==> mkinitcpio'
mkinitcpio -p linux

echo '==> grub'
pacman -Syy
pacman -S grub efibootmgr --noconfirm 

grub-install --target=x86_64-efi --bootloader-id=Arch --efi-directory=/boot/efi --removable

grub-mkconfig -o /boot/grub/grub.cfg

echo '==> useradd'
useradd -m -g users -G wheel -s /bin/bash $username

echo '!!! root password:'
passwd

echo '!!! user password:'
passwd $username

echo '==> sudoers'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo '==> multilib'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo '==> last packages'
pacman -S pulseaudio pulseaudio-alsa xorg xorg-server xorg-drivers xorg-xinit sddm networkmanager ttf-liberation ttf-dejavu gnome gnome-tweak-tool git

systemctl enable sddm
systemctl enable NetworkManager

echo '==> BlackArch'
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
./strap.sh

pacman -Syu

exit

