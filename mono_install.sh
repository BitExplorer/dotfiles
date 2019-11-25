#!/bin/sh

sudo dnf install mono-complete
sudo acman -S wine-mono

cd projects
git clone https://aur.archlinux.org/fsharp.git fsharp-aur
cd fsharp-aur
makepkg -si
cd -


exit 0

sudo rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
curl 'https://download.mono-project.com/repo/centos8-stable.repo' | sudo tee /etc/yum.repos.d/mono-centos8-stable.repo
