#!/usr/bin/env bash

function blue() {
    printf '\e[34m'
}

function green() {
    printf '\e[32m'
}

function gray() {
    printf '\033[1;30m'
}

function clear() {
    printf '\e[0m'
}

function default() {
    printf "$1 $(clear)\n"
}

function info() {
    printf "$(blue) $1 $(clear)\n"
}

function success() {
    printf "$(green) $1 $(clear)\n"
}

#
# Installs libraries required to provision the OS
#
function install_dependencies() {
    sudo yum -y -q -e 0 install wget
}

#s
# Upgrades OS and updates installed packages
#
function update_packages() {
    sudo yum -y -q -e 0 update
}

#
# Installs Git globally
#
function install_git() {
    # Install Git
    sudo yum -y -q install git
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

default "PROVISIONING VM"

info "Updating installed packages..."
#update_packages
success "\t- Installation complete"

info "Installing system dependencies..."
install_dependencies
success "\t- Installation complete"

# Install git if not found
info "Verifying Git installation";
if ! rpm -qa | grep -qw git; then
    info "\tInstalling Git"
    install_git
    success "\t\t- Installation complete"
fi

# Install php if not found
info "Verifying PHP installation";
if ! whereis php | grep -qw /usr/bin/php; then
    info "\tInstalling PHP 7.* ..."
    install_php
    success "\t\t- Installation complete"
fi

# Install composer if not found
info "Verifying Composer installation";
if ! whereis composer | grep -qw /usr/local/bin/composer; then
    info "\tInstalling Composer..."
    install_composer
    success "\t\t- Installation complete"
fi

# Install httpd if not found
info "Verifying Apache (HTTPD) installation";
if ! whereis httpd | grep -qw /usr/sbin/httpd; then
    info "\tInstalling Apache2"
    install_apache2
    psuccess "\t\t- Installation complete"
fi

# Install maria DB if not found
info "Verifying Maria DB installation";
if ! rpm -qa | grep -qw mariadb-server; then
    info "Installing MariaDB"
    install_maria_db
    success "\t\t- Installation complete"
fi

default "PROVISION COMPLETE"