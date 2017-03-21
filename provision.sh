#!/usr/bin/env bash

BLUE='\033[0;34m'
FLUSH_COLOR='\033[0m'

function echoWithColor() {
    echo "${1}${2}${FLUSH_COLOR}"
}

#
# Installs libraries required to provision the OS
#
function install_dependencies() {
    sudo yum -y install wget
}

#
# Upgrades OS and updates installed packages
#
function update_packages() {
    sudo yum -y dist-upgrade
    sudo yum -y update
}

#
# Installs Git globally
#
function install_git() {
    # Install Git
    sudo yum -y install git
}

#
# Installs ruby 2.4.* and bundler (package manager)
#
function install_ruby() {
    # Install Ruby Version Manager (RVM) [https://rvm.io/rvm/install]
    curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
    gem install bundler

    # TODO - Move to SA CLI installer setup
    bundle install
}

#
# Installs PHP 7.0.*
#
function install_php() {
    sudo yum -y install epel-release
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
    sudo wget https://centos6.iuscommunity.org/ius-release.rpm
    sudo rpm -Uvh ius-release*.rpm

    sudo yum install -y http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm

    sudo yum -y install php70u php70u-pdo php70u-mysqlnd php70u-opcache php70u-xml php70u-mcrypt
    sudo yum -y install php70u-gd php70u-devel php70u-mysql php70u-intl php70u-mbstring php70u-bcmath
    sudo yum -y install php70u-json php70u-iconv
}

#
# Install composer globally
#
function install_composer {
    cd /tmp
    curl -sS https://getcomposer.org/installer | php > /dev/null
    mkdir -p /usr/local/bin
    sudo mv composer.phar /usr/local/bin/composer
}

#
# Install apache2
#
function install_apache2() {
    # Install apache2 server
    sudo yum install httpd -y

    # Start apache server
    sudo service httpd start

    # Start httpd service on boot
    sudo systemctl enable httpd
}

#
# Installs maria DB
#
function install_maria_db() {
    # Install mysql
    sudo yum -y install mariadb-server mariadb

    # Start mysql
    sudo systemctl start mariadb

    # Start mysql when VM boots
    sudo systemctl enable mariadb.service
}

#
# Configures the root database user
#
function configure_root_db_user() {
    # Set root password to 'root'
    sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('root') WHERE User = 'root'"

    # Drop anonymous users and hosts
    sudo mysql -e "DROP USER ''@'localhost'"
    sudo mysql -e "DROP USER ''@'$(hostname)'"

    # Drop test database
    sudo mysql -e "DROP DATABASE IF EXISTS test"

    # Commit changes
    sudo mysql -e "FLUSH PRIVILEGES"
}


install_dependencies

# Install git if not found
echoWithColor BLUE, "\t- Verifying Git installation";
if ! rpm -qa | grep -qw git; then
    echoWithColor BLUE, "\t\tInstalling Git"
    install_git
fi

# Install php if not found
echoWithColor BLUE, "\t- Verifying PHP installation";
if ! whereis php | grep -qw /usr/bin/php; then
    echoWithColor BLUE, "\t\tInstalling PHP 7.*"
    install_php
fi

# Install composer if not found
echoWithColor BLUE, "\t- Verifying Composer installation";
if ! whereis composer | grep -qw /usr/bin/composer; then
    echoWithColor BLUE, "\t\tInstalling Composer"
    install_composer
fi

# Install httpd if not found
echoWithColor BLUE, "\t- Verifying Apache (HTTPD) installation";
if ! whereis httpd | grep -qw /usr/sbin/httpd; then
    echoWithColor BLUE, "\t\tInstalling Apache2"
    install_apache2
fi

# Install maria DB if not found
echoWithColor BLUE, "\t- Verifying Maria DB installation";
if ! rpm -qa | grep -qw mariadb-server; then
    echoWithColor BLUE, "\t\tInstalling MariaDB"
    install_maria_db
fi