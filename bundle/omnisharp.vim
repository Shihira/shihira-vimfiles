let g:OmniSharp_server_path = "D:/Programma/OmniSharp/OmniSharp.exe"
let g:OmniSharp_highlighting = 0

autocmd FileType cs nmap <buffer> <F12> :OmniSharpGotoDefinition<CR>
autocmd FileType cs nmap <buffer> <S-F12> :OmniSharpFindUsages<CR>
autocmd FileType cs nmap <buffer> <F1> :OmniSharpDocumentation<CR>
autocmd FileType cs imap <buffer> ( (<C-O>:OmniSharpSignatureHelp<CR>
autocmd FileType cs imap <buffer> , ,<C-O>:OmniSharpSignatureHelp<CR>

function! s:CodeCheckCB(result)
    sign unplace *
    let i = 0
    for err in a:result
        if err['type'] == 'E'
            execute "sign place ".(100 + i)." line=".err['lnum']." name=CocError file=".err['filename']
            let i = i + 1
        endif
    endfor
    call OmniSharp#locations#SetQuickfix(a:result, "CSharp Errors")
endfunction

nmap <silent> <F5> :call OmniSharp#actions#diagnostics#Check({x -> <SID>CodeCheckCB(x)})<CR>
