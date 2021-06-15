#!/usr/env bash

# shellcheck disable=SC2016
git submodule foreach 'git checkout $(git remote show origin | grep -ie "HEAD branch:" | cut -d " " -f5); git pull; git status'
