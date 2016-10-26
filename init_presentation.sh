#!/usr/bin/env bash

ssh_config="$HOME/.ssh/config"

backup_ssh_config() {
  local date=$(date +%Y%m%d_%H%M%S)

  cp ${1} ${1}-${date}.bak
  echo "backup $1"
}

setup_boxes() {
  echo -n "setting up vagrant boxes and configuration"
  VAGRANT_BOX_UPDATE_CHECK_DISABLE=yes vagrant up >/dev/null
  vagrant ssh-config > ${1}
  local inventory=$(vagrant status | grep running | cut -d' ' -f1 | xargs echo | tr ' ' ',')
  ansible -i ${inventory} -m setup all >/dev/null
  echo " : done"
}

backup_ssh_config ${ssh_config}
setup_boxes ${ssh_config}
xdg-open slides/local_sponsors.html &
clear
