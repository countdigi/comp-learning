#!/usr/bin/env bash

set -euo pipefail

set -x

bin/vpc create

sleep 2m

bin/vpc upssh

scp bin/vpc-config.sh root@vader:

ssh -t root@vader "bash vpc-config.sh upos"

sleep 2

ssh -t root@vader "bash vpc-config.sh mkuser beattyga"

sleep 2

bin/vpc getip
