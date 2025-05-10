if !has('nvim')
    set guifont=Dejavu_Sans_Mono_for_Powerline:h9
    set guifontwide=SimHei:h9
    set pythonthreedll=C:\Users\clairfeng\AppData\Local\Programs\Python\Python39\python39.dll
else
    set guifont=Dejavu_Sans_Mono_for_Powerline:h7
endif

set fileformats=unix,dos

nmap <F2> :silent !explorer /select,%:p<CR>
"nmap <F2> :silent !\%LOCALAPPDATA\%/Microsoft/WindowsApps/files -Select %:p<CR>

" @bind-command: MaximizeCrossScreen
" @bind-menu: Shihira.Maximize\ Cross\ Screen
function! s:maximize_cross_screen()
py3 << EOF
try:
    import pygetwindow as gw
except:
    print("Please install pygetwindow first.")

gw.getActiveWindow().moveTo(-10,0)
EOF

    if has('nvim')
py3 << EOF
gw.getActiveWindow().resizeTo(1920*4+20, 1080*2-750)
EOF
    else
py3 << EOF
gw.getActiveWindow().resizeTo(1920*4+20, 1080*2-50)
EOF
    endif

    vs | q
    let cur_winnr = winnr()
    let max_winnr = winnr('$')
    exec (max_winnr / 2).'wincmd w'
    2wincmd >
    exec cur_winnr.'wincmd w'
endfunction

call function#process_script(expand('<sfile>'), expand('<SID>'))

let g:sep = "\\"

