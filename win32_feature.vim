set guifont=Dejavu_Sans_Mono_for_Powerline:h9
set guifontwide=SimHei:h9
set pythonthreedll=C:\Users\clairfeng\AppData\Local\Programs\Python\Python39\python39.dll
set fileformats=unix,dos

nmap <F2> :silent !explorer /select,%:p<CR>

" @bind-command: MaximizeCrossScreen
" @bind-menu: Shihira.Maximize\ Cross\ Screen
function! s:maximize_cross_screen()
py3 << EOF
try:
    import pygetwindow as gw
except:
    print("Please install pygetwindow first.")

gw.getActiveWindow().moveTo(-10,0)
gw.getActiveWindow().resizeTo(1920*4+20, 1080*2-50)
EOF
endfunction

call function#process_script(expand('<sfile>'), expand('<SID>'))

