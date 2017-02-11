#!/usr/bin/env bash

while getopts r:d: option
do
    case "${option}"
    in
        r) REPO_URL=${OPTARG};;
        d) DEST_DIR=${OPTARG};;
    esac
done

git clone ${REPO_URL} ${DEST_DIR}