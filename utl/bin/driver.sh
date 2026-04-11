#!/usr/bin/env bash

set -euo pipefail

set -x

utl/bin/vpc create

sleep 2m

utl/bin/vpc upssh

scp utl/bin/vpc-config.sh root@vader:

ssh -t root@vader "bash vpc-config.sh upos"

sleep 2

ssh -t root@vader "bash vpc-config.sh mkuser beattyga"

sleep 2

scp utl/cfg/bashrc          beattyga@vader:.bashrc

scp utl/cfg/authorized_keys beattyga@vader:.ssh/

ssh beattyga@vader          "mkdir -p ~/.config/{nvim,jj}"

scp utl/cfg/nvim-init.lua   beattyga@vader:.config/nvim/init.lua
scp utl/cfg/jj-config.toml  beattyga@vader:.config/jj/config.toml

utl/bin/vpc getip
