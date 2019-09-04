#!/bin/bash

set -e
set -o pipefail
wget https://raw.githubusercontent.com/cloudpilots/cloudshell/master/bashrc -O $HOME/cloudpilots.bashrc
grep cloudpilots.bashrc $HOME/.bashrc || (cat <<EOF >> $HOME/.bashrc
if [ -f "$HOME/cloudpilots.bashrc" ]; then
  source "$HOME/cloudpilots.bashrc"
fi
EOF
)
