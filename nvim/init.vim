let mapleader=" "

packloadall
silent !helptags ALL

set hidden
let g:editorconfig_verbose = 1
let g:LanguageClient_serverCommands = {
   \ 'rust': ['~/.cargo/bin/rustup', 'run', 'nightly', 'rls' ],
   \ }

set number
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab!

nnoremap <silent> <C-p> :FZF<CR>
