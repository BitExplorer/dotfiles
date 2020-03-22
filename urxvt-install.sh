#!/bin/sh

mkdir -p $HOME/.urxvt/perl-extensions

if [ "$OS" = "Gentoo" ]; then
  echo sudo emerge --update --newuse rxvt-unicode
elif [ "$OS" = "Raspbian GNU/Linux" ]; then
  sudo apt update
  sudo apt upgrade -y
  sudo ln -s /usr/bin/perl5.28.1 /usr/bin/perl5
  #sudo apt install -y rxvt-unicode xsel
elif [ "$OS" = "void" ]; then
  echo
elif [ "$OS" = "Fedora" ]; then
  echo
  #sudo dnf install rxvt-unicode
  sudo dnf install fontawesome-fonts
elif [ "$OS" = "FreeBSD" ]; then
  echo freebsd
elif [ "$OS" = "Linux Mint" ] || [ "$OS" = "Ubuntu" ]; then
  echo
  # sudo apt update
  # sudo apt upgrade -y
  #sudo apt install -y rxvt-unicode xsel
elif [ "$OS" = "Arch Linux" ] || [ "$OS" = "Manjaro Linux" ]; then
  # urxvt needs to be installed from the package
  sudo pacman -S --noconfirm --needed rxvt-unicode xsel
  exit 0
  #sudo pacman -S awesome-terminal-fonts
else
  echo "$OS is not yet implemented."
  exit 1
fi

cd $HOME/projects
if [ ! -f "rxvt-unicode-9.22.tar.bz2" ]; then
  wget http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-9.22.tar.bz2
  if [ $? -ne 0 ]; then
    echo "wget failed."
    exit 1
  fi
  tar xvf rxvt-unicode-9.22.tar.bz2
  if [ $? -ne 0 ]; then
    echo "tar failed."
    exit 1
  fi
fi
cd rxvt-unicode-9.22
make clean
./autogen.sh
if [ $? -ne 0 ]; then
  echo "autogen failed."
  exit 1
fi
#./configure --enable-everything --enable-perl --enable-smart-resize --enable-256-color --enable-unicode3
./configure --enable-everything --enable-perl --enable-smart-resize --enable-256-color
if [ $? -ne 0 ]; then
  echo "configure failed."
  exit 1
fi

if [ "$OS" = "Fedora" ]; then
  cp "$HOME/urxvt-Makefile-fedora" "$HOME/projects/rxvt-unicode-9.22/src/Makefile"
fi

make
if [ $? -ne 0 ]; then
  echo "make failed."
  exit 1
fi
sudo make install
cd $HOME

git clone https://github.com/sos4nt/dynamic-colors ~/.dynamic-colors

echo urxvt -fn "xft:Bitstream Vera Sans Mono:pixelsize=15"
echo urxvt --font "xft:Inconsolata for Powerline:size=10"
echo fc-match Monospace
fc-match Monospace
fc-match 'Courier New:slant=0:weight=100:pixelsize=24:antialias=False:autohint=True:minspace=True'
# echo cat /etc/default/locale
# echo sudo locale-gen en_US.UTF-8
# echo locale -a
# echo update-locale LANG=en_US.UTF-8

exit 0
