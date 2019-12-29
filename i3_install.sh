#!/usr/bin/env sh

sudo mkdir -p /usr/share/i3blocks/

if [ \( "$OS" = "Linux Mint" \) -o \(  "$OS" = "Ubuntu" \) -o \(  "$OS" = "Raspbian GNU/Linux" \) ]; then
  sudo apt remove -y lightdm
  sudo apt remove -y gdm
  sudo apt install -y i3status
  sudo apt install -y i3blocks
  sudo apt install -y i3
  sudo apt install -y xterm
  sudo apt install -y i3lock
  sudo apt install -y rofi
  sudo apt install -y terminator
  sudo apt install -y feh
  sudo apt install -y ranger
  sudo apt install -y suckless-tools
elif [ "$OS" = "Arch Linux" ]; then
  sudo pacman -Rsnc lightdm
  sudo pacman -Rsnc gdm
  sudo pacman --noconfirm --needed -S i3status
  sudo pacman --noconfirm --needed -S i3blocks
  sudo pacman --noconfirm --needed -S i3-wm
  sudo pacman --noconfirm --needed -S xterm
  sudo pacman --noconfirm --needed -S i3lock
  sudo pacman --noconfirm --needed -S rofi
  sudo pacman --noconfirm --needed -S termite
  sudo pacman --noconfirm --needed -S terminator
  sudo pacman --noconfirm --needed -S dmenu
  sudo pacman --noconfirm --needed -S feh
  sudo pacman --noconfirm --needed -S ranger
  sudo pacman --noconfirm --needed -S terminus-font
elif [ "$OS" = "Manjaro Linux" ]; then
  sudo pacman -Rsnc lightdm
  sudo pacman -Rsnc gdm
  sudo pacman --noconfirm --needed -S i3status
  sudo pacman --noconfirm --needed -S i3blocks
  sudo pacman --noconfirm --needed -S i3-wm
  sudo pacman --noconfirm --needed -S xterm
  sudo pacman --noconfirm --needed -S i3lock
  sudo pacman --noconfirm --needed -S rofi
  sudo pacman --noconfirm --needed -S termite
  sudo pacman --noconfirm --needed -S terminator
  sudo pacman --noconfirm --needed -S dmenu
  sudo pacman --noconfirm --needed -S feh
  sudo pacman --noconfirm --needed -S ranger
  sudo pacman --noconfirm --needed -S terminus-font
elif [ "$OS" = "Gentoo" ]; then
  GENTOO_PKGS="x11-misc/i3status i3blocks i3 xterm i3lock rofi terminator dmenu dolphin ranger feh"
  FAILURES=""
  for i in $(echo $GENTOO_PKGS); do
    sudo emerge --update --newuse $i
    if [ 0 -ne $? ]; then
      FAILURE="$i $FAILURE"
    fi
  done
  echo Failures: $FAILURE
elif [ "$OS" = "Fedora" ]; then
  echo
  sudo dnf install -y i3status
  sudo dnf install -y i3
  sudo dnf install -y i3lock
  sudo dnf install -y xterm
  sudo dnf install -y i3lock
  sudo dnf install -y terminator
  sudo dnf install -y dmenu
  #sudo dnf install -y dolphin
  sudo dnf install -y neofetch
  sudo dnf install -y terminus-fonts-console
  sudo dnf install -y terminus-fonts
  sudo dnf install -y feh
elif [ "$OS" = "CentOS Linux" ]; then
  sudo yum install -y i3status i3 i3lock xterm i3lock terminator dmenu dolphin terminus-fonts-console terminus-fonts
else
  echo $OS is not yet implemented.
  exit 1
fi

exit 0
