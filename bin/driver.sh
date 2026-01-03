#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <password>" 1>&2
  exit 1
fi

set -x

bin/vpc create

sleep 2m

bin/vpc upssh

scp bin/vpc-config.sh root@vader:

ssh -t root@vader "bash vpc-config.sh upos"

sleep 2

ssh -t root@vader "bash vpc-config.sh mkuser beattyga $1"

sleep 2

bin/vpc getip

bin/test-ssh
