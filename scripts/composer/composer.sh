#!/usr/bin/env bash

source "../output/logger.sh"

LOG_FILE="composer"
COMPOSER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMPOSER_PHAR="${COMPOSER_DIR}/composer.phar"

if [[ ! -f ${COMPOSER_PHAR} ]]; then
    info "Composer not found. Installing..."
    cd ${COMPOSER_DIR}
    curl -sS https://getcomposer.org/installer | php > /dev/null
    success "done"
fi

info "composer ${@} --ignore-platform-reqs --no-interaction"
${COMPOSER_PHAR} --ignore-platform-reqs --no-interaction "${@}" /dev/null