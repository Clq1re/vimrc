"#######################################################
" Dein Scripts
"#######################################################

fun! s:callPlugins()
	if(v:version >= 800 || has('nvim'))
		let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
		let s:dein_dir = s:cache_home . '/dein'
		let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
		if !isdirectory(s:dein_repo_dir)
			call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
		endif
		let &runtimepath = s:dein_repo_dir .",". &runtimepath

		" read plugin & create chache
		let s:toml_dir = expand('~/.config/nvim/toml')
		let s:dein_file = s:toml_dir.'/dein.toml'
		let s:dein_lazy_file = s:toml_dir.'/dein_lazy.toml'
		let s:visual_file = s:toml_dir.'/visual.toml'
		if dein#load_state(s:dein_dir)
			call dein#begin(s:dein_dir)
			call dein#load_toml(s:dein_file, {'lazy': 0})
			call dein#load_toml(s:visual_file, {'lazy': 0})
			call dein#load_toml(s:dein_lazy_file, {'lazy': 1})
			call dein#end()
			call dein#save_state()
		endif

		if !has('nvim')
			call dein#add('roxma/nvim-yarp')
			call dein#add('roxma/vim-hug-neovim-rpc')
		endif

		"install plugins when no install them
		if has('vim_starting') && dein#check_install()
			call dein#install()
		endif
	endif
endfun

call s:callPlugins()
nnoremap <silent> <space>0d :call <SID>callPlugins()<CR>

"#######################################################
" Autocmd settings
"#######################################################
if !&compatible
  set nocompatible
endif

"Reset augroup
augroup My_auto
  autocmd!

  " Move the cursor to previous position when a file is opened
  autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

  " Set indent space
  autocmd FileType *  setlocal sw=2 sts=2 ts=2 et

" Open a help text vertically
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif

  " Remove space or tab at End of line
  autocmd InsertLeave * :%s/\s\+$//e

  " At last ,highlight settings
  autocmd VimEnter,ColorScheme * highlight PmenuSel ctermfg=white ctermbg=darkblue
  autocmd VimEnter,ColorScheme * highlight Pmenu ctermfg=white ctermbg=black
  autocmd VimEnter,ColorScheme * highlight NormalFloat ctermfg=black ctermbg=white cterm=NONE guifg=NONE guibg=NONE gui=NONE
  autocmd VimEnter,ColorScheme * highlight Search ctermfg=black ctermbg=lightgreen
augroup END

"#######################################################
" General settings
"#######################################################
set autoread
set hidden
set wildmenu
filetype plugin indent on

" leave from paste mode or insert mode
inoremap <silent> jj <ESC>:set nopaste<CR>

vnoremap ; <ESC>:
nnoremap <silent> <S-q> <Nop>
set encoding=utf-8
set fileencodings=utf-8
set fileformats=unix,dos,mac
cnoremap Q q!

" For US keyboard
nnoremap ; :
nnoremap ; :

"#######################################################;
" Buffer settings
"#######################################################
nmap [Buffer] <Nop>
map <C-b> [Buffer]

nnoremap [Buffer]<C-b> :b#<CR>
nnoremap [Buffer]<C-p> :bnext<CR>
nnoremap [Buffer]<C-n> :bprev<CR>
nnoremap [Buffer]<C-d> :bp<bar>sp<bar>bn<bar>bd<CR>

"#######################################################
" Yank Settings
"#######################################################
nnoremap <silent> Y <C-v>$"xy
vnoremap <silent> <space>y "+y
nnoremap <silent> <space>y "+y

"#######################################################
" Display settings
"#######################################################
set title
set number
set backspace=indent,eol,start

set synmaxcol=200
set t_Co=256

let s:color_dir = expand('~/.config/nvim/color.vim')
if filewritable(s:color_dir)
  "if you have your colorscheme file
  exe 'source' s:color_dir
else
  set background=dark
  colorscheme lucius
endif

" Cursor settings
set cursorline
highlight CursorLine term=NONE cterm=NONE guibg=Grey90

"#######################################################
" Indent settings
"#######################################################
set autoindent
set cindent
set nosmarttab
set expandtab
nnoremap <silent> > >>
nnoremap <silent> < <<
vnoremap > >`[V`]
vnoremap < <`[V`]

