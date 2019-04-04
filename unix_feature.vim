set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set guifontwide=SimHei\ 9

au InsertLeave * silent !$VIMFILES/scripts/fcitx-helper.sh save-state-and-off
au InsertEnter * silent !$VIMFILES/scripts/fcitx-helper.sh recover-state

