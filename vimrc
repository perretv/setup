set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'joshdick/onedark.vim'
Plugin 'bling/vim-airline'
Plugin 'yggdroot/indentline'
Plugin 'farmergreg/vim-lastplace'
Plugin 'ervandew/supertab'
call vundle#end()
filetype plugin indent on

"Transparent background
if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white })
  augroup END
endif

colorscheme onedark
set background=dark
syntax on
set backspace=indent,eol,start
set number
let g:airline_theme='onedark'
let g:indentLine_leadingSpacChar='·'
let g:indentLine_leadingSpaceEnabled='1'
