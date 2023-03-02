let s:has_coc = isdirectory(expand("$VIMFILES/bundle/coc"))

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <silent><expr> <A-j>
      \ coc#pum#visible() ? coc#pum#next(1) : "\<Down>"
inoremap <silent><expr> <A-k>
      \ coc#pum#visible() ? coc#pum#prev(1) : "\<Up>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" @bind-menu: COC.Switch\ Source\ Header
function! s:switch_source_header()
    let l:cur_file = expand("%:p")

    let l:alter_file = l:cur_file =~ ".*\\.h" ? substitute(l:cur_file, "\\.h", "\\.cpp", "") :
                                              \ substitute(l:cur_file, "\\.cpp", "\\.h", "")

    "echo "Trying ".l:alter_file
    if filereadable(l:alter_file)
        silent execute 'edit ' . l:alter_file
        return
    endif

    " for unreal
    let l:alter_file = l:alter_file =~ ".*Public.*"  ? substitute(l:alter_file, "Public", "Private", "") :
                                     \ ".*Classes.*" ? substitute(l:alter_file, "Classes", "Private", "") :
                                                    \ substitute(l:alter_file, "Private", "Public", "")

    echo "Trying ".l:alter_file
    if filereadable(l:alter_file)
        silent execute 'edit ' . l:alter_file
        return
    elseif l:alter_file =~ ".*Public.*"
        let l:alter_file = substitute(l:alter_file, "Public", "Classes", "")

        echo "Trying ".l:alter_file
        if filereadable(l:alter_file)
            silent execute 'edit ' . l:alter_file
            return
        endif
    endif

    if has("win32")
        let l:cur_file_url = "file:///".substitute(l:cur_file, "\\", "/", "")
    else
        let l:cur_file_url = "file://".l:cur_file
    endif

    let l:alter_file_url = CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': l:cur_file_url})
    if has("win32")
        let l:alter_file = substitute(l:alter_file_url, "file:///", "", "")
    else
        let l:alter_file = substitute(l:alter_file_url, "file://", "", "")
    endif

    "echo "Trying ".l:alter_file
    if filereadable(l:alter_file)
        silent execute 'edit ' . l:alter_file
        return
    endif

    echo "Failed to switch between source/header"
endfunction

" @bind-menu: COC.Options.coc_list_grep_options
" @tips: -w(word) -S(smartcase) -e(regexp, at tail) -l(literal)
let g:coc_list_grep_options = "-u -S -e"
" @bind-menu: COC.Options.coc_list_grep_wrap_word
let g:coc_list_grep_wrap_word = 1
" @bind-menu: COC.Options.coc_list_debug
let g:coc_list_debug = 0

let g:coc_list_rg_glob = {}
" @bind-menu: COC.Options.coc_list_rg_glob
" @tips: $ext (%:p:e, eg. json)
let g:coc_list_rg_glob = '*.$ext:*.c:*.cc:*.cxx:*.cpp:*.h:*.hxx:*.hpp:*.ush:*.usf:!*Engine/Source/ThirdParty/*:!*Saved/*:!*Templates/*'

let s:float_win_hidden = []

"function! s:hide_all_float_win()
"    let s:float_win_hidden = coc#float#get_float_win_list()
"    for id in s:float_win_hidden
"        call popup_hide(id)
"    endfor
"endfunction
"
"function! s:show_all_float_win()
"    for id in s:float_win_hidden
"        call popup_show(id)
"    endfor
"    let s:float_win_hidden = []
"endfunction
"
"if s:has_coc
"    autocmd InsertEnter * call <SID>hide_all_float_win()
"    autocmd InsertLeave * call <SID>show_all_float_win()
"endif

function s:set_rg_argument(lst, base_args)
    let rg_args = a:base_args
    let globs = g:coc_list_rg_glob
                \ ->substitute('\$ext', expand('%:p:e'), 'g')
                \ ->split(':')
    for g in globs
        let rg_args += ['--glob', g]
    endfor

    "echo rg_args
    "call input('')

    "call coc#config('list.source.'.a:lst, {
    "            \ 'command': 'python',
    "            \ 'args': [expand('$VIMFILES/scripts/ripgrep-wrapper.py')] + rg_args
    "            \ })
    call coc#config('list.source.'.a:lst, {
                \ 'command': 'rg',
                \ 'args': rg_args
                \ })
endfunction

function s:execute_coc_list(lst, w = '')
    let w = a:w

    if w == '<selected>'
        let w = function#get_selected_text()
    endif

    if w != ''
        if g:coc_list_grep_wrap_word && (a:lst == 'grep')
            let w = substitute(w, ' ', '\\x20', 'g')
            let w = '\b'.w.'\b'
        else
            let w = substitute(w, ' ', '\\ ', 'g')
        endif
        let w = '--input='.w
    endif

    if a:lst == 'files'
        call s:set_rg_argument('files', ['--follow', '--color', 'never', '--files'])
    elseif a:lst == 'grep'
        call s:set_rg_argument('grep', ['--follow', '--color', 'never'])
        cd .
    endif

    let cmd = printf('CocList --number-select --ignore-case %s %s %s',
                \ (a:lst == 'grep' || a:lst == 'symbols' ? '-I' : a:lst == 'mru' ? '-A' : ''),
                \ w,
                \ a:lst.(a:lst == 'grep' ? ' '.g:coc_list_grep_options : ''))

    if g:coc_list_debug
        echo cmd
    else
        exec cmd
    endif
endfunction

nmap <Leader>l :CocListResume<CR>
" @bind-menu: COC.List.files
nmap <Leader>f :call <SID>execute_coc_list("files")<CR>
" @bind-menu: COC.List.mru
nmap <Leader>m :call <SID>execute_coc_list("mru")<CR>
" @bind-menu: COC.List.symbols
nmap <Leader>s :call <SID>execute_coc_list("symbols")<CR>
" @bind-menu: COC.List.outline\ methods
nmap <Leader>o :call <SID>execute_coc_list("outline methods")<CR>
" @bind-menu: COC.List.grep
nmap <Leader>g :call <SID>execute_coc_list("grep", input("Grep: "))<CR>

vmap <Leader>s :call <SID>execute_coc_list("symbols", "<selected>")<CR>
vmap <Leader>g :call <SID>execute_coc_list("grep", "<selected>")<CR>
vmap <Leader>f :call <SID>execute_coc_list("files", "<selected>")<CR>

nmap <C-P> :CocCommand<CR>
imap <C-P> <C-O>:CocCommand<CR>
vmap <C-P> :CocCommand<CR>

autocmd FileType python,cpp,c nmap <buffer> <F12> :call CocActionAsync('jumpDefinition')<CR>
autocmd FileType python,cpp,c nmap <buffer> <S-F12> :call CocActionAsync('jumpReferences')<CR>
autocmd FileType python,cpp,c nmap <buffer> <F1> :call CocActionAsync('doHover')<CR>

function bundle#coc#register_menu_to_coc()
    if !has('gui') | return | endif
    try
        for [k, v] in items(g:function#registered_menu_entries)
            let escaped_k = substitute(k, '\\', '', 'g')
            let escaped_k = substitute(escaped_k, ' ', '_', 'g')
            let escaped_k = substitute(escaped_k, '<[Tt][Aa][Bb]>.*', '', 'g')
            call coc#add_command(escaped_k, 'call '.v)
        endfor
    catch
    endtry
endfunction

call function#process_script(expand('<sfile>'), expand('<SID>'))
