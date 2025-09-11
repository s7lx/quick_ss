#!/bin/bash -e 
dm="http://jp2.gzlong7.net"
install_base()
{
	sudo apt-get install -y vim wget curl language-pack-zh-hans vnstat zsh git mosh python2 socat mtr-tiny psmisc cron --no-install-recommends
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

install_libcork()
{
	pushd /var/setup_ss/
	fn=`curl $dm/list.php |regex ">(libcork.*?deb)<"`
	wget "$dm/$fn"
	sudo dpkg -i libcork*.deb
	popd
}

install_ss-libev()
{
	install_libcork
	pushd /var/setup_ss/
	sudo apt-get install -y libc-ares2 libev4 libbloom1 libcorkipset1 libmbedcrypto3 libsodium23 --no-install-recommends 
	fn=`curl $dm/list.php |regex ">(shadowsocks-libev.*?deb)<" |egrep -m1 -o "shadowsocks-libev.*?deb"`
	wget "$dm/$fn"
	sudo dpkg -i shadowsocks-libev*.deb
	popd
}

install_ssandsimpleobfs()
{
	sudo apt-get install shadowsocks-libev simple-obfs -y
}

disable_sslibev()
{
	sudo systemctl disable shadowsocks-libev
	sudo systemctl stop shadowsocks-libev
}

install_ss-libev_bysnap()
{
	sudo snap install shadowsocks-libev
}

config_ssh_longconnect()
{
	echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config
	echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config
	sudo service ssh restart

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

install_simple-obfs()
{
	pushd /var/setup_ss/
	sudo apt-get install -y pwgen
	fn=`curl $dm/list.php |regex ">(simple.*?deb)<" |egrep -o "simple.*?deb"`
	wget "$dm/$fn"
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
	sudo wget $dm/besttrace -O /usr/bin/besttrace
        sudo wget $dm/besttrace.lic -O /usr/bin/besttrace.lic
	sudo chown root besttrace
	sudo chmod 4755 besttrace
	popd
}

fix_lib()
{
	pushd /usr/lib/x86_64-linux-gnu
	sudo ln -s libsodium.so.23 libsodium.so.18
	sudo ln -s libmbedcrypto.so.3 libmbedcrypto.so.0
	popd
}


add_usr()
{
	sudo adduser Richard --force-badname
}

install_acl()
{
	pushd /var/setup_ss/quick_ss
	chmod 777 /dev/shm
	cp mincn.txt /dev/shm
	cp cn.txt /dev/shm
	popd
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

        sudo mkdir -p /home/Richard/sslist
		sudo chown Richard:Richard /home/Richard/sslist
	sudo echo "/home/Richard/sslist" > /etc/ss_config_path
	sudo ln -s /etc/ss_config_path /home/Richard/ss_config_path
}
install_rc-local()
{
	pushd /var/setup_ss/quick_ss
	sudo cp rc-local.service /etc/systemd/system/
	sudo cp rc.local /etc/
	sudo chmod +x /etc/rc.local
	sudo systemctl enable rc-local
	sudo apt-get install net-tools
	popd
}
get_ubuntu_version()
{
	if [ -f /etc/os-release ]; then
		. /etc/os-release
		echo $VERSION_ID | cut -d. -f1
	else
		echo "20"
	fi
}

install_ipipdb()
{
	UBUNTU_VERSION=$(get_ubuntu_version)
	if [ "$UBUNTU_VERSION" = "20" ]; then
		sudo apt-get install libjson-c4 -y
	elif [ "$UBUNTU_VERSION" = "22" ]; then
		sudo apt-get install libjson-c5 -y
		if [ ! -f "/usr/lib/x86_64-linux-gnu/libjson-c.so.4" ]; then
			sudo ln -sf /usr/lib/x86_64-linux-gnu/libjson-c.so.5 /usr/lib/x86_64-linux-gnu/libjson-c.so.4
		fi
	else
		sudo apt-get install libjson-c4 -y
	fi
	pushd /var/setup_ss/quick_ss
	sudo cp ipip_read /usr/bin/
	sudo chmod 755 /usr/bin/ipip_read
	popd
}
install_brdgrd()
{
	sudo apt-get install libnetfilter-queue1 -y
	pushd /usr/bin
	sudo wget $dm/brdgrd -O /usr/bin/brdgrd
	sudo setcap cap_net_admin=ep /usr/bin/brdgrd
	sudo chmod 755 /usr/bin/brdgrd
	popd
}
install_sswatchdog()
{
	echo "*/5 * * * * /usr/bin/ss_watch_dog" >> /var/spool/cron/crontabs/root
	echo "#0 0 * * * /usr/bin/re_run_all" >> /var/spool/cron/crontabs/root
	sudo chmod 0600 /var/spool/cron/crontabs/root
	sudo service cron restart 
 
 	sudo touch /etc/ss_config_path 
}
improve_mem()
{
	sudo apt remove lxcfs -y
	sudo apt remove multipath-tools -y
	sudo apt remove snapd -y
	sudo apt purge snapd -y
	sudo apt purge lxd-agent-loader -y
	
	sudo systemctl stop ModemManager
	sudo systemctl disable ModemManager
	
	sudo systemctl stop udisks2
	sudo systemctl disable udisks2
	
	sudo systemctl stop fwupd.service
	sudo systemctl disable fwupd.service
	
	sudo systemctl stop upower.service
	sudo systemctl disable upower.service
	
	sudo systemctl stop polkit
	sudo systemctl disable polkit
	sudo systemctl mask polkit
	
	sudo systemctl stop packagekit
	sudo systemctl disable packagekit
	
	sudo systemctl stop accounts-daemon
	sudo systemctl disable accounts-daemon

	sudo apt autoremove -y
}
main()
{
	init_base
	install_base
	install_quick-ss
	
	install_acl
	install_ssandsimpleobfs
	disable_sslibev
	install_brdgrd
	install_besttrace
	install_ipipdb
	config_sysctl
	config_ssh_longconnect

	#install_libcork
	#install_ss-libev_frsrc
	
	#install_ss-libev
	#install_ss-libev_bysnap
	#install_simple-obfs_frsrc
	#install_simple-obfs
	install_rc-local
	install_sswatchdog
	#fix_lib
	#update_kernel

	#remove_yundun

	add_usr
	#config_usr
}

if [ $# != 0 ]
then	$1
else main
fi 


