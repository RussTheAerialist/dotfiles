"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state(expand('~/.cache/dein'))
  call dein#begin(expand('~/.cache/dein'))

  " Let dein manage dein
  " Required:
  call dein#add(expand('~/.cache/dein/repos/github.com/Shougo/dein.vim'))

  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')

  " Typescript Support
  call dein#add('HerringtonDarkholme/yats.vim')
  call dein#add('mhartington/nvim-typescript', {'build': './install.sh'})
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('Shougo/denite.nvim')

  " Environment and Functionality Plugins
  call dein#add('editorconfig/editorconfig-vim')
  call dein#add('junegunn/fzf')
  call dein#add('zenbro/mirror.vim')
  call dein#add('coachshea/neo-pipe')
  call dein#add('tpope/vim-projectionist')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------


let mapleader=" "

silent !helptags ALL

set hidden
set number
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab!
let g:editorconfig_verbose = 1
let g:deoplete#enable_at_startup = 1

nnoremap <silent> <C-p> :FZF<CR>
