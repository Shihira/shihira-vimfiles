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
set viewoptions=
set sessionoptions=winsize,winpos,tabpages
if has('pythonx') | set pyxversion=3 | endif
if has("gui_running") | set lines=60 columns=250 | endif
"let &colorcolumn=join(range(81,999),",")
"let &fillchars="vert: "


filetype plugin indent on
au FileType html setl sw=2 sts=2 et
au BufRead,BufNewFile *.cl,*.cginc,*.hlsl,*.shader setl filetype=opencl
au BufRead,BufNewFile *.md setl wrap
au BufNewFile,BufRead *.cg,*.cginc set filetype=cg
au BufNewFile,BufRead *.ll set filetype=llvm
au BufNewFile,BufRead *.hlsl,*.hlslc,*.hlslh,*.hlsl,*.compute,*.usf,*.ush set filetype=hlsl
au BufNewFile,BufRead *.glsl,*.geom,*.vert,*.frag,*.gsh,*.vsh,*.fsh,*.vs,*.fs set filetype=glsl
au BufNewFile,BufRead *.shader set filetype=shaderlab
au BufNewFile,BufRead */Trunk/* setl noexpandtab
au TabEnter * silent! execute "cd ".w:cwd
au TabLeave * let w:cwd = getcwd()

"//////////////////////////////////////////////////////////
"Platform detection and settings

exec "source $VIMFILES/".(
            \ has("win32") ? "win32" :
            \ has("mac") ? "mac" :
            \ "unix")."_feature.vim"

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
imap <BS> <Left><Del>
"nnoremap <C-L> <C-I>
nnoremap / :nohl\|set nocul<CR>/
nmap <C-Tab> :tabn<CR>
nmap <C-S-Tab> :tabp<CR>
imap <C-S-V> <C-R>+
cmap <C-S-V> <C-R>+
vmap <C-S-C> "+y

command! -nargs=1 Recode e ++enc=<args>

colorscheme arcadia
syntax enable
syntax on

"//////////////////////////////////////////////////////////
" FUNCTIONALITIES

" @bind-key: <Space><Space>
" @bind-menu: Shihira.Switch\ File\ Windows
function! s:switch_file_windows()
    let init_winnr = winnr()
    wincmd w
    while !&modifiable && winnr() != init_winnr
        wincmd w
    endwhile
endfunction

" @bind-menu: Shihira.Comment\ Block
function! s:comment_block() range
    exec "normal " . a:firstline . "G^"
    exec "normal \<c-v>"
    exec "normal " . a:lastline . "G^"
    exec "normal I" . input("Comment with: ", (
                \ &filetype == "c" || &filetype == "cpp" ? '// ' :
                \ &filetype == "vim" ? '" ' :
                \ '# '))
endfunction

" @bind-menu: Shihira.GoTo\ Line
function! s:goto_line()
    execute "normal $"
    let fn = split(expand("<cWORD>"), ":")
    execute "normal 0"
    call function#switch_file_windows()
    execute "e ".fn[0]
    execute fn[1]
endfunction

" @bind-command: CopyPath
" @bind-menu: Shihira.Copy\ Path
function! s:copy_path()
    let @+ = substitute(expand("%"), "\\", "/", "g")
endfunction

" @bind-command: CopyAbsPath
" @bind-menu: Shihira.Copy\ Absolute\ Path
function! s:copy_abs_path()
    let @+ = substitute(expand("%:p"), "\\", "/", "g")
endfunction

" @bind-menu
let g:function_cd_patterns = '.vim:.git:README.*'

" @bind-key: cd
" @bind-menu: Shihira.Chdir
function! s:ask_for_cd()
    let cd_list = sort(function#get_possible_cd_paths(expand("%:p")))
    let cwd = getcwd()
    let cd_list = filter(cd_list, printf("v:val != '%s'", cwd))

    if len(cd_list) > 1
        let input_index = inputlist(["Candidate paths:"] + map(cd_list, '(v:key + 1).". ".v:val'))
        if input_index > 0
            execute 'cd '.cd_list[input_index - 1]
        endif
    elseif len(cd_list) == 1
        echo 'cd '.cd_list[0]
        execute 'cd '.cd_list[0]
    endif
endfunction

call function#process_script(expand('<sfile>'), expand('<SID>'))

