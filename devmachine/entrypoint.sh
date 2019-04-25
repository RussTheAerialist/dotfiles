#!/usr/bin/env bash

set -e 

if [ ! -d ~/code/dotfiles ]; then
    echo "Cloning dotfiles"
    # the reason we dont't copy the files individually is, to easily push changes
    # if needed
    cd ~/code
    git clone --recursive https://github.com/russtheaerialist/dotfiles.git
fi

cd ~/code/dotfiles && git remote set-url origin git@github.com:russtheaerialist/dotfiles.git

# Link everything

/usr/bin/sshd -D
