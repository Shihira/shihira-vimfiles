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
set guioptions=egmtr
set number
set ruler
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,big-5
set completeopt-=preview
set tabstop=4
set shiftwidth=4
set expandtab
set rtp+=$VIMFILES
set winaltkeys=no
set laststatus=2
set makeprg=make
let &colorcolumn=join(range(81,999),",")


filetype plugin indent on
au FileType html setl sw=2 sts=2 et
au BufRead,BufNewFile *.cl setl filetype=opencl
au BufRead,BufNewFile *.md setl wrap

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

"///////////////////////////////////////////////////////////
"Initializing

function! g:OpenMyLayout()
    echo "Loading YouCompleteMe..."
    silent! PlugLoadYcm
    call youcompleteme#Enable()

    echo "Loading Python Snake..."
    silent! PlugLoadSnake

    echo "Loading Layouts Windows..."
    exec "NERDTreeFind"
    exec "TagbarToggle"
    call g:GotoMostWindow('l')
    setlocal noballooneval
    exec "wincmd J"
    call g:GotoMostWindow('k')
    call g:GotoMostWindow('l')
    exec "wincmd L"
    call g:GotoMostWindow('h')
    call g:GotoMostWindow('k')
    call g:SetWindowWidth(22)
    normal gg
    exec "wincmd ="
    exec "wincmd l"
    exec "MBEToggle"
endfunction

"//////////////////////////////////////////////////////////
"MAPPING

nnoremap <A-w> <C-w>
nnoremap <A-]> <C-]>
nnoremap <A-t> <C-t>
inoremap <A-f> <Esc>
inoremap <A-j> <C-n>
inoremap <A-k> <C-p>
nmap <A-j> <C-d>
nmap <A-k> <C-u>
nmap j gj
nmap k gk
imap <BS> <Left><Del>
"imap <C-Tab> <Esc><Tab>
nmap <Tab> :call SwitchInputWindow(4, 5)<CR>
nmap <C-B><C-S> %v%s<Space><Esc>:call RotateParentheses()<CR>vp
noremap <Esc> :nohl\|set nocul<CR><Esc>
nmap <C-T> :call g:GotoWindowId(1)<CR>
nmap <C-E> :call g:GotoWindowId(2)<CR>
command OpenMyLayout call g:OpenMyLayout()
command -nargs=1 Recode e ++enc=<args>
nmap mM :OpenMyLayout<CR>
nmap mD :call g:ShowGoTo("Definition", 5)<CR>
nmap mC :call g:ShowGoTo("Declaration", 5)<CR>

colorscheme sierra
syntax enable
syntax on

