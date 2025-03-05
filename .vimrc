" if &compatible
"   set nocompatible
" endif
filetype off
" append to runtime path
set rtp+=/usr/share/vim/vimfiles
" initialize dein, plugins are installed to this directory
call dein#begin(expand('~/.cache/dein'))
" add packages here, e.g:
" call dein#add('qwelyt/TrippingRobot')
" call dein#add('altercation/vim-colors-solarized')
call dein#add('scrooloose/nerdtree')
call dein#add('itchyny/lightline.vim')
" call dein#add('vim-airline/vim-airline')
call dein#add('ghifarit53/tokyonight-vim')
call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')
call dein#add('ryanoasis/vim-devicons')
call dein#add('rbtnn/vim-ambiwidth')

" exit dein
call dein#end()
" auto-install missing packages on startup
if dein#check_install()
  call dein#install()
endif
filetype plugin on

set encoding=utf-8
set fileencodings=iso-2022-jp,iso-2022-jp-2,utf-8,euc-jp,sjis

set nocompatible
set number
set relativenumber
set noerrorbells
set visualbell
" set statusline=%f%m%=%l,%c\ %{'['.(&fenc!=''?&fenc:&enc).']\ ['.&fileformat.']'}
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
set ambiwidth=single
set clipboard+=unnamed

syntax enable

" theme
set termguicolors
let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_transparent_background = 1
colorscheme tokyonight
"set background=dark
"colorscheme solarized

" lightline
set noshowmode
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'tokyonight',
      \ }

" airline
" let g:airline_theme = "tokyonight"
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#enabled = 1

" key mapping
" nerdtree
map <C-n> :NERDTreeToggle<CR>
