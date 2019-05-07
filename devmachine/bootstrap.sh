#!/usr/bin/env bash

set -eu 

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y
apt-get install git ca-certificates

# TODO: Make secrets encrypted
mkdir -p /mnt/code /mnt/secrets

# Spacemacs
echo "=> Cloning emacs"
git clone --depth=1 https://github.com/syl20bnr/spacemacs ~/.emacs.d

# Configure devmachine service
echo "=> Starting up docker service"
cat > devmachine.service <<EOF
[Unit]
Description=DevMachine
Requires=docker.service
After=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker kill dev
ExecStartPre=-/usr/bin/docker rm dev
ExecStartPre=/usr/bin/docker pull stainlessio/devmachine:latest
ExecStart=/usr/bin/docker run -h dev -e TZ=America/Los_Angeles --net=host --rm -v /mnt/code:/root/code -v /mnt/secrets:/root/secrets --cap-add=SYS_PTRACE --name dev stainlessio/devmachine:latest

[Install]
WantedBy=multi-user.target
EOF

sudo mv devmachine.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable dev
sudo systemctl start dev

