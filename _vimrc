set nocompatible 
set nobackup
set nowrap
set hlsearch
set incsearch
set autoindent
set cindent
set guioptions=egmrLt
set guifont=DejaVu_Sans_Mono:h9
set number
set ruler
set fileencodings=ucs-bom,utf-8,gbk
set completeopt-=preview
set tabstop=8
set shiftwidth=8
set expandtab
set errorformat^=%-GIn\ file\ included\ %.%# 

call pathogen#infect()
filetype plugin indent on

let g:os = "unix"
if has("win32")
        let g:os = "win32"
elseif has("mac")
        let g:os = "mac"
endif

"//////////////////////////////////////////////////////////

let $VIMFILES = expand("<sfile>:p:h")

set tags+=$VIMFILES/tags/include.tags;
set tags+=$VIMFILES/tags/asio.tags;

if g:os == "unix"
source $VIMFILES/unix_feature.vim
elseif g:os == "win32"
source $VIMFILES/win32_feature.vim
endif
source $VIMFILES/function.vim
source $VIMFILES/plugin.vim

"MAPPING
nmap <F3>  <C-W>
nmap <C-TAB> :bn!<CR>
nmap <S-Tab> <F3>kd<F3>j
imap <BS> <Left><Del>
imap <C-Tab> <Esc><Tab>
nmap <F12> :w<CR>:call g:RefreshCtags("--languages=c,c++ ", "")<CR>
nmap <C-B><C-S> 0f,llv%%hx%plvf,hxlp
noremap <ESC> :nohl<CR>


colorscheme desertEx
syntax enable
syntax on
