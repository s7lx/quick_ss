#!/bin/bash

sudo apt-get update && sudo apt-get install -y language-pack-zh-hans zsh git mosh --no-install-recommends

mkdir -p /var/setup_ss/
cd /var/setup_ss/
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.9.9/linux-headers-4.9.9-040909_4.9.9-040909.201702090333_all.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.9.9/linux-headers-4.9.9-040909-generic_4.9.9-040909.201702090333_amd64.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.9.9/linux-image-4.9.9-040909-generic_4.9.9-040909.201702090333_amd64.deb
sudo dpkg -i linux*.deb

cd /var/setup_ss/
wget --no-check-certificate https://raw.githubusercontent.com/s7lx/shadowsocks_install/master/shadowsocks-libev-debian.sh
chmod +x shadowsocks-libev-debian.sh
sudo ./shadowsocks-libev-debian.sh

cd /var/setup_ss/
git clone https://github.com/shadowsocks/simple-obfs.git
cd simple-obfs
git submodule update --init --recursive
./autogen.sh
./configure && make
sudo make install

echo "net.ipv4.tcp_fastopen = 3" >>/etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.conf
curl -sSL http://update.aegis.aliyun.com/download/quartz_uninstall.sh | sudo bash
rm -rf /usr/local/aegis
rm /usr/sbin/aliyun-service
rm /lib/systemd/system/aliyun.service

echo "Richard ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "Richard ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

sudo adduser Richard --force-badname
sudo mkdir -p /home/Richard/.ssh/
#sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#git submodule update --init --recursive
#./autogen.sh && ./configure && make
#sudo make install
