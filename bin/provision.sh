#!/usr/bin/env bash

sudo yum -y install wget

# Install Git
sudo yum -y install git

# Install ruby 2.0
sudo yum -y install ruby
sudo gem install bundler
sudo bundle install

# Install PHP 7.0
sudo yum -y update
sudo yum -y install epel-release
sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
sudo wget https://centos6.iuscommunity.org/ius-release.rpm
sudo rpm -Uvh ius-release*.rpm
sudo yum -y update

sudo yum install -y http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm
sudo yum -y update

sudo yum -y install php70u php70u-pdo php70u-mysqlnd php70u-opcache php70u-xml php70u-mcrypt php70u-gd php70u-devel php70u-mysql php70u-intl php70u-mbstring php70u-bcmath php70u-json php70u-iconv

sudo yum-config-manager --enable http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

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