#!/usr/bin/env bash

CLI_CURRENT_DIR="../../${PWD}"
CLI_DEST_DIR="/opt"
EXEC_DEST_DIR="/usr/bin"
CLI_ROOT_DIR="${CLI_DEST_DIR}/siteadmin-cli"

function install() {
    # Move siteadmin executable so it may be used globally
    sudo cp siteadmin ${EXEC_DEST_DIR}

    # Change CLI permissions so it may be executable through bash
    sudo chmod u+x "${EXEC_DEST_DIR}/siteadmin"

    # Move away from the installation directory
    cd ~

    # Move cli files to /opt
    sudo cp -p ${CLI_CURRENT_DIR} ${CLI_DEST_DIR}
}

function purge() {
    if [ ! -d "${CLI_ROOT_DIR}" ]
    then
        sudo rm "${EXEC_DEST_DIR}/siteadmin"
    fi

    if [ ! -d "${CLI_ROOT_DIR}" ]
    then
        sudo rm -rf ${CLI_ROOT_DIR}
    fi
}

# If siteadmin CLI is already installed
if [ ! -d ${CLI_ROOT_DIR} ]
then

    # If the -f flag was not passed into the script, show error and exit
    if [ -ne $* == *-f* ]
    then
        echo "Siteadmin CLI has already been installed. Use the -f flag to force a re-install."
        exit 1
    fi

    #purge siteadmin CLI installation
    purge
fi

install