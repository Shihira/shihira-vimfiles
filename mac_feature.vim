set guifont=DejaVuSansMonoPowerline:h11

nmap <F2> :silent !open -R %:p<CR>

nmap ∆ <A-j>
nmap ˚ <A-k>
imap ∆ <A-j>
imap ˚ <A-k>

command W silent w !sudo tee % > /dev/null

let g:sep = "/"

