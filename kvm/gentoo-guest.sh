#!/bin/sh

sudo pacman --noconfirm --needed -S virt-viewer

iso_file=install-amd64-minimal-20210611T113421Z.iso
# iso_file=gentoo-install-amd64-minimal-20210414T214503Z.iso
sudo virsh shutdown guest-gentoo
sudo virsh undefine guest-gentoo
sudo virsh destroy guest-gentoo
sudo mkdir -p /var/kvm/images
sudo rm /var/lib/libvirt/images/guest-gentoo.qcow2

if [ ! -f "/var/lib/libvirt/boot/${iso_file}" ]; then
  # wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20210611T113421Z/install-amd64-minimal-20210611T113421Z.iso
  # scp "${iso_file}" pi:/home/pi/downloads/
  scp "pi:/home/pi/downloads/${iso_file}" .
  sudo mv "${iso_file}" /var/lib/libvirt/boot/
fi

#if [ ! -f install-amd64-minimal-20190630T214502Z.iso ]; then
#  wget http://distfiles.gentoo.org/releases/amd64/autobuilds/20190630T214502Z/install-amd64-minimal-20190630T214502Z.iso
#  #scp pi@192.168.100.25:/home/pi/Downloads/CentOS-7-x86_64-NetInstall-1810.iso /tmp/CentOS-7-x86_64-NetInstall-1810.iso
#fi

# sudo fallocate -l 10G /var/kvm/images/guest-gentoo.img
# sudo chmod 777 /var/kvm/images/guest-gentoo.img

exec sudo virt-install \
--virt-type=kvm \
--name guest-gentoo \
--memory=1024,maxmemory=2048 \
--vcpus=1,maxvcpus=2 \
--os-type=generic \
--virt-type=kvm \
--hvm \
--cdrom=/var/lib/libvirt/boot/${iso_file} \
--network=bridge=virbr0,model=virtio \
--graphics vnc \
--disk path=/var/lib/libvirt/images/guest-gentoo.qcow2,size=40,bus=virtio,format=qcow2

exit 0
