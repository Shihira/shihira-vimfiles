set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9

"if isdirectory(expand("~/Program"))
"    exec "cd ".expand("~/Program")
"endif

" GNOME bug
map <F10> <C-L>
map <C-F10> <C-L>
map <S-F10> <C-L>

au InsertLeave * silent !fcitx-remote | sed s/1/-c/ | sed s/2/-o/ > /tmp/fcitx-state && fcitx-remote -c
au InsertEnter * silent !fcitx-remote $(cat /tmp/fcitx-state)

