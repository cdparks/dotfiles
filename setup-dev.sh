#!/usr/bin/env bash

set -ex

if [[ "$LANG" != en_US.UTF-8 ]]; then
  sudo locale-gen 'en_US.UTF-8'
  sudo update-locale LANG='en_US.UTF-8'
  sudo update-locale LC_ALL='en_US.UTF-8'
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
fi

if command -v apt >/dev/null; then
  ubuntu_version="$(lsb_release -cs)"

  export DEBIAN_FRONTEND=noninteractive
  # Update apt
  sudo apt update

  # Install misc apt packages
  sudo apt install --assume-yes \
    curl \
    default-jre \
    git \
    htop \
    jq \
    libncurses5-dev \
    libpcre++-dev \
    libpq-dev \
    openvpn \
    pkg-config \
    python3-pip \
    python3-virtualenv \
    python3 \
    ruby-dev \
    silversearcher-ag \
    unzip \
    xclip

  # Install postgres client
  if ! grep -Fq apt.postgresql.org /etc/apt/sources.list.d/pgdg.list; then
    wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
    printf 'deb http://apt.postgresql.org/pub/repos/apt/ %s-pgdg main\n' "$ubuntu_version" | sudo tee /etc/apt/sources.list.d/pgdg.list >/dev/null
    sudo apt update
  fi
  sudo apt install --assume-yes postgresql-client-10

  # Install yarn
  if ! grep -Fq dl.yarnpkg.com /etc/apt/sources.list.d/yarn.list; then
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    printf 'deb https://dl.yarnpkg.com/debian/ stable main' | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update
  fi
  sudo apt install --assume-yes yarn

  # Install Docker
  if ! grep -Fq download.docker.com /etc/apt/sources.list.d/docker.list; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    printf 'deb [arch=amd64] https://download.docker.com/linux/ubuntu %s stable\n' "$ubuntu_version" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt update
  fi
  sudo apt install --assume-yes docker-ce

  # Install docker-compose
  if ! command -v docker-compose; then
    sudo wget https://github.com/docker/compose/releases/download/1.24.0/docker-compose-Linux-x86_64 -O /usr/local/bin/docker-compose
    sudo chmod 0755 /usr/local/bin/docker-compose
  fi

  # Add user to docker group
  if ! groups "$USER" | grep -Fq docker; then
    sudo adduser "$USER" docker
  fi

  # Install ruby and bundler
  sudo apt install --assume-yes ruby
  sudo gem install bundler --version 2.0.1

  # Install google chrome
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
  sudo apt install --assume-yes /tmp/google-chrome-stable_current_amd64.deb

  # Install awscli
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.50.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install

  # Install SSM CLI plugin
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o /tmp/session-manager-plugin.deb
  sudo dpkg -i /tmp/session-manager-plugin.deb
fi

# Install stack
if ! stack --version; then
  curl -sSL https://get.haskellstack.org/ | sh
fi

stack upgrade

# Tell user to open new terminal
set +x
YELLOW='\033[0;33m'
NO_COLOR='\033[0m'
# shellcheck disable=SC2059
printf "\\n${YELLOW}Please logout and then login so the user/group modifications take effect!${NO_COLOR}\\n\\n"
