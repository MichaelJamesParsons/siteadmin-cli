#!/usr/bin/env bash

while getopts u:p:n:d:h: option
do
    case "${option}"
    in
        u) ROOT_USER=${OPTARG};;
        p) ROOT_PASS=${OPTARG};;
        h) USER_HOST=${OPTARG};;
        n) USER_NAME=${OPTARG};;
        d) DB_NAME=${OPTARG};;
    esac
done


if [ "$ROOT_PASS" ]
then
    mysql -u "${ROOT_USER}" --password="${ROOT_PASS}" -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${USER_NAME}'@'${USER_HOST}';"
else
   mysql -u "${ROOT_USER}" -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${USER_NAME}'@'${USER_HOST}';"
fi

mysql -u "${ROOT_USER}" --password="${ROOT_PASS}" -e "FLUSH PRIVILEGES;"