#!/usr/bin/env bash

set -eu

echo "Authenticating with 1password"
export OP_SESSION_my=$(op signin https://my.1password.com russell.hay@gmail.com --output=raw)

echo "Getting Tokens and such"
op get document 'github_rsa' > github_rsa
op get document 'zsh_private' > zsh_private
op get document 'zsh_history' > zsh_history

rm ~/.ssh/github_rsa
rm ~/.zsh_private
rm ~/.zsh_history

ln -s $(pwd)/github_rsa ~/.ssh/github_rsa && chmod 0600 ~/.ssh/github_rsa
ln -s $(pwd)/zsh_private ~/.zsh_private
ln -s $(pwd)/zsh_history ~/.zsh_history
