inoremap <silent><expr> <TAB>
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
    if has("win32")
        let l:cur_file = "file:///".substitute(l:cur_file, "\\", "/", "")
    else
        let l:cur_file = "file://".l:cur_file
    endif
    let l:alter = CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': cur_file})
    if has("win32")
        let l:alter = substitute(l:alter, "file:///", "", "")
    else
        let l:alter = substitute(l:alter, "file://", "", "")
    endif
    execute 'edit ' . l:alter
endfunction

let g:coc_snippet_next = '<tab>'

nmap <Leader>f :CocList files<CR>
nmap <Leader>m :CocList mru<CR>
nmap <Leader>s :CocList -I symbols<CR>
nmap <Leader>g :<C-u>execute 'CocList --input='.substitute(input("Grep: "), " ", "\\ ", "").' grep'<CR>
vmap <Leader>s :<C-u>execute 'CocList -I --input='.g:GetSelectedText().' symbols'<CR>
vmap <Leader>g :<C-u>execute 'CocList --input='.g:GetSelectedText().' grep'<CR>
autocmd FileType cpp nmap <buffer> <F12> :call CocActionAsync('jumpDefinition')<CR>
autocmd FileType cpp nmap <buffer> <S-F12> :call CocActionAsync('jumpReferences')<CR>
autocmd FileType cpp nmap <buffer> <C-H> :call <SID>SwitchSourceHeader()<CR>
autocmd FileType cpp nmap <buffer> <F1> :call CocActionAsync('doHover')<CR>
