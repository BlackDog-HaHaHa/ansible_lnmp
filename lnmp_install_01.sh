#!/usr/bin/bash
# author: black
# lnmp基础版安装

user="www"
group="www"
wwwroot="/www/wwwroot"


# nginx
cat << EOF > /etc/yum.repos.d/nginx.repo
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

# mariadb
cat << EOF > /etc/yum.repos.d/mariadb.repo
# MariaDB 10.4 CentOS repository list - created 2020-01-30 13:18 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

# php
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# makecache
yum clean all
yum makecache


# install
yum install nginx MariaDB-server MariaDB-client php72w php72w-cli \
php72w-devel php72w-fpm php72w-gd php72w-mysqlnd php72w-pdo \
php72w-mcrypt php72w-mbstring php72w-xmlrpc -y

# 创建运行用户
groupadd $group
useradd -g $group -s /sbin/nologin $user

# 创建wwwroot目录
mkdir -p $wwwroot
chown -R $user.$group $wwwroot

# 备份原有文档
cp /etc/nginx/conf.d/default.conf{,.old}
cp /etc/php-fpm.d/www.conf{,.old}

# 修改默认运行用户
sed -i "s#user  nginx;#user  $user $group;#g" /etc/nginx/nginx.conf
sed -i "s#user = apache#user = $user#g" /etc/php-fpm.d/www.conf
sed -i "s#group = apache#group = $group#g" /etc/php-fpm.d/www.conf
sed -i "s#User=mysql#User=$user#g" /usr/lib/systemd/system/mariadb.service
sed -i "s#Group=mysql#Group=$user#g" /usr/lib/systemd/system/mariadb.service


# 设置开机启动
systemctl enable nginx php-fpm mariadb