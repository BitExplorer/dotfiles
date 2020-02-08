#!/usr/bin/env sh

curl -sSL https://get.haskellstack.org/ | sh
stack update
# cd projects
# git clone https://github.com/jaagr/polybar.git
# cd polybar
# ./build.sh
# cd $HOME

if [ \( "$OS" = "Linux Mint" \) -o \(  "$OS" = "Ubuntu" \) -o \(  "$OS" = "Raspbian GNU/Linux" \) ]; then
  sudo apt remove -y lightdm
  sudo apt remove -y gdm
  sudo apt remove -y lxdm
  sudo apt install -y libxss-dev
  sudo apt install -y xscreensaver
  sudo apt install -y feh
  sudo apt install -y nitrogen
  sudo apt install -y w3m
  sudo apt install -y neofetch
  sudo apt install -y dzen2
  sudo apt install -y conky
  sudo apt install -y nitrogen
  sudo apt install -y cmake
  sudo apt install -y libxpm-dev
elif [ "$OS" = "Arch Linux" ]; then
  sudo pacman -Rsnc lightdm
  sudo pacman -Rsnc gdm
  sudo pacman -Rsnc lxdm
  sudo pacman --noconfirm --needed -S xscreensaver
  sudo pacman --noconfirm --needed -S feh
  sudo pacman --noconfirm --needed -S nitrogen
  sudo pacman --noconfirm --needed -S xdotool
  sudo pacman --noconfirm --needed -S cmake
  sudo pacman --noconfirm --needed -S w3m
  sudo pacman --noconfirm --needed -S neofetch
  sudo pacman --noconfirm --needed -S extra/xorg-xfontsel
  sudo pacman --noconfirm --needed -S dzen2
  sudo pacman --noconfirm --needed -S conky
  cd $HOME/projects
  git clone https://aur.archlinux.org/yabar-git.git yabar-aur
  cd yabar-aur
  makepkg -si
  cd $HOME/projects
  git clone https://aur.archlinux.org/lemonbar-git.git lemonbar-aur
  cd lemonbar-aur
  makepkg -si
elif [ "$OS" = "Manjaro Linux" ]; then
  sudo pacman -Rsnc lightdm
  sudo pacman -Rsnc gdm
  sudo pacman -Rsnc lxdm
  sudo pacman --noconfirm --needed -S xscreensaver
  sudo pacman --noconfirm --needed -S feh
  sudo pacman --noconfirm --needed -S nitrogen
  sudo pacman --noconfirm --needed -S xdotool
  sudo pacman --noconfirm --needed -S cmake
  sudo pacman --noconfirm --needed -S w3m
  sudo pacman --noconfirm --needed -S neofetch
  sudo pacman --noconfirm --needed -S extra/xorg-xfontsel
  sudo pacman --noconfirm --needed -S dzen2
  sudo pacman --noconfirm --needed -S conky
  sudo pacman --noconfirm --needed -S nitrogen
elif [ "$OS" = "FreeBSD" ]; then
  ln -sfn $(find /usr/local/bin/ -type f -name "perl5*" | tail -1) $HOME/.local/bin/perl
  sudo pkg install -y neofetch
  sudo pkg install -y w3m
  sudo pkg install -y xz
  sudo pkg install -y xscreensaver
  sudo pkg install -y feh
  sudo pkg install -y xdotool
  sudo pkg install -y perl5
elif [ "$OS" = "void" ]; then
  sudo ln -s /usr/lib/libncursesw.so.6 /usr/lib/libtinfo.so.6
  VOID_PKGS="xscreensaver feh xdotool w3m neofetch dzen2 xz make gcc gmp-devel"
  FAILURES=""
  for i in $(echo $VOID_PKGS); do
    sudo xbps-install -y $i
    if [ 0 -ne $? ]; then
      FAILURE="$i $FAILURE"
    fi
  done
  echo Failures: $FAILURE
