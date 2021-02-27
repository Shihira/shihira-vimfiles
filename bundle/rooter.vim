let g:rooter_manual_only = 1
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_patterns = ['.git', '.vim']

function! s:CircularRooter()
    let old_pwd = getcwd()
    Rooter
    if old_pwd == getcwd()
        cd %:p:h
    endif
endfunction

nmap cd :call <SID>CircularRooter()<CR>