"#######################################################
" Clean all indents
"#######################################################
augroup IndentGroup
  autocmd!
  " Set indent space
  autocmd BufEnter * nnoremap <silent> <buffer> == gg=Gg;zz
  autocmd BufEnter *.vue nnoremap <silent> <buffer> == /<\/template><CR>:noh<CR><Down><S-v>G=Gg;zz
augroup END

"#######################################################
" Around the swap settings
"#######################################################
set noswapfile

"#######################################################
" Search settings
"#######################################################
set incsearch
set ignorecase
set hlsearch
set smartcase
nnoremap <silent> <ESC><ESC> :noh<CR>
nnoremap <silent> <C-c><C-c> :noh<CR>

"#######################################################
" Allow to undo after even closed any files
"#######################################################
if has('persistent_undo')
    set undodir=~/.config/nvim/.undo
    set undofile
endif

"#######################################################
" Move cursor settings
"#######################################################
noremap <silent> <S-j> <C-d>
noremap <silent> <S-k> <C-u>
noremap <silent> <S-l> $
noremap <silent> <S-h> 0
noremap <silent> g; g;zz
noremap <silent> ! %

"#######################################################
" Allow to move the cursor when insert mode
"#######################################################
inoremap <silent> <C-l> <Right>
inoremap <silent> <C-h> <Left>
inoremap <silent> <C-o> <ESC>o

"#######################################################
" Reload settings
"#######################################################
noremap <space>0 :source ~/.nvim/init.vim<CR>

"#######################################################
" Change key mapiings a,A,i,I respectively
"#######################################################
nnoremap <silent> i a
nnoremap <silent> a i
nnoremap <silent> I A
nnoremap <silent> A I
vnoremap <silent> A I
vnoremap <silent> I A

"#######################################################
" Move the cursor to the end of the line
"#######################################################
nmap <silent> v <S-v>

"#######################################################
" Replacement settings
"#######################################################
nnoremap <silent> <space>h "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nmap # <space>h:%s//g<Left><Left><C-r>"/
nmap $ <space>h:%s//g<Left><Left>
vmap # <ESC><space>h:let @a = getpos("'<")[1]<CR>:let @b = getpos("'>")[1]<CR>:<C-r>a,<C-r>bs//g<Left><Left><C-r>"/
vmap $ <ESC><space>h:let @a = getpos("'<")[1]<CR>:let @b = getpos("'>")[1]<CR>:<C-r>a,<C-r>bs//g<Left><Left>

"#######################################################
" Settings to swap rows
"#######################################################
nnoremap <C-n> "zdd"zp
nnoremap <C-p> "zdd<Up>"zP
vnoremap <C-p> "zx<Up>"zP`[V`]
vnoremap <C-n> "zx"zp`[V`]

"#######################################################
" The delete register settings
"#######################################################
nnoremap d "xd
nnoremap D "xD
vnoremap d "xd
nnoremap y "xy
vnoremap y "xy
nnoremap x ""x
noremap p "xp

"#######################################################
" Allow to use of mouse settings
"#######################################################
if has('mouse')
	set mouse=
	nnoremap <silent> <space>m :call <SID>toggle_mouse()<CR>
else
	nnoremap <silent> <space>m :echo 'Mouse function is not enabled'<CR>
endif

if !has('nvim')
    set ttymouse=sgr
endif

function! s:toggle_mouse()
    if &mouse !=# 'a'
		set mouse=a
		echo 'Mouse function is enabled'
    else
		set mouse=
		echo 'Mouse function is disabled'
    endif
endfunction

"#######################################################
" Around the coding style setting
"#######################################################
inoremap ,, <ESC>:%s/\s\+$//e<CR><S-A>,<ESC>
nnoremap ,, <ESC>:%s/\s\+$//e<CR><S-A>,<ESC>
inoremap ;; <ESC><S-A>;<ESC>
nnoremap ;; <ESC><S-A>;<ESC>


"#######################################################
" Tmux settings
"#######################################################
noremap <silent> <C-t> <Nop>
nmap [Tmux] <Nop>
map <C-t> [Tmux]

nnoremap <silent> [Tmux]p <C-w>l
nnoremap <silent> [Tmux]n <C-w>h
