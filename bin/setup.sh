#!/usr/bin/env bash

CLI_CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLI_DEST_DIR="/opt"
EXEC_DEST_DIR="/usr/bin"
CLI_ROOT_DIR="${CLI_DEST_DIR}/siteadmin-cli"
IS_FORCED_INSTALL=0

source "${CLI_CURRENT_DIR}/../scripts/output/logger.sh"

info "Setting up environment"
source "${CLI_CURRENT_DIR}/../scripts/ruby/install.sh"

#If user passed -f (--force) flag, enable forced install
while test $# != 0
do
    case "$1" in
    -f|--force) IS_FORCED_INSTALL=1 ;;
    esac
    shift
done

function install() {
    # Move away from the installation directory
    cd ~

    # Move siteadmin executable so it may be used globally
    sudo cp "${CLI_CURRENT_DIR}/siteadmin" "${EXEC_DEST_DIR}/siteadmin"

    # Change CLI permissions so it may be executable through bash
    sudo chmod u+x "${EXEC_DEST_DIR}/siteadmin"

    # Move cli files to /opt
    sudo mkdir -p "${CLI_DEST_DIR}/siteadmin-cli"
    sudo cp -R "${CLI_CURRENT_DIR}/../." "${CLI_DEST_DIR}/siteadmin-cli"
}

function purge() {
    if [ -f "${CLI_ROOT_DIR}/siteadmin" ]
    then
        sudo rm "${EXEC_DEST_DIR}/siteadmin"
    fi

    if [ -d "${CLI_ROOT_DIR}" ]
    then
        sudo rm -rf ${CLI_ROOT_DIR}
    fi
}

# If siteadmin CLI is already installed
if [ -d ${CLI_ROOT_DIR} ]
then
    # If the -f flag was not passed into the script, show error and exit
    if [ "${IS_FORCED_INSTALL}" -eq 0 ]
    then
        warning "Siteadmin CLI has already been installed. Use the -f flag to force a re-install."
        exit 1
    fi

    #purge siteadmin CLI installation
    info "Removing old Siteadmin CLI installation..."
    purge
fi

info "Installing Siteadmin CLI client..."
install

success "Done"