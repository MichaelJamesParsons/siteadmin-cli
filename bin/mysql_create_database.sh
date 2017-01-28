#!/usr/bin/env bash
while getopts u:p:n: option
do
    case "${option}"
    in
        u) USER=${OPTARG};;
        p) PASS=${OPTARG};;
        n) NAME=${OPTARG};;
    esac
done

if [$PASS]
then
    mysql -u "$USER" --password="$PASS" -e "CREATE DATABASE IF NOT EXISTS $NAME;"
else
    mysql -u "$USER" -e "CREATE DATABASE IF NOT EXISTS $NAME;"
fi