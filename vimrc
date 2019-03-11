" .vimrc, Josh Rule

" destroy all autocommands
autocmd!

" set the leader to <SPACE>
let mapleader = " "

" detect the type of file being opened
filetype plugin indent on

" enable syntax highlighting
syntax on

" set character encoding to unicode
set encoding=utf-8
" make vim behave like vim, not vi
set nocompatible
" hide abandoned buffers rather than unloading them
set hidden
" remember the last 1000 commands
set history=1000
" matching: list all matches and complete till longest substring
set wildmode=list:longest
" disables 80 character line limit
set textwidth=0
let g:leave_my_textwidth_alone=1
" enables editor only linebreak at col 100
set linebreak
" centralize swap files
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" prep for lighter backgrounds
set background=light
" allow crontab editing
set backupskip=/tmp/*,/private/tmp/*
"intuitive backspacing in insert mode"
set backspace=indent,eol,start
" tabs are 4 spaces
set softtabstop=4
" tabs are 4 spaces
set shiftwidth=4
" tabstop every 4 spaces
set tabstop=4
" tabs are spaces
set expandtab
" automatically match previous indentation level 
set autoindent
" add a few bells and whistles to autoindent
set smartindent
" briefly highlight matching brackets
set showmatch
" highlight search values
set hlsearch
" search incrementally
set incsearch
" ignore cases in most searches
set ignorecase
" don't ignore case if I use uppercase
set smartcase
" set the terminal title to the active file
set title
" start scrolling 3 lines before page ends
set scrolloff=3
" abbreviate all the error messages from VIM"
set shortmess=atI
" free VIM from GUI silliness
set guiheadroom=0
" use a ruler to show where the cursor is
set ruler

" toggle line number with ' n'
nmap <silent> <leader>l :set number!<CR>
" toggle spellcheck with ' c'
nmap <silent> <leader>c :set spell! spelllang=en_us<CR>
" next buffer
nmap <silent> <leader>n :bn<CR>
" previous buffer
nmap <silent> <leader>p :bp<CR>
" delete buffer
nmap <silent> <leader>bd :bd<CR>
" save
nmap <silent> <leader>fs :w<CR>
" clear search
nmap <silent> <leader>c :let @/=""<CR>
" scroll up 3 lines
nnoremap <C-e> 3<C-e>
" scroll down 3 lines
nnoremap <C-y> 3<C-y>
" use Y to yank rest of line
nnoremap <Y> y$
