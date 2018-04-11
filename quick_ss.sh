#!/bin/bash -e 

install_base()
{
	sudo apt-get install -y language-pack-zh-hans zsh git mosh  --no-install-recommends
}
#wget https://raw.githubusercontent.com/s7lx/quick_ss/master/quick_ss.sh && chmod +x quick_ss.sh && ./quick_ss.sh
init_base()
{
	sudo apt-get update
	mkdir -p /var/setup_ss/
}

update_kernel()
{
	pushd /var/setup_ss/
	wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14.5/linux-headers-4.14.5-041405_4.14.5-041405.201712101332_all.deb
	wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14.5/linux-headers-4.14.5-041405-generic_4.14.5-041405.201712101332_amd64.deb
	wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14.5/linux-image-4.14.5-041405-generic_4.14.5-041405.201712101332_amd64.deb
	sudo dpkg -i linux*.deb
	popd
}


install_ss-libev()
{
	pushd /var/setup_ss/
	wget --no-check-certificate https://raw.githubusercontent.com/s7lx/shadowsocks_install/master/shadowsocks-libev-debian.sh
	chmod +x shadowsocks-libev-debian.sh
	sudo ./shadowsocks-libev-debian.sh
	popd
}

install_ss-libev_official()
{
	sudo apt-get install software-properties-common -y
	sudo add-apt-repository ppa:max-c-lv/shadowsocks-libev -y
	sudo apt-get update
	sudo apt-get install shadowsocks-libev
}

install_simple-obfs()
{
	pushd /var/setup_ss/
	git clone https://github.com/shadowsocks/simple-obfs.git
	cd simple-obfs
	git submodule update --init --recursive
	./autogen.sh
	./configure && make
	sudo make install
	popd
}
install_simple-obfs_binary()
{
	pushd /var/setup_ss/
	fn=`curl http://jp.gzlong7.tk |egrep -o "simple.*?deb[^<]" |egrep -o "simple.*?deb"`
	wget "http://jp.gzlong7.tk/$fn"
	sudo dpkg -i simple*.deb
	popd
}

install_quick-ss() 
{
	pushd /var/setup_ss/
	git clone https://github.com/s7lx/quick_ss.git 
	chmod 777 quick_ss -R 
	cd quick_ss 
	./install_tools.sh 
	popd
}
config_sysctl()
{
	echo "net.ipv4.tcp_fastopen = 3" >>/etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.conf
	echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
	sysctl -p
}

remove_yundun()
{
	curl -sSL http://update.aegis.aliyun.com/download/quartz_uninstall.sh | sudo bash
	rm -rf /usr/local/aegis
	rm /usr/sbin/aliyun-service
	rm /lib/systemd/system/aliyun.service
}



add_usr()
{
	echo "Richard ALL=(ALL:ALL) ALL" >> /etc/sudoers
	echo "Richard ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
	sudo adduser Richard --force-badname
}

config_usr()
{
	sudo mkdir -p /home/Richard/.ssh/
	wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O /home/Richard/install_omz.sh
	chmod +x /home/Richard/install_omz.sh
	pbkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQD3dPdfebgbUPrGNZo4UMmnFaqzswZvbc7Trvua4ycdeu1kBBM/ZXfwI+Hgz2xI0fCfvVJh1pRTlOP5pVh6vuI96wNblVWtL7ZwlKABCbw3JwQ9rCLzAL11jQpB6V3jmzBDGEShBltQLy4IFnz8FvRcH4n68upSCeqrtutCscrzUw== Richard@RicharddeMBP.lan" 
	echo $pbkey >> /home/Richard/.ssh/authorized_keys
}
main()
{
	init_base
	install_base
	update_kernel
	#install_ss-libev
	install_ss-libev_official
	#install_simple-obfs
	install_simple-obfs_binary
	install_quick-ss
	config_sysctl
	remove_yundun
	add_usr
	#config_usr
}

if [ $# != 0 ]
then	$1
else main
fi 


