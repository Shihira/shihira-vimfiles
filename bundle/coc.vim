inoremap <silent><expr> <C-/>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" @bind-key: <C-H>
" @bind-menu: COC.Switch\ Source\ Header
function! s:SwitchSourceHeader()
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

    "echo "Trying ".l:alter_file
    if filereadable(l:alter_file)
        silent execute 'edit ' . l:alter_file
        return
    elseif l:alter_file =~ ".*Public.*"
        let l:alter_file = substitute(l:alter_file, "Public", "Classes", "")

        "echo "Trying ".l:alter_file
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

let g:coc_snippet_next = '<tab>'

" @bind-menu: COC.Options.coc_list_grep_options
" @tips: -e(regex) -S(smartcase) -l(literal) -w(word)
let g:coc_list_grep_options = "-e -S"
" @bind-menu: COC.Options.coc_list_grep_wrap_word
let g:coc_list_grep_wrap_word = 1

function s:execute_coc_list(lst, w = '')
    let w = a:w

    if w == '<selected>'
        let w = function#get_selected_text()
    endif

    if w != ''
        let w = substitute(w, ' ', '\ ', 'g')
        if g:coc_list_grep_wrap_word
            let w = '\w'.w.'\w'
        endif
        let w = '--input='.w
    endif

    execute printf('CocList --number-select %s %s %s',
                \ (a:lst == 'grep' || a:lst == 'symbols' ? '-I' : ''),
                \ w,
                \ a:lst.(a:lst == 'grep' ? ' '.g:coc_list_grep_options : ''))
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

autocmd FileType cpp nmap <buffer> <F12> :call CocActionAsync('jumpDefinition')<CR>
autocmd FileType cpp nmap <buffer> <S-F12> :call CocActionAsync('jumpReferences')<CR>
autocmd FileType cpp nmap <buffer> <F1> :call CocActionAsync('doHover')<CR>

call function#process_script(expand('<sfile>'), expand('<SID>'))
