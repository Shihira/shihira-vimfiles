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
set guioptions=egmr "t
"set showtabline=0
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
if has('pythonx') | set pyxversion=3 | endif
let &colorcolumn=join(range(81,999),",")
let &fillchars="vert: "


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

let g:my_layout = [
    \ "F|00",
    \ "T|00",
    \ ]

function! s:geometry_restriction()
    call winlayout#eval_geometry("F.w = 30")
    call winlayout#eval_geometry("F.h = (F.h + T.h) / 2")
    if winlayout#get_window_id("Q")
        call winlayout#eval_geometry("0.h = 0.h + Q.h - 10")
    endif
    if winlayout#get_window_id("1")
        call winlayout#eval_geometry("0.w = (0.w + 1.w) / 2")
    endif
endfunction

function! g:OpenMyLayout()
    let cur_buf = bufnr('%')

    call winlayout#switch_layout(g:my_layout)
    call winlayout#assign_window_buffer("F", ["NERDTree"], "NERD")
    call winlayout#assign_window_buffer("T", ["Tagbar"], "Tagbar")
    call winlayout#assign_window_buffer("0", [], cur_buf)
    silent call s:geometry_restriction()

    call winlayout#goto_window("0")
    exec "buffer " . cur_buf
endfunction

function! g:ToggleQuickfix()
    if g:my_layout[1][2] == "Q"
        let g:my_layout[1] = "T|".g:my_layout[0][2:]
    else
        let g:my_layout[1] = "T|QQ"
    endif

    call winlayout#switch_layout(g:my_layout)
    silent call s:geometry_restriction()
endfunction

function! g:ToggleDualPane()
    if g:my_layout[0][3] == "0"
        let g:my_layout[0] = substitute(g:my_layout[0], "00", "01", "")
        let g:my_layout[1] = substitute(g:my_layout[1], "00", "01", "")
    else
        let g:my_layout[0] = substitute(g:my_layout[0], "01", "00", "")
        let g:my_layout[1] = substitute(g:my_layout[1], "01", "00", "")
    endif

    call winlayout#switch_layout(g:my_layout)
    silent call s:geometry_restriction()
endfunction

function! g:SwitchQuickfix()
    let sel = input("[q] Quickfix\n[t] Terminal\n[p] Preview\n\nChoose a functionality: ")
    if sel =~ '^[qQ]'
        call winlayout#assign_window_buffer("Q", ["copen"], "Quickfix")
    elseif sel =~ '^[tT]'
        call winlayout#assign_window_buffer("Q", ["terminal ++noclose"], "!/bin/zsh")
    elseif sel =~ '^[pP]'
        call winlayout#assign_window_buffer("Q", ["enew", "let &pvw = 1"])
    else
        call winlayout#assign_window_buffer("Q", [sel])
    endif
endfunction

nnoremap <F3> :call g:ToggleDualPane()<CR>
nnoremap <F4> :call g:ToggleQuickfix()<CR>
nnoremap <S-F4> :call g:SwitchQuickfix()<CR>

"//////////////////////////////////////////////////////////
"MAPPING

nnoremap <A-w> <C-w>
nnoremap <A-]> <C-]>
nnoremap <A-t> <C-t>
inoremap <A-f> <Esc>
inoremap <A-j> <C-n>
inoremap <A-k> <C-p>
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"
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

colorscheme arcadia
syntax enable
syntax on

