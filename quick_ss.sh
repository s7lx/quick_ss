#!/bin/bash

sudo apt-get update && sudo apt-get install -y language-pack-zh-hans zsh git mosh --no-install-recommends

#wget https://raw.githubusercontent.com/s7lx/quick_ss/master/quick_ss.sh && chmod +x quick_ss.sh && ./quick_ss.sh
mkdir -p /var/setup_ss/
cd /var/setup_ss/
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14.5/linux-headers-4.14.5-041405_4.14.5-041405.201712101332_all.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14.5/linux-headers-4.14.5-041405-generic_4.14.5-041405.201712101332_amd64.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14.5/linux-image-4.14.5-041405-generic_4.14.5-041405.201712101332_amd64.deb
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

cd /var/setup_ss/
git clone https://github.com/s7lx/quick_ss.git
chmod 777 quick_ss -R
cd quick_ss
./install_tools.sh

echo "net.ipv4.tcp_fastopen = 3" >>/etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
curl -sSL http://update.aegis.aliyun.com/download/quartz_uninstall.sh | sudo bash
rm -rf /usr/local/aegis
rm /usr/sbin/aliyun-service
rm /lib/systemd/system/aliyun.service

echo "Richard ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "Richard ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

sudo adduser Richard --force-badname
#sudo mkdir -p /home/Richard/.ssh/
#sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#git submodule update --init --recursive
#./autogen.sh && ./configure && make
#sudo make install
