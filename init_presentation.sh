#!/usr/bin/env bash

ssh_config="$HOME/.ssh/config"

backup_ssh_config() {
  local date=$(date +%Y%m%d_%H%M%S)

  cp ${1} ${1}-${date}.bak
  echo "backup $1"
}

setup_vi() {
  local vimrc=$HOME/.vimrc
  grep -q "^set nu" ${vimrc} || echo "set nu" >>${vimrc}
  echo "setting vim configuration"
}

setup_boxes() {
  echo -n "setting up vagrant boxes and configuration"
  vagrant up >/dev/null
  vagrant ssh-config > ${1}
  local inventory=$(vagrant status | grep running | cut -d' ' -f1 | xargs echo | tr ' ' ',')
  ansible -i ${inventory} -m setup all >/dev/null
  echo "done"
}

setup_vi
backup_ssh_config ${ssh_config}
setup_boxes ${ssh_config}
