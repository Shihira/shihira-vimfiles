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
set guioptions=egrmt
set number
set ruler
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,big-5,gbk
set completeopt-=preview
set tabstop=4
set shiftwidth=4
set expandtab
set textwidth=80
set rtp+=$VIMFILES
set winaltkeys=no
set laststatus=2
set makeprg=make
let &colorcolumn=join(range(81,999),",")


filetype plugin indent on
au FileType html setl sw=2 sts=2 et

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
    silent! PlugLoadYcm
    call youcompleteme#Enable()
    exec "NERDTreeFind"
    exec "TagbarToggle"
    call g:GotoMostWindow('l')
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

    call youcompleteme#Enable()
endfunction

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
nmap <C-B><C-S> %v%s<Space><Esc>:call RotateParentheses()<CR>vp
noremap <Esc> :nohl\|set nocul<CR><Esc>
command OpenMyLayout call g:OpenMyLayout()
nmap mm :OpenMyLayout<CR>
nmap md :call g:ShowDefinition(5)<CR>

colorscheme desertEx
syntax enable
syntax on

