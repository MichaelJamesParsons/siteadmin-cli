#!/usr/bin/env bash

# Install Git
sudo yum -y install git

# Install PHP 5.6
sudo yum replace php --replace-with php56u
sudo yum -y install epel-release
sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
sudo wget https://centos6.iuscommunity.org/ius-release.rpm
sudo rpm -Uvh ius-release*.rpm
sudo yum -y install php56u php56u-opcache php56u-xml php56u-mcrypt php56u-gd php56u-devel php56u-mysql php56u-intl php56u-mbstring php56u-bcmath
#sudo yum -y install php php-mysql php-common php-gd php-mbstring php-mcrypt php-devel php-xml -y

# Install composer
cd /tmp
curl -sS https://getcomposer.org/installer | php
mkdir -p /usr/local/bin
sudo mv composer.phar /usr/local/bin/composer

# Install apache server
sudo yum install httpd -y

# Start apache server
sudo service httpd start

# Install mysql
sudo yum -y install mariadb-server mariadb -y

# Start mysql
sudo systemctl start mariadb

# Generate mysql password
MYSQL_PASSWORD=$(date +%s|sha256sum|base64|head -c 15)

# Configure mysql
mysql -e "UPDATE mysql.user SET Password = PASSWORD('$MYSQL_PASSWORD') WHERE User = 'root'"
mysql -e "DROP USER ''@'localhost'"
mysql -e "DROP USER ''@'$(hostname)'"
mysql -e "DROP DATABASE IF EXISTS test"
mysql -e "FLUSH PRIVILEGES"

# Start mysql when VM boots
sudo systemctl enable mariadb.service