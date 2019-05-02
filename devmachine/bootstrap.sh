#!/usr/bin/env bash

set -eu 

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y
apt-get install git ca-certificates

# TODO: Make secrets encrypted
mkdir -p /mnt/code /mnt/secrets

# Spacemacs
git clone --depth=1 https://github.com/syl20bnr/spacemacs ~/.emacs.d
