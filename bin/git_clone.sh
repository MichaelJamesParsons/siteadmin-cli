#!/usr/bin/env bash

while getopts r: option
do
    case "${option}"
    in
        r) REPO_URL=${OPTARG};;
    esac
done

git clone "${REPO_URL} ./"