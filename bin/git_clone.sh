#!/usr/bin/env bash

while getopts r:d: option
do
    case "${option}"
    in
        r) REPO_URL=${OPTARG};;
        d) DEST_DIR=${OPTARG};;
    esac
done

echo "git clone ${REPO_URL} ${DEST_DIR}"
echo "git clone ${REPO_URL} ${DEST_DIR}"
echo "git clone ${REPO_URL} ${DEST_DIR}"
echo "git clone ${REPO_URL} ${DEST_DIR}"

git clone "${REPO_URL} ${DEST_DIR}"