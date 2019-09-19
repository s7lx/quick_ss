#!/bin/bash -e 

install_base()
{
	sudo apt-get install -y vim wget curl language-pack-zh-hans vnstat zsh git mosh python --no-install-recommends
}
#wget https://raw.githubusercontent.com/s7lx/quick_ss/master/quick_ss.sh && chmod +x quick_ss.sh && ./quick_ss.sh
init_base()
{
	sudo apt-get update
	sudo mkdir -p /var/setup_ss
	sudo chmod -R 777 /var/setup_ss
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


install_ss-libev_frsrc()
{
	pushd /var/setup_ss/
	wget --no-check-certificate https://raw.githubusercontent.com/s7lx/shadowsocks_install/master/shadowsocks-libev-debian.sh
	chmod +x shadowsocks-libev-debian.sh
	sudo ./shadowsocks-libev-debian.sh
	popd
}

install_ss-libev()
{
	sudo apt-get install software-properties-common -y
	sudo add-apt-repository ppa:max-c-lv/shadowsocks-libev -y
	sudo apt-get update
	sudo apt-get install -y shadowsocks-libev
}

install_simple-obfs_frsrc()
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
install_libcork()
{
	pushd /var/setup_ss/
	fn=`curl http://jp.gzlong7.tk/list.php |regex ">(libcork.*?deb)<"`
	wget "http://jp.gzlong7.tk/$fn"
	sudo dpkg -i libcork*.deb
	popd
}
install_simple-obfs()
{
	pushd /var/setup_ss/
	fn=`curl http://jp.gzlong7.tk/list.php |regex ">(simple.*?deb)<" |egrep -o "simple.*?deb"`
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
	pushd /var/setup_ss/quick_ss
	cat sysctl.txt >> /etc/sysctl.conf
	sysctl -p
	popd
}

remove_yundun()
{
	curl -sSL http://update.aegis.aliyun.com/download/quartz_uninstall.sh | sudo bash
	rm -rf /usr/local/aegis
	rm /usr/sbin/aliyun-service
	rm /lib/systemd/system/aliyun.service
}
install_besttrace()
{
	pushd /usr/bin
	sudo wget http://jp.gzlong7.tk/besttrace 
	sudo chmod 755 besttrace
	popd
}


add_usr()
{
	sudo adduser Richard --force-badname
}

config_usr()
{
	wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O /home/Richard/install_omz.sh
	chmod +x /home/Richard/install_omz.sh

	sudo mkdir -p /home/Richard/.ssh/
	pbkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQD3dPdfebgbUPrGNZo4UMmnFaqzswZvbc7Trvua4ycdeu1kBBM/ZXfwI+Hgz2xI0fCfvVJh1pRTlOP5pVh6vuI96wNblVWtL7ZwlKABCbw3JwQ9rCLzAL11jQpB6V3jmzBDGEShBltQLy4IFnz8FvRcH4n68upSCeqrtutCscrzUw== Richard@RicharddeMBP.lan" 
	echo $pbkey >> /home/Richard/.ssh/authorized_keys

	echo "Richard ALL=(ALL:ALL) ALL" >> /etc/sudoers
	echo "Richard ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
	sudo chown Richard /home/Richard/.ssh -R
}
main()
{
	init_base
	install_base
	install_quick-ss

	install_libcork
	#install_ss-libev_frsrc
	install_ss-libev
	#install_simple-obfs_frsrc
	install_simple-obfs

	install_besttrace
	config_sysctl
	update_kernel

	remove_yundun

	add_usr
	#config_usr
}

if [ $# != 0 ]
then	$1
else main
fi 


