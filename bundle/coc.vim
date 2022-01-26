inoremap <silent><expr> <C-/>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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

nmap <Leader>f :CocList --number-select files<CR>
nmap <Leader>m :CocList --number-select mru<CR>
nmap <Leader>s :CocList --number-select -I symbols<CR>
nmap <Leader>o :CocList --number-select outline methods<CR>
nmap <Leader>l :CocListResume<CR>

nmap <Leader>g :<C-u>execute 'CocList --number-select --input='.substitute(input("Grep: "), " ", "\\ ", "").' grep'<CR>
vmap <Leader>s :<C-u>execute 'CocList --number-select -I --input='.g:GetSelectedText().' symbols'<CR>
vmap <Leader>g :<C-u>execute 'CocList --number-select --input='.g:GetSelectedText().' grep'<CR>
autocmd FileType cpp nmap <buffer> <F12> :call CocActionAsync('jumpDefinition')<CR>
autocmd FileType cpp nmap <buffer> <S-F12> :call CocActionAsync('jumpReferences')<CR>
autocmd FileType cpp nmap <buffer> <C-H> :call <SID>SwitchSourceHeader()<CR>
autocmd FileType cpp nmap <buffer> <F1> :call CocActionAsync('doHover')<CR>