elif [ "$OS" = "Gentoo" ]; then
  sudo emerge --unmerge dzen
  GENTOO_PKGS="xscreensaver feh xdotool w3m neofetch conky ranger nitrogen"
  FAILURES=""
  for i in $(echo $GENTOO_PKGS); do
    sudo emerge --update --newuse $i
    if [ 0 -ne $? ]; then
      FAILURE="$i $FAILURE"
    fi
  done
  echo Failures: $FAILURE
elif [ "$OS" = "Fedora" ]; then
  sudo dnf remove -y lightdm
  sudo dnf remove -y gdm
  sudo dnf remove -y lxdm
  sudo dnf install -y alsa-lib-devel
  sudo dnf install -y libXScrnSaver-devel
  sudo dnf install -y feh
  sudo dnf install -y rofi
  sudo dnf install -y ranger
  sudo dnf install -y neofetch
  sudo dnf install -y w3m
  sudo dnf install -y xscreensaver
  sudo dnf install -y dzen2
  sudo dnf install -y conky
  sudo dnf install -y nitrogen
elif [ "$OS" = "CentOS Linux" ]; then
  if [ "$OS_VER" = "8" ]; then
    echo centos8
    sudo dnf remove -y lightdm
    sudo dnf remove -y gdm
    sudo dnf remove -y lxdm
    sudo dnf install -y alsa-lib-devel
    sudo dnf install -y libXScrnSaver-devel
    sudo dnf install -y feh
    sudo dnf install -y rofi
    sudo dnf install -y ranger
    sudo dnf install -y neofetch
    sudo dnf install -y w3m
    sudo dnf install -y xscreensaver
    sudo dnf install -y dzen2
    sudo dnf install -y conky
    sudo dnf install -y nitrogen
  else
    echo centos7
    sudo yum remove -y lightdm
    sudo yum remove -y gdm
    sudo yum remove -y lxdm
    sudo yum install -y alsa-lib-devel
    sudo yum install -y libXScrnSaver-devel
    sudo yum install -y feh
    sudo yum install -y rofi
    sudo yum install -y ranger
    sudo yum install -y neofetch
    sudo yum install -y w3m
    sudo yum install -y xscreensaver
    sudo yum install -y dzen2
    sudo yum install -y conky
    sudo yum install -y nitrogen
  fi
else
  echo $OS is not yet implemented.
  exit 1
fi

stack install ghc
if [ $? -ne 0 ]; then
  echo failed ghc.
  exit 1
fi

stack install hindent
if [ $? -ne 0 ]; then
  echo failed hindent.
  exit 1
fi

stack install hlint
if [ $? -ne 0 ]; then
  echo failed hlint.
  exit 1
fi

stack install xmonad-contrib
if [ $? -ne 0 ]; then
  echo failed xmonad-contrib.
  exit 1
fi

stack install xmonad-extras
if [ $? -ne 0 ]; then
  echo failed xmonad-extras.
  exit 1
fi

echo "seems to have the the flag with_xft. how to confirm?"
cd $HOME/projects
git clone git@github.com:jaor/xmobar.git
cd xmobar
git pull origin master
stack build
stack install
$HOME/.local/bin/xmonad --version

if [ \( "$OS" = "Gentoo" \) -o \(  "$OS" = "FreeBSD" \) ]; then
  cd $HOME/projects
  git clone https://github.com/minos-org/dzen2.git
  cd dzen2
  sudo make clean install
  cd -
fi

stack exec ghc-pkg list
echo stack exec ghc-pkg unregister mypackage
echo stack exec ghc-pkg recache
echo stack exec ghc-pkg check

exit 0

# cd $HOME/projects
# git clone git@github.com:xmonad/xmonad.git
# cd xmonad
# git checkout tags/v0.13
# stack setup
# stack build
# stack install
# $HOME/.local/bin/xmonad --version

# cd $HOME/projects
# git clone git@github.com:jaor/xmobar.git
# cd xmobar
# git checkout tags/v0.31

# echo exec xmonad
# xmonad --recompile
# echo pid of systemd
# pidof systemd

# echo https://brianbuccola.com/how-to-install-xmonad-and-xmobar-via-stack/
# ghc-pkg list

# exit 0
