let $VIMFILES = expand("<sfile>:p:h")

set nocompatible 
set noshowmode
set noerrorbells
set nobackup
set noswapfile
set nowrap
set hlsearch
set incsearch
set autoindent
set cindent
set guioptions=egrmLt
set number
set ruler
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,big-5,gbk
set completeopt-=preview
set tabstop=8
set shiftwidth=8
set expandtab
set textwidth=80
set rtp+=$VIMFILES
set winaltkeys=no
set laststatus=2
let &colorcolumn=join(range(81,999),",")


filetype plugin indent on
au FileType python setl sw=8 sts=8 et
au FileType xml setl sw=4 sts=4 et
au FileType svg setl sw=4 sts=4 et
au FileType html setl sw=4 sts=4 et

"//////////////////////////////////////////////////////////
"Platform detection and settings

let g:os = "unix"
if has("win32")
        let g:os = "win32"
elseif has("mac")
        let g:os = "mac"
endif

exec "source $VIMFILES/".g:os."_feature.vim"
source $VIMFILES/function.vim
for path in split(globpath($VIMFILES, 'bundle/**.vim'), "\n")
        exec "source " . path
endfor

"//////////////////////////////////////////////////////////
"MAPPING

nnoremap <A-e> <C-w>
nnoremap <A-]> <C-]>
nnoremap <A-t> <C-t>
inoremap <A-f> <Esc>
inoremap <A-j> <C-n>
inoremap <A-k> <C-p>
nmap <A-j> <C-d>
nmap <A-k> <C-u>
nmap <F3> <C-W>
imap <BS> <Left><Del>
imap <C-Tab> <Esc><Tab>
nmap <F12> :w<CR>:call g:RefreshCtags("--languages=c,c++ ", "")<CR>
nmap <S-F12> :w<CR>:call g:RefreshCtags("--language-force=c++ ", "")<CR>
nmap <C-B><C-S> 0f,llv%%hx%plvf,hxlp
nmap <F9> :call g:SuperF9(0)<CR>
nmap <C-F9> :call g:SuperF9(1)<CR>
noremap <ESC> :nohl<CR>

colorscheme desertEx
syntax enable
syntax on

