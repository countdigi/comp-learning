#!/usr/bin/env bash

set -euo pipefail

#-----------------------------------------------------------------------------------------------------
# helper functions
#-----------------------------------------------------------------------------------------------------

cat_pubkey() {
  cat <<EOF
EOF
}

cat_bashrc() {
  cat <<EOF
if [[ \$- != *i* ]]; then return; fi

export EDITOR=vim
export HISTCONTROL=ignoreboth
export HISTFILESIZE=-1
export HISTSIZE=-1
export PS1='\\n[\$(pwd)]$ '

shopt -s checkwinsize

source /etc/bash_completion

export PATH=\$HOME/opt/jj/bin:\$PATH
EOF
}

#-----------------------------------------------------------------------------------------------------
# commands
#-----------------------------------------------------------------------------------------------------

upos() {
  export DEBIAN_FRONTEND=noninteractive

  apt update

  apt-get -o "Dpkg::Options::=--force-confold" dist-upgrade -q -y --force-yes

  apt install -y ${OS_PACKAGES}

  cat <<EOF > /etc/ssh/sshd_config.d/50-cloud-init.conf
PasswordAuthentication yes
EOF

  service ssh restart
}

mkuser() {
  local user=$1; shift

  useradd -m -s /bin/bash ${user}

  if [[ $# -gt 0 ]]; then # set passwd
    echo "${user}:${1}" | chpasswd
  fi

  cat_bashrc > /home/${user}/.bashrc

  mkdir -p /home/${user}/.ssh

  chmod -R u=rX,go=-rwx /home/${user}/.ssh

  cat_pubkey > /home/${user}/.ssh/authorized_keys

  chmod 0600 /home/${user}/.ssh/authorized_keys

  chown -R ${user}:${user} /home/${user}

  echo "${user} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users

  /bin/mkdir -p $HOME/opt/jj/bin

  curl -sSL https://github.com/jj-vcs/jj/releases/download/v0.39.0/jj-v0.39.0-x86_64-unknown-linux-musl.tar.gz \
    | tar --extract --gunzip --directory=$HOME/opt/jj/bin --file=- ./jj
}

#-----------------------------------------------------------------------------------------------------
# global vars
#-----------------------------------------------------------------------------------------------------

OS_PACKAGES="
  curl
  fzf
  git
  htop
  ipython3
  rsync
  tmux
  tree
  wget
"

#-----------------------------------------------------------------------------------------------------
# main
#-----------------------------------------------------------------------------------------------------

usage() {
  echo "Usage: $0 < upos | mkuser <username> [password]>" 1>&2
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

"$@"
