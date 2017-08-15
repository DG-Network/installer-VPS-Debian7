#!/bin/sh
# Scipt Auto Installer VPS Debian 7.11 x32
# Created By: SoelHadi_Newbie | 087864334333
# Under Authority: DG-Network

#Requirement
if [ ! -e /usr/bin/curl ]; then
    apt-get -y update && apt-get -y upgrade
	apt-get -y install curl
fi

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#Add DNS Server ipv4
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
sed -i '$ i\echo "nameserver 8.8.8.8" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 8.8.4.4" >> /etc/resolv.conf' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
cat > /etc/apt/sources.list <<END2
deb http://cdn.debian.net/debian wheezy main contrib non-free
deb http://security.debian.org/ wheezy/updates main contrib non-free
deb http://packages.dotdeb.org wheezy all
END2
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;
apt-get -y purge sendmail*
apt-get -y remove sendmail*

# Update dan Upgrade
apt-get update; apt-get -y upgrade;

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
echo "mrtg mrtg/conf_mods boolean true" | debconf-set-selections
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# setting vnstat
vnstat -u -i eth0
service vnstat restart

# instal ruby
cd
apt-get -y install ruby
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
apt-get install figlet

#install OpenVPN
apt-get -y install openvpn iptables openssl
cp -R /usr/share/doc/openvpn/examples/easy-rsa/ /etc/openvpn
# easy-rsa
if [[ ! -d /etc/openvpn/easy-rsa/2.0/ ]]; then
	wget --no-check-certificate -O ~/easy-rsa.tar.gz https://github.com/OpenVPN/easy-rsa/archive/2.2.2.tar.gz
    tar xzf ~/easy-rsa.tar.gz -C ~/
    mkdir -p /etc/openvpn/easy-rsa/2.0/
    cp ~/easy-rsa-2.2.2/easy-rsa/2.0/* /etc/openvpn/easy-rsa/2.0/
    rm -rf ~/easy-rsa-2.2.2
    rm -rf ~/easy-rsa.tar.gz
fi
cd /etc/openvpn/easy-rsa/2.0/
# benarkan errornya
cp -u -p openssl-1.0.0.cnf openssl.cnf
# ganti bits
sed -i 's|export KEY_SIZE=1024|export KEY_SIZE=2048|' /etc/openvpn/easy-rsa/2.0/vars
sed -i 's|export KEY_COUNTRY="US"|export KEY_COUNTRY="ID"|' /etc/openvpn/easy-rsa/2.0/vars
sed -i 's|export KEY_PROVINCE="CA"|export KEY_PROVINCE="Nusa Tenggara Barat"|' /etc/openvpn/easy-rsa/2.0/vars
sed -i 's|export KEY_CITY="SanFrancisco"|export KEY_CITY="Lombok Tengah"|' /etc/openvpn/easy-rsa/2.0/vars
sed -i 's|export KEY_ORG="Fort-Funston"|export KEY_ORG="DG-Network"|' /etc/openvpn/easy-rsa/2.0/vars
sed -i 's|export KEY_EMAIL="me@myhost.mydomain"|export KEY_EMAIL="nesyamsoel@gmail.com"|' /etc/openvpn/easy-rsa/2.0/vars
sed -i 's|export KEY_EMAIL=mail@host.domain|export KEY_EMAIL="nesyamsoel@gmail.com"|' /etc/openvpn/easy-rsa/2.0/vars
sed -i 's|export KEY_CN=changeme|export KEY_CN="DG-Network"|' /etc/openvpn/easy-rsa/2.0/vars
sed -i 's|export KEY_NAME=changeme|export KEY_NAME=DG-Network|' /etc/openvpn/easy-rsa/2.0/vars
sed -i 's|export KEY_OU=changeme|export KEY_OU=DG-Network|' /etc/openvpn/easy-rsa/2.0/vars
# Buat PKI
. /etc/openvpn/easy-rsa/2.0/vars
. /etc/openvpn/easy-rsa/2.0/clean-all
# Buat Sertifikat
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --initca $*
# buat key server
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --server server
# seting KEY CN
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" client
# DH params
. /etc/openvpn/easy-rsa/2.0/build-dh
# Setting Server
cat > /etc/openvpn/server.conf <<-END
port 55
proto tcp
dev tun
tun-mtu 1500
tun-mtu-extra 32
mssfix 1450
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh2048.pem
plugin /usr/lib/openvpn/openvpn-auth-pam.so /etc/pam.d/login
client-cert-not-required
username-as-common-name
server 192.168.100.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DOMAIN www.google.com"
push "route-method exe"
push "route-delay 2"
push "route 0.0.0.0 0.0.0.0 vpn_gateway"
keepalive 10 120
cipher AES-128-CBC
comp-lzo
persist-key
persist-tun
status server-vpn.log 30
verb 3
END
cd /etc/openvpn/easy-rsa/2.0/keys
cp ca.crt ca.key dh2048.pem server.crt server.key /etc/openvpn
cd /etc/openvpn/


#Create OpenVPN Config
mkdir -p /home/vps/public_html
cat > /home/vps/public_html/client.ovpn <<-END
# Created SoelHadi_Newbie | DG-Network
# Script Premium OpenVPN DG-Network

client
dev tun
proto tcp
remote $MYIP 55
resolv-retry infinite
route-method exe
route $MYIP2 255.255.255.255 net_gateway
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
cipher AES-128-CBC
END
echo '<ca>' >> /home/vps/public_html/client.ovpn
cat /etc/openvpn/ca.crt >> /home/vps/public_html/client.ovpn
echo '</ca>' >> /home/vps/public_html/client.ovpn
cd /home/vps/public_html/
tar -czf /home/vps/public_html/openvpn.tar.gz client.ovpn
tar -czf /home/vps/public_html/client.tar.gz client.ovpn
cd

# set ipv4 forward
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
sed -i 's|net.ipv4.ip_forward=0|net.ipv4.ip_forward=1|' /etc/sysctl.conf

# Restart openvpn
/etc/init.d/openvpn restart

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
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart

# upgrade dropbear 2017.75
apt-get install zlib1g-dev
wget https://raw.githubusercontent.com/DG-Network/script/master/dropbear-2017.75.tar.bz2
bzip2 -cd dropbear-2017.75.tar.bz2  | tar xvf -
cd dropbear-2017.75
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

# Instal (D)DoS Deflate
if [ -d '/usr/local/ddos' ]; then
  echo; echo; echo "Please un-install the previous version first"
  exit 0
else
  mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# install squid3
apt-get -y install squid3
cat > /etc/squid3/squid.conf <<-END
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/32
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 8080
http_port 8000
http_port 3128
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname DG-Network
END
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.680_all.deb"
dpkg --install webmin_1.680_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
chattr +i /etc/webmin/miniserv.conf
rm /root/webmin_1.680_all.deb
service webmin restart
service vnstat restart
apt-get -y --force-yes -f install libxml-parser-perl

#Setting IPtables
cat > /etc/iptables.up.rules <<-END
*filter
:FORWARD ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A FORWARD -i eth0 -o ppp0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i ppp0 -o eth0 -j ACCEPT
-A OUTPUT -d 23.66.241.170 -j DROP
-A OUTPUT -d 23.66.255.37 -j DROP
-A OUTPUT -d 23.66.255.232 -j DROP
-A OUTPUT -d 23.66.240.200 -j DROP
-A OUTPUT -d 128.199.213.5 -j DROP
-A OUTPUT -d 128.199.149.194 -j DROP
-A OUTPUT -d 128.199.196.170 -j DROP
-A OUTPUT -d 103.52.146.66 -j DROP
-A OUTPUT -d 5.189.172.204 -j DROP
COMMIT

*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
COMMIT
END
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules

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
wget -O trial "https://raw.githubusercontent.com/DG-Network/script/master/user-gen.sh"
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
wget -O user-expire-list "https://raw.githubusercontent.com/DG-Network/script/master/user-expire-list.sh"
wget -O user-limit "https://raw.githubusercontent.com/DG-Network/script/master/user-limit.sh"
wget -O auto-reboot "https://raw.githubusercontent.com/DG-Network/menu/master/auto-reboot.sh"

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
chmod +x user-expire-list
chmod +x user-limit
chmod +x auto-reboot

cd
rm .bashrc
rm .profile
wget -O .bashrc "https://raw.githubusercontent.com/DG-Network/screen/master/bashrc"
wget https://raw.githubusercontent.com/DG-Network/screen/master/dg-network
wget https://raw.githubusercontent.com/DG-Network/screen/master/dg-network1
cd /etc
wget https://raw.githubusercontent.com/DG-Network/script/master/pesan-server
cd
wget -O .profile "https://raw.githubusercontent.com/DG-Network/get-lagi/master/profile"
chmod +x .profile

# finalisasi
apt-get -y autoremove
chown -R www-data:www-data /home/vps/public_html
service nginx start
service php5-fpm start
service vnstat restart
service openvpn restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart
service pptpd restart
sysv-rc-conf rc.local on

#clearing history
history -c

# info
clear
echo " "
echo "DG-Network VPS | SoelHadi_Newbie | WhatsApp: 087864334333"
echo " "
echo ""  | tee -a log-install.txt
echo "Informasi Server"  | tee -a log-install.txt
echo "   - Timezone    : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban    : [on]"  | tee -a log-install.txt
echo "   - IPtables    : [on]"  | tee -a log-install.txt
echo "   - Auto-Reboot : [off]"  | tee -a log-install.txt
echo "   - IPv6        : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Informasi Aplikasi & Port"  | tee -a log-install.txt
echo "   - OpenVPN     : TCP 55 "  | tee -a log-install.txt
echo "   - OpenSSH     : 22, 143"  | tee -a log-install.txt
echo "   - Dropbear    : 443, 80"  | tee -a log-install.txt
echo "   - Squid Proxy : 8000, 8080, 3128"  | tee -a log-install.txt
echo "   - Badvpn      : 7300"  | tee -a log-install.txt
echo "   - Nginx       : 81"  | tee -a log-install.txt
echo "   - PPTP VPN    : 1732"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Informasi Tools Dalam Server"  | tee -a log-install.txt
echo "   - htop"  | tee -a log-install.txt
echo "   - iftop"  | tee -a log-install.txt
echo "   - mtr"  | tee -a log-install.txt
echo "   - nethogs"  | tee -a log-install.txt
echo "   - screenfetch"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Informasi Premium Script"  | tee -a log-install.txt
echo "   Perintah untuk menampilkan daftar perintah: menu"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   Penjelasan script dan setup VPS"| tee -a log-install.txt
echo "   dapat dilihat di: http://bit.ly/penjelasansetup"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Informasi Penting"  | tee -a log-install.txt
echo "   - Download Config OpenVPN : http://$MYIP:81/client.ovpn"  | tee -a log-install.txt
echo "     Mirror (*.tar.gz)       : http://$MYIP:81/openvpn.tar.gz"  | tee -a log-install.txt
echo "   - Webmin                  : http://$MYIP:10000/"  | tee -a log-install.txt
echo "   - Vnstat                  : http://$MYIP:81/vnstat/"  | tee -a log-install.txt
echo "   - MRTG                    : http://$MYIP:81/mrtg/"  | tee -a log-install.txt
echo "   - Log Instalasi           : cat /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Developed By: SoelHadi_Newbie | WhatsApp: 087864334333 | Facebook: www.fb.com/syamsul.ds"