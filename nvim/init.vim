set number
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab!
let mapleader=" "

packloadall
silent !helptags ALL

set hidden
let g:LanguageClient_serverCommands = {
   \ 'rust': ['~/.cargo/bin/rustup', 'run', 'nightly', 'rls' ],
   \ }
