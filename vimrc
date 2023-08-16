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
if has("gui_running") && !exists('g:vimrc_done')
    set lines=60 columns=250
endif

"let &colorcolumn=join(range(81,999),",")
"let &fillchars="vert: "


filetype plugin indent on
au FileType html,typescript,typescriptreact setl sw=2 sts=2 et
au BufRead,BufNewFile *.cl,*.cginc,*.hlsl,*.shader setl filetype=opencl
au BufRead,BufNewFile *.md setl wrap
au BufNewFile,BufRead *.cg,*.cginc set filetype=cg
au BufNewFile,BufRead *.ll set filetype=llvm
au BufNewFile,BufRead *.hlsl,*.hlslc,*.hlslh,*.hlsl,*.compute,*.usf,*.ush set filetype=hlsl
au BufNewFile,BufRead *.glsl,*.geom,*.vert,*.frag,*.gsh,*.vsh,*.fsh,*.vs,*.fs set filetype=glsl
au BufNewFile,BufRead *.shader set filetype=shaderlab
au BufNewFile,BufRead */Trunk/* setl noexpandtab
au TabEnter * silent! execute "cd ".t:cwd
au TabLeave * let t:cwd = getcwd()

"//////////////////////////////////////////////////////////
"Platform detection and settings

exec "source $VIMFILES/".(
            \ has("win32") ? "win32" :
            \ has("mac") ? "mac" :
            \ has("ios") ? "ios" :
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
"inoremap <A-j> <Down>
"inoremap <A-k> <Up>
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
imap <C-S-V> <C-O>"+P
cmap <C-S-V> <C-R>+
vmap <C-S-C> "+y
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

command! -nargs=1 Recode e ++enc=<args>

colorscheme arcadia
syntax enable
syntax on

"//////////////////////////////////////////////////////////
" FUNCTIONALITIES

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

" @bind-command: CopyDepotPath
" @bind-menu: Shihira.Copy\ Perforce\ Depot\ Path
function! s:copy_depot_path()
    let depot_path = split(system("p4 where ".expand("%:p")))[0]
    echo depot_path
    let @+ = depot_path
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
        let input_list = ["Candidate paths:"]
        for i in range(len(cd_list)) | let input_list += [(i+1).". ".cd_list[i]] | endfor

        let input_index = inputlist(input_list)
        if input_index > 0
            execute 'cd '.cd_list[input_index - 1]
        endif
    elseif len(cd_list) == 1
        echo 'cd '.cd_list[0]
        execute 'cd '.cd_list[0]
    endif
endfunction

" @bind-menu: Shihira.Save\ Session
function! s:save_session()
    mksession! ~/session.vim

    let sessionx_lines = []
    for i in range(1, tabpagenr('$'))
        let tab_cwd = gettabvar(i, "cwd")
        if tab_cwd != ""
            call add(sessionx_lines, printf('call settabvar(%d, "cwd", "%s")', i, escape(tab_cwd, '\')))
        endif
    endfor
    call add(sessionx_lines, 'exec "cd ".t:cwd')

    call writefile(sessionx_lines, expand("~/sessionx.vim"))
endfunction
" @bind-menu: Shihira.Restore\ Session
function! s:restore_session()
    source ~/session.vim
endfunction

call function#process_script(expand('<sfile>'), expand('<SID>'))

