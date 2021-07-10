#!/usr/env bash

# shellcheck disable=SC2016
git submodule foreach --recursive 'git checkout $(git remote show origin | grep -ie "HEAD branch:" | cut -d " " -f5); git pull; echo -e "\n"'
