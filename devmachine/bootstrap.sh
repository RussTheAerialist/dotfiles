#!/usr/bin/env bash

set -eu 

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y

# TODO: Make secrets encrypted
mkdir -p /mnt/code /mnt/secrets
