if getfontname("DejaVu Sans Mono for Powerline") != ""
    let &guifont = getfontname("DejaVu Sans Mono for Powerline")." 9"
elseif getfontname("DejaVu Sans Mono") != ""
    let &guifont = getfontname("DejaVu Sans Mono")." 9"
endif

set guifontwide=SimHei\ 9

"au InsertLeave * silent !$VIMFILES/scripts/fcitx-helper.sh save-state-and-off
"au InsertEnter * silent !$VIMFILES/scripts/fcitx-helper.sh recover-state

command W silent w !sudo tee % > /dev/null

let g:sep = "/"

