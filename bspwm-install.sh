#!/usr/bin/env sh

sudo mkdir -p /usr/share/i3blocks/
#sudo cp iface cpu_usage memory /usr/share/i3blocks

if [ \( "$OS" = "Linux Mint" \) -o \(  "$OS" = "Ubuntu" \) -o \(  "$OS" = "Raspbian GNU/Linux" \) ]; then
  sudo apt remove -y lightdm
  sudo apt remove -y gdm
  sudo apt install -y bspwm
  sudo apt install -y xdo
  sudo apt install -y feh
  sudo apt install -y ranger
  sudo apt install -y libev-dev
  sudo apt install -y libasound2-dev
  sudo apt install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool libcurl4-openssl-dev python-xcbgen
  sudo apt install -y libxcb-xrm-dev
  sudo apt install -y libmpdclient-dev
  sudo apt install -y libiw-dev
  sudo apt install -y libpulse-dev
  sudo apt install -y libxcb-composite0-dev
  sudo apt install -y xcb-proto
  sudo apt install -y libxcb-ewmh-dev
  sudo apt install -y xclip
  sudo apt install -y sxhkd
  sudo apt install -y w3m
  sudo apt install -y w3m-img
  sudo apt install -y vifm
  sudo apt install -y xserver-xephyr
elif [ "$OS" = "void" ]; then
  sudo xbps-install -y base-devel libX11-devel libXft-devel libXinerama-devel
  sudo xbps-install -y bspwm
  sudo xbps-install -y xscreensaver
  sudo xbps-install -y feh
  sudo xbps-install -y polybar
  sudo xbps-install -y xdotool
  sudo xbps-install -y cmake
  sudo xbps-install -y w3m
  sudo xbps-install -y dzen2
  sudo xbps-install -y xdo
  sudo xbps-install -y xclip
  sudo xbps-install -y sxhkd
  sudo xbps-install -y xorg
  sudo xbps-install -y xrdb
  sudo xbps-install -y xrdp
  sudo xbps-install -y dmenu
elif [ "$OS" = "Arch Linux" ]; then
  sudo pacman -Rsnc lightdm
  sudo pacman -Rsnc gdm
  sudo pacman --noconfirm --needed -S bspwm
  sudo pacman --noconfirm --needed -S xdo
  sudo pacman --noconfirm --needed -S dmenu
  sudo pacman --noconfirm --needed -S feh
  sudo pacman --noconfirm --needed -S cmatrix
  sudo pacman --noconfirm --needed -S ranger
  sudo pacman --noconfirm --needed -S terminus-font
  sudo pacman --noconfirm --needed -S xclip
  sudo pacman --noconfirm --needed -S sxhkd
  sudo pacman --noconfirm --needed -S w3m
  sudo pacman --noconfirm --needed -S vifm
elif [ "$OS" = "Manjaro Linux" ]; then
  sudo pacman -Rsnc lightdm
  sudo pacman -Rsnc gdm
  sudo pacman --noconfirm --needed -S bspwm
  sudo pacman --noconfirm --needed -S xdo
  sudo pacman --noconfirm --needed -S dmenu
  sudo pacman --noconfirm --needed -S feh
  sudo pacman --noconfirm --needed -S cmatrix
  sudo pacman --noconfirm --needed -S ranger
  sudo pacman --noconfirm --needed -S terminus-font
  sudo pacman --noconfirm --needed -S xclip
  sudo pacman --noconfirm --needed -S sxhkd
  sudo pacman --noconfirm --needed -S w3m
  sudo pacman --noconfirm --needed -S vifm
elif [ "$OS" = "Gentoo" ]; then
  GENTOO_PKGS="bspwm xdo dmenu sxhkd feh cmatrix cairo libmpdclient pulseaudio autocutsel vimfm w3m xclip"
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
  sudo dnf install -y bspwm
  sudo dnf install -y xdo
  sudo dnf install -y dmenu
  sudo dnf install -y neofetch
  sudo dnf install -y terminus-fonts-console
  sudo dnf install -y terminus-fonts
  sudo dnf install -y feh
  sudo dnf install -y cmatrix
  sudo dnf install -y xclip
  sudo dnf install -y xcopy
  sudo dnf install -y sxhkd
  sudo dnf install -y w3m
  sudo dnf install -y vifm
  sudo dnf install -y libxcb-devel xcb-util-keysyms-devel xcb-util-devel xcb-util-wm-devel xcb-util-xrm-devel yajl-devel libXrandr-devel startup-notification-devel libev-devel xcb-util-cursor-devel libXinerama-devel libxkbcommon-devel libxkbcommon-x11-devel pcre-devel pango-devel git gcc automake libcurl-devel libmpdclient-devel wireless-tools-devel pulseaudio-libs-devel xcb-proto  cairo-devel i3-devel
elif [ "$OS" = "FreeBSD" ]; then
  sudo pkg install -y bspwm
  sudo pkg install -y xdo
  sudo pkg install -y feh
  sudo pkg install -y ranger
  sudo pkg install -y suckless-tools
  sudo pkg install -y libev-dev
  sudo pkg install -y xcb-proto
  sudo pkg install -y libxcb-ewmh-dev
  sudo pkg install -y xclip
  sudo pkg install -y sxhkd
  sudo pkg install -y w3m
  sudo pkg install -y w3m-img
  sudo pkg install -y vifm
  sudo apt install -y xserver-xephyr
  sudo apt install -y polybar
elif [ "$OS" = "CentOS Linux" ]; then
  sudo yum install -y bspwm xdo dmenu terminus-fonts-console terminus-fonts
else
  echo "$OS is not yet implemented."
  exit 1
fi

exit 0