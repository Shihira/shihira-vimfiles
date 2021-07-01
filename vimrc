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
set wildmode=list:longest,full
if has('pythonx') | set pyxversion=3 | endif
"let &colorcolumn=join(range(81,999),",")
"let &fillchars="vert: "


filetype plugin indent on
au FileType html setl sw=2 sts=2 et
au BufRead,BufNewFile *.cl *.cginc *.hlsl *.shader setl filetype=opencl
au BufRead,BufNewFile *.md setl wrap
au BufNewFile,BufRead *.cg,*.cginc set filetype=cg
au BufNewFile,BufRead *.hlsl,*.hlslc,*.hlslh,*.hlsl,*.compute set filetype=hlsl
au BufNewFile,BufRead *.glsl,*.geom,*.vert,*.frag,*.gsh,*.vsh,*.fsh,*.vs,*.fs set filetype=glsl
au BufNewFile,BufRead *.shader set filetype=shaderlab

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
" MAPPING

nnoremap <A-w> <C-w>
nnoremap <A-]> <F12>
nnoremap <A-i> <C-i>
nnoremap <A-o> <C-o>
inoremap <A-j> <C-n>
inoremap <A-k> <C-p>
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"
nmap <A-j> <C-d>
nmap <A-k> <C-u>
nmap j gj
nmap k gk
"nmap cd :cd %:p:h<CR>
imap <BS> <Left><Del>
"imap <C-Tab> <Esc><Tab>
nnoremap <Tab><Tab> :call g:SwitchFileWindows()<CR>
nnoremap <F3> :call g:ToggleDualPane()<CR>
nnoremap <F4> :call g:ToggleQuickfix()<CR>
nnoremap <S-F4> :call g:SwitchQuickfix()<CR>
nnoremap / :nohl\|set nocul<CR>/
command! OpenMyLayout call g:OpenMyLayout()
command! -nargs=1 Recode e ++enc=<args>
nmap mM :OpenMyLayout<CR>
nmap mD :call g:ShowGoTo("Definition", 5)<CR>
nmap mC :call g:ShowGoTo("Declaration", 5)<CR>

colorscheme arcadia
syntax enable
syntax on

