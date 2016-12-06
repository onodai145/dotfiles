set encoding=utf-8
set fileencodings=iso-2022-jp,iso-2022-jp-2,utf-8,euc-jp,sjis

set nocompatible
set number
set noerrorbells
set visualbell
set laststatus=2
set statusline=%f%m%=%l,%c\ %{'['.(&fenc!=''?&fenc:&enc).']\ ['.&fileformat.']'}
set viminfo=
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set wrap
set display=lastline
set pumheight=10
set tabstop=4
set autoindent
set expandtab
set shiftwidth=4
set smartindent
set whichwrap=b,s,[,],<,>
set backspace=indent,eol,start

syntax enable
colorscheme slate
