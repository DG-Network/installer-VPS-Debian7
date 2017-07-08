#!/bin/bash
# Scipt Auto Installer VPS Debian 7.11 x32
# Created By: SoelHadi_Newbie | 087864334333
# Under Authority: DG-Network

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://raw.github.com/arieonline/autoscript/master/conf/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update
apt-get update; apt-get -y upgrade;

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# setting vnstat
vnstat -u -i venet0
service vnstat restart

# instal ruby dan lolcat
cd
apt-get install ruby
y
gem install lolcat

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/ForNesiaFreak/FNS_Debian7/fornesia.com/null/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>www.fornesia.com</pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/ForNesiaFreak/FNS_Debian7/fornesia.com/null/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# install boxes
apt-get install boxes

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.github.com/arieonline/autoscript/master/conf/badvpn-udpgw"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# install mrtg
wget -O /etc/snmp/snmpd.conf "https://raw.github.com/arieonline/autoscript/master/conf/snmpd.conf"
wget -O /root/mrtg-mem.sh "https://raw.github.com/arieonline/autoscript/master/conf/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
cd /etc/snmp/
sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd
service snmpd restart
snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost
curl "https://raw.github.com/arieonline/autoscript/master/conf/mrtg.conf" >> /etc/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
cd

# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/Port 22/Port  22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 80"/g' /etc/default/dropbear
sed -i 's/DROPBEAR_BANNER=/DROPBEAR_BANNER="/etc/pesan-server"/g' /etc/default/dropnear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart

# upgrade dropbear 2014
apt-get install zlib1g-dev
wget https://github.com/ForNesiaFreak/FNS/raw/master/go/dropbear-2014.63.tar.bz2
bzip2 -cd dropbear-2014.63.tar.bz2  | tar xvf -
cd dropbear-2014.63
./configure
make && make install
mv /usr/sbin/dropbear /usr/sbin/dropbear1
ln /usr/local/sbin/dropbear /usr/sbin/dropbear
service dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i 's/eth0/venet0/g' config.php
sed -i "s/\$iface_list = array('venet0', 'sixxs');/\$iface_list = array('venet0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart

# install squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/DG-Network/config/master/squid.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python -y
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.680_all.deb"
dpkg --install webmin_1.680_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
chattr +i /etc/webmin/miniserv.conf
rm /root/webmin_1.680_all.deb
service webmin restart
service vnstat restart

# downlaod script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/DG-Network/menu/master/script-menu.sh"
wget -O banned-user "https://raw.githubusercontent.com/DG-Network/script/master/banned-user.sh"
wget -O delete-user-expire "https://raw.githubusercontent.com/DG-Network/script/master/delete-user-expire.sh"
wget -O disable-user-expire "https://raw.githubusercontent.com/DG-Network/script/master/disable-user-expire.sh"
wget -O dropmon "https://raw.githubusercontent.com/DG-Network/script/master/dropmon.sh"
wget -O unbanned-user "https://raw.githubusercontent.com/DG-Network/script/master/unbanned-user.sh"
wget -O user-active-list "https://raw.githubusercontent.com/DG-Network/script/master/user-active-list.sh"
wget -O user-add "https://raw.githubusercontent.com/DG-Network/script/master/user-add.sh"
wget -O user-del "https://raw.githubusercontent.com/DG-Network/script/master/user-del.sh"
wget -O trial "https://raw.githubusercontent.com/DG-Network/script/master/trial.sh"
wget "https://raw.githubusercontent.com/DG-Network/script/master/userlimit.sh"
wget -O user-list "https://raw.githubusercontent.com/DG-Network/script/master/user-list.sh"
wget -O user-login "https://raw.githubusercontent.com/DG-Network/script/master/user-login.sh"
wget -O user-pass "https://raw.githubusercontent.com/DG-Network/script/master/user-pass.sh"
wget -O user-renew "https://raw.githubusercontent.com/DG-Network/script/master/user-renew.sh"
wget "https://raw.githubusercontent.com/DG-Network/script/master/userlimitssh.sh"
wget -O banner "https://raw.githubusercontent.com/DG-Network/script/master/bannermenu"
wget -O benchmark "https://raw.github.com/choirulanam217/script/master/conf/bench-network.sh"
wget -O speedtest "https://raw.github.com/sivel/speedtest-cli/master/speedtest.py"
wget -O ps-mem "https://raw.github.com/pixelb/ps_mem/master/ps_mem.py"
echo "0 */12 * * * root /usr/bin/reboot" > /etc/cron.d/reboot
echo "* * * * * service dropbear restart" > /etc/cron.d/dropbear
chmod +x menu
chmod +x banned-user
chmod +x delete-user-expire
chmod +x disable-user-expire
chmod +x dropmon
chmod +x unbanned-user
chmod +x user-active-list
chmod +x user-add
chmod +x user-del
chmod +x trial
chmod +x userlimit.sh
chmod +x user-list
chmod +x user-login
chmod +x user-pass
chmod +x user-renew
chmod +x userlimitssh.sh
chmod +x banner
chmod +x pesan-server
chmod +x benchmark
chmod +x speedtest
chmod +x ps-mem

cd
rm .bashrc
rm .profile
wget -O .bashrc "https://raw.githubusercontent.com/DG-Network/screen/master/bashrc"
wget "https://raw.githubusercontent.com/DG-Network/screen/master/dg-network"
wget -O /etc/pesan-server "https://raw.githubusercontent.com/DG-Network/script/master/pesan--server"
wget -O .profile "https://raw.githubusercontent.com/DG-Network/screen/master/profile"
chmod +x .profile

# finalisasi
chown -R www-data:www-data /home/vps/public_html
service nginx start
service php-fpm start
service vnstat restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart

# info
clear
echo "DG-Network VPS | SoelHadi_Newbie | WhatsApp: 087864334333" | tee log-install.txt
echo "===============================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Auto Installer Include"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenSSH  : 22, 143"  | tee -a log-install.txt
echo "Dropbear : 443, 80"  | tee -a log-install.txt
echo "Squid3   : 8080, 3128 (limit to IP SSH)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-----"  | tee -a log-install.txt
echo "boxes"  | tee -a log-install.txt
echo "ruby"  | tee -a log-install.txt
echo "lolcat"  | tee -a log-install.txt
echo "axel"  | tee -a log-install.txt
echo "bmon"  | tee -a log-install.txt
echo "htop"  | tee -a log-install.txt
echo "iftop"  | tee -a log-install.txt
echo "mtr"  | tee -a log-install.txt
echo "nethogs"  | tee -a log-install.txt
echo "XML::Parser"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "Create Akun SSH/OpenVPN"  | tee -a log-install.txt
echo "Create Akun Trial"  | tee -a log-install.txt
echo "Perpanjang Masa Aktif Akun"  | tee -a log-install.txt
echo "Ganti Password Akun SSH/OpenVPN"  | tee -a log-install.txt
echo "Daftar Akun dan Expired"  | tee -a log-install.txt
echo "Hapus Akun"  | tee -a log-install.txt
echo "Monitoring Akun dan Tendang"  | tee -a log-install.txt
echo "Dan masih banyak lagi script PREMIUM nya"  | tee -a log-install.txt
echo "./bench-network.sh"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Fitur lain"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:81/"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "vnstat   : http://$MYIP/vnstat/"  | tee -a log-install.txt
echo "MRTG     : http://$MYIP/mrtg/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Log Installasi --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "SILAHKAN REBOOT VPS ANDA !"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==============================================="  | tee -a log-install.txt
