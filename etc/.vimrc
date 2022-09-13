filetype on
filetype plugin on
filetype indent on
autocmd FileType c,cpp,java,python set formatoptions+=ro
autocmd FileType c set omnifunc=ccomplete#Complete
set nocompatible
syntax on
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number
set laststatus=2
set ruler
set backspace=indent,eol,start
set ignorecase
set smartcase
set incsearch
color elflord
set autoindent
"set showtabline=2"
"set winwidth=79"
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
