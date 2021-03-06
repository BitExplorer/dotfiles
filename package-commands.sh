#!/bin/sh

if [ "$OS" = "Linux Mint" ] || [ "$OS" = "Ubuntu" ] || [ "$OS" = "Raspbian GNU/Linux" ]; then
  apt list --installed > os_mint.txt
else
  echo "$OS is not yet implemented."
  exit 1
fi

echo sudo pacman -R xmonad
echo sudo pacman -Rsnc picom
pacman -Qkk

echo xbps-query -Rs xorg

echo dnf repoquery -l xorg-x11-server-Xorg

# delete a package
echo emerge --deselect www-client/firefox
echo emerge -C mypackage

exit 0

