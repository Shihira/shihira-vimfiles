nmap mc :call youcompleteme#Enable()<CR>

let g:ycm_global_ycm_extra_conf = $VIMFILES . '/.ycm_extra_conf.py'

au VimEnter * silent! YCMComes
