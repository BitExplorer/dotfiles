#!/bin/sh

echo "Ctrl + q is to quit."
read -p "Press [Enter] key to continue..."

mkdir $HOME/torrent
rtorrent http://sjc.edge.kernel.org/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-Minimal-1810.torrent
mv CentOS-7-x86_64-Minimal-1810 $HOME/torrent

exit 0
