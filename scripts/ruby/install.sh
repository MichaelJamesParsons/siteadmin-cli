#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GEMFILE_DIR="${CURRENT_DIR}/../../"

source "${CURRENT_DIR}/../output/logger.sh"

#
# Installs ruby 2.4.* and bundler (package manager)
#
function install_ruby() {
    # Install Ruby Version Manager (RVM) [https://rvm.io/rvm/install]
    curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - &> /dev/null
    \curl -sSL https://get.rvm.io | bash -s stable --ruby &> /dev/null
}

function install_bundler() {
    gem install bundler
    bundle install
}

if ! command rvm &> /dev/null
then
    info "Installing ruby RVM. This will take a few minutes. Go get some coffee!"
    install_ruby
    echo 'source ~/.rvm/scripts/rvm' >> ~/.bashrc

    # Todo - command waits for user to press "enter" before continuing
    source ~/.bashrc
else
    default "Ruby version manager already installed. Skipping."
fi

if ! ruby -v | grep "ruby 2.4" &> /dev/null
then
    ruby_version=$(ruby -v)
    warning "Ruby version ${ruby_version} is installed. Ruby v2.4.* expected."
    info "Installing ruby 2.4.*. This will take a few minutes."
    rvm install ruby-2.4.0

    info "Changing ruby version from ${ruby_version}"

    # Todo - ruby command not recognized. Update bashrc?
    rvm use 2.4.0
else
    default "Already using Ruby 2.4.0. Skipping."
fi

info "Installing bundler ruby package manager"
gem install bundler > /dev/null

info "Installing new package dependencies"
bundle install &> /dev/null
bundle update &> /dev/null