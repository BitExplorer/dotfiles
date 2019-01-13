#!/usr/bin/env sh

sudo mkdir -p /var/kvm/images
grep wheel /etc/group
if [ $? -eq 0 ]; then
  sudo chown root:wheel /var/kvm/images
else
  sudo chown root /var/kvm/images
fi

if [ \( "$OS" = "Linux Mint" \) -o \(  "$OS" = "Ubuntu" \) ]; then
  sudo apt install -y cpu-checker
  kvm-ok
  sudo apt install -y ebtables dnsmasq spice-client-gtk virt-viewer gir1.2-spiceclientgtk-3.0 libguestfs-tools
  # may need a reboot
  sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
  sudo adduser $(id -un) kvm
  sudo adduser $(id -un) libvirt
  sudo apt install -y virt-manager
  sudo apt install -y qemu-utils
  sudo virsh -c qemu:///system list
elif [ "$OS" = "Arch Linux" ]; then
  #sudo pacman -Syu libvirt qemu virt-manager spice-client-gtk virt-viewer gir1.2-spiceclientgtk-3.0
  sudo pacman --noconfirm --needed -Syu dmidecode
  sudo pacman --noconfirm --needed -Syu libvirt
  sudo pacman --noconfirm --needed -Syu qemu
  sudo pacman --noconfirm --needed -Syu virt-manager
  sudo pacman --noconfirm --needed -Syu dnsmasq
  #sudo pacman --noconfirm --needed -Syu ebtables
  #sudo pacman --noconfirm --needed -Syu firewalld
  sudo pacman --noconfirm --needed -Syu cdrtools
  sudo pacman --noconfirm --needed -Syu iptables

  sudo systemctl start libvirtd
  sudo systemctl enable libvirtd
  sudo systemctl enable iptables
  sudo systemctl start iptabls
  sudo systemctl status libvirtd
  sudo systemctl status iptables

  sudo usermod -a -G libvirt $(id -un)
  sudo usermod -a -G kvm $(id -un)

  sudo virsh list --all
  sudo virsh net-autostart default
  sudo virsh net-list --all
  getent group kvm libvirt
elif [ "$OS" = "Manjaro Linux" ]; then
  #sudo pacman -Syu libvirt qemu virt-manager spice-client-gtk virt-viewer gir1.2-spiceclientgtk-3.0
  sudo pacman --noconfirm --needed -Syu dmidecode
  sudo pacman --noconfirm --needed -Syu libvirt
  sudo pacman --noconfirm --needed -Syu qemu
  sudo pacman --noconfirm --needed -Syu virt-manager

  sudo pacman --noconfirm --needed -Syu dnsmasq
  sudo pacman --noconfirm --needed -Syu ebtables
  sudo pacman --noconfirm --needed -Syu firewalld

  sudo systemctl start libvirtd
  sudo systemctl enable libvirtd
  sudo systemctl enable firewalld
  sudo systemctl start firewalld
  sudo systemctl status libvirtd
  sudo systemctl status firewalld

  sudo usermod -a -G libvirt $(id -un)
  sudo usermod -a -G kvm $(id -un)

  sudo virsh list --all
  sudo virsh net-autostart default
  sudo virsh net-list --all
  getent group kvm libvirt
elif [ "$OS" = "Gentoo" ]; then
  sudo emerge app-emulation/qemu app-emulation/libvirt bridge-utils
  sudo emerge -1v libvirt libvirt-glib virt-manager libvirt-python
  sudo emerge net-misc/spice-gtk app-emulation/virt-viewer
  sudo emerge virt-manager
  sudo rc-update add libvirtd default
  sudo rc-service libvirtd start
  sudo usermod -a -G libvirt $(id -un)
  sudo usermod -a -G kvm $(id -un)
  echo grep KVM /usr/src/linux/.config
  lsmod | grep kvm
elif [ "$OS" = "Fedora" ]; then
  #sudo dnf remove -y seabios-bin
  sudo dnf install -y seabios-bin
  sudo dnf install -y virt-install
  sudo dnf install -y libvirt
  sudo dnf install -y qemu
  sudo dnf install -y virt-manager
  sudo usermod -a -G libvirt $(id -un)
  sudo usermod -a -G kvm $(id -un)
  sudo systemctl start libvirtd
  sudo systemctl enable libvirtd
  sudo virsh list --all
  sudo virsh net-autostart default
  sudo virsh net-list --all
elif [ "$OS" = "CentOS Linux" ]; then
  #sudo yum remove -y seabios-bin
  sudo yum install -y seabios
  sudo yum install -y seabios-bin
  sudo yum install -y virt-install
  sudo yum install -y libvirt
  sudo yum install -y qemu
  sudo yum install -y virt-manager
  sudo usermod -a -G libvirt $(id -un)
  sudo usermod -a -G kvm $(id -un)
  sudo systemctl start libvirtd
  sudo systemctl enable libvirtd
  sudo virsh list --all
  sudo virsh net-autostart default
  sudo virsh net-list --all
else
  echo "OS=$OS not setup yet."
  exit 1
fi

if [ -f "/etc/sysctl.conf" ]; then
  cat /etc/sysctl.conf | grep net.ipv4.ip_forward
else
  echo sysctl.conf is not found
fi

exit 0

