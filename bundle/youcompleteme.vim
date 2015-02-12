nmap mc :call youcompleteme#Enable()<CR>

let g:ycm_global_ycm_extra_conf = $VIMFILES . '/.ycm_extra_conf.py'
let g:ycm_use_ultisnips_completer = 1

au VimEnter * silent! YCMComes
