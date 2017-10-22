#!/usr/bin/env bash

while getopts u:p:n:i: option
do
    case "${option}"
    in
        u) ROOT_USER=${OPTARG};;
        p) ROOT_PASS=${OPTARG};;
        n) USER_NAME=${OPTARG};;
        i) USER_PASS=${OPTARG};;
    esac
done

USER_EXISTS=$(mysql -u ${ROOT_USER} --password=${ROOT_PASS} -se "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${USER_NAME}') as user_exists")

if [[ "${USER_EXISTS}" == "0" ]]
then
    if [ "$ROOT_PASS" ]
    then
        mysql -u "${ROOT_USER}" --password="${ROOT_PASS}" -e "CREATE USER '${USER_NAME}'@'localhost' IDENTIFIED BY '${USER_PASS}';"
    else
        mysql -u "${ROOT_USER}" -e "CREATE USER '${USER_NAME}'@'localhost' IDENTIFIED BY '${USER_PASS}';"
    fi
fi