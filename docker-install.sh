#!/bin/sh

cat > daemon.json <<EOF
{ "dns" : [ "8.8.8.8", "8.8.4.4" ]}
EOF

if [ "$OS" = "Arch Linux" ] || [ "$OS" = "Manjaro Linux" ] || [ "$OS" = "ArcoLinux" ]; then
  sudo pacman  --noconfirm --needed -S docker
  sudo pacman  --noconfirm --needed -S docker-compose
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo systemctl status docker
  echo "reboot seems to be required"
  sudo netstat -lntp | grep dockerd
  sudo fuser 2375/tcp
  sudo usermod -a -G docker "$(id -un)"
  echo "/etc/docker/daemon.json"
  sudo mkdir -p /etc/systemd/system/docker.socket.d
  echo "loop" | sudo tee /etc/modules-load.d/loop.conf
  echo "1" | sudo tee /proc/sys/net/ipv4/ip_forward
  #sudo tee /etc/modules-load.d/loop.conf <<< "loop"
  #sudo tee /proc/sys/net/ipv4/ip_forward <<< 1
  sudo sysctl -w net.ipv4.ip_forward=1
  sudo iptables -t nat -L
  #sudo firewall-cmd --permanent --zone=trusted --change-interface=docker0
  #sudo firewall-cmd --reload
elif [ "$OS" = "Solus" ]; then
  sudo eopkg install -y docker
  sudo eopkg install -y docker-compose
  sudo usermod -G docker -a "$USER"
  sudo systemctl enable docker
  sudo systemctl start docker
elif [ "$OS" = "openSUSE Tumbleweed" ]; then
  sudo zypper install -y docker
  sudo zypper install -y docker-compose
  sudo usermod -G docker -a "$USER"
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo systemctl status docker
elif [ "$OS" = "Ubuntu" ]; then
  sudo apt install -y docker
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -a -G docker "$(id -un)"
  sudo netstat -lntp | grep dockerd
  sudo fuser 2375/tcp
elif [ "$OS" = "Linux Mint" ]; then
  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable"
  sudo apt update -y
  sudo apt install -y docker-ce docker-compose
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -a -G docker "$(id -un)"
  sudo netstat -lntp | grep dockerd
  sudo fuser 2375/tcp
elif [ "$OS" = "Fedora" ]; then
  sudo dnf install -y device-mapper-persistent-data
  sudo dnf install -y lvm2
  sudo dnf install -y dnf-plugins-core
  sudo dnf install -y psmisc
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -aG docker "$(whoami)"
  sudo netstat -lntp | grep dockerd
  sudo fuser 2375/tcp
elif [ "$OS" = "CentOS Linux" ]; then
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo yum update -y
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2 docker-ce psmisc
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo chkconfig docker on
  sudo usermod -aG docker "$(whoami)"
  sudo netstat -lntp | grep dockerd
  sudo fuser 2375/tcp
elif [ "$OS" = "FreeBSD" ]; then
  sudo pkg install docker ca_root_nss
  sudo sysrc -f /etc/rc.conf docker_enable="YES"
  sudo service docker start
elif [ "$OS" = "Gentoo" ]; then
  sudo eselect news read
  sudo emerge --update --newuse sys-kernel/gentoo-sources
  sudo emerge --update --newuse zfs
  # sudo emerge --update --newuse aufs-sources
  sudo emerge --update --newuse fakeroot
  sudo emerge --update --newuse pciutils
  sudo emerge --update --newuse sys-fs/btrfs-progs
  sudo emerge --update --newuse docker-compose
  sudo emerge --update --newuse app-emulation/docker
  sudo rc-update add docker default
  sudo rc-service docker start
  sudo usermod -a -G docker "$(id -un)"
  echo /usr/share/docker/contrib/check-config.sh
  echo https://github.com/tianon/docker-overlay
  echo sudo cp -v daemon.json /etc/docker/daemon.json
else
  echo "$OS is not yet implemented."
  exit 1
fi

exit 0
