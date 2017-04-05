#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_DIR="../../${CURRENT_DIR}"

source "${CURRENT_DIR}/colors.sh"

function info() {
    printf "$(blue) $1 $(clear)\n"
}

function success() {
    printf "$(green) $1 $(clear)\n"
}

function warning() {
    printf "$(yellow) $1 $(clear)\n"
}

function error() {
    printf "$(red) $1 $(clear)\n"
}

function clear() {
    printf '\e[0m'
}

function default() {
    printf "$(gray) $1 $(clear)\n"
}

function log() {
    LOG="${LOG_DIR}/test.log"
    echo $@ >> ${LOG}
}