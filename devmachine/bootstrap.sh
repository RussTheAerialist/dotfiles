#!/usr/bin/env bash

set -eu 

export DEBIAN_FRONTEND=noninteractive
echo "=> Installing prereq"
apt-get install -y apt-transport-https software-properties-common curl
echo "=> Configuring Docker Apt-Source"
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
echo "=> Updating"
apt-get update && apt-get upgrade -y
echo "=> Installing Docker & Git"
apt-get install -y git docker-ce docker-ce-cli containerd.io

# TODO: Make secrets encrypted
mkdir -p /mnt/code /mnt/secrets

# Spacemacs
echo "=> Cloning emacs"
git clone --depth=1 https://github.com/syl20bnr/spacemacs ~/.emacs.d

# Configure devmachine service
echo "=> Starting up docker service"
cat > dev.service <<EOF
[Unit]
Description=DevMachine
Requires=docker.service
After=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker kill dev
ExecStartPre=-/usr/bin/docker rm dev
ExecStartPre=/usr/bin/docker pull stainlessio/devmachine:test
ExecStart=/usr/bin/docker run -h dev -e TZ=America/Los_Angeles --net=host --rm -v /mnt/code:/root/code -v /mnt/secrets:/root/secrets --cap-add=SYS_PTRACE --name dev stainlessio/devmachine:test

[Install]
WantedBy=multi-user.target
EOF

sudo mv dev.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable dev
sudo systemctl start dev

