set number
let mapleader=" "

packloadall
silent !helptags ALL

set hidden
let g:LanguageClient_serverCommands = {
   \ 'rust': ['~/.cargo/bin/rustup', 'run', 'nightly', 'rls' ],
   \ }
