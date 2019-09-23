#!/usr/bin/env bash

do_work() {
  echo  "curl https://crates.io/api/v1/crates/$1"
  sleep 3s
  echo "done $1!"
}

export -f do_work

command  ls "$HOME/.cargo/bin/" | xargs -I % -P4 bash -c 'do_work % &'
