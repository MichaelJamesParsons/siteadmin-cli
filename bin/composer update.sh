#!/usr/bin/env bash

while getopts d: option
do
    case "${option}"
    in
        d) COMPOSER_JSON_PATH=${OPTARG};;
    esac
done

/usr/local/bin/composer install -d "${COMPOSER_JSON_PATH}"