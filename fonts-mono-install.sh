#!/bin/sh

if [ ! -f "symbola.zip" ]; then
  wget -q 'https://fontlibrary.org/assets/downloads/symbola/cf81aeb303c13ce765877d31571dc5c7/symbola.zip'
fi

if [ ! -f "FiraCode_2.zip" ]; then
  wget -q 'https://github.com/tonsky/FiraCode/releases/download/2/FiraCode_2.zip'
fi

PROJECTS="monofur-fonts.zip jetbrains-fonts.zip symbola.zip FiraCode_2.zip font-awesome5-regular.zip"
for i in $PROJECTS; do
  cd "$HOME/.fonts" || exit
  unzip -o "$HOME/$i"
  cd /usr/local/share/fonts
  sudo unzip -o "$HOME/$i"
done
fc-cache -vf ~/.fonts/

echo "fc-list | grep -i jet"
fc-list | grep -i "symbo"
fc-list : family | grep -i awesome
echo https://www.fontsquirrel.com/

exit 0
