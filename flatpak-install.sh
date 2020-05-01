#!/bin/sh

cat > flatpak-overlay.conf << 'EOF'
[flatpak-overlay]
priority = 50
location = <repo-location>/flatpak-overlay
sync-type = git
sync-uri = https://github.com/fosero/flatpak-overlay.git
auto-sync = Yes
EOF

if [ "$OS" = "Arch Linux" ] || [ "$OS" = "Manjaro Linux" ]; then
  sudo pacman --noconfirm --needed -S flatpak
  flatpak install flathub com.valvesoftware.Steam
elif [ "$OS" = "Linux Mint" ] || [ "$OS" = "Ubuntu" ] || [ "$OS" = "Raspbian GNU/Linux" ]; then
  rm -rf com.valvesoftware.Steam.flatpakref com.visualstudio.code.flatpakref
  wget https://flathub.org/repo/appstream/com.valvesoftware.Steam.flatpakref
  wget https://flathub.org/repo/appstream/com.visualstudio.code.flatpakref
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install --user com.valvesoftware.Steam.flatpakref
  flatpak install --user com.visualstudio.code.flatpakref
  echo "flatpak run com.valvesoftware.Steam"
  echo "flatpak run com.visualstudio.code"
  #flatpak install
  sudo apt install -y flatpak
elif [ "$OS" = "CentOS Linux" ]; then
  sudo yum install -y flatpak
elif [ "$OS" = "Gentoo" ]; then
  #sudo emerge layman
  sudo mv flatpak-overlay.conf /etc/portage/repos.conf/flatpak-overlay.conf
  sudo emerge --sync
  sudo emerge --update --newuse flatpak
  wget https://flathub.org/repo/appstream/com.valvesoftware.Steam.flatpakref
  wget https://flathub.org/repo/appstream/com.visualstudio.code.flatpakref
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install --user com.valvesoftware.Steam.flatpakref
  flatpak install --user com.visualstudio.code.flatpakref
else
  echo "$OS is not yet implemented."
  exit 1
fi

flatpak update

exit 0
