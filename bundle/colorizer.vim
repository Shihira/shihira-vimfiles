let g:colorizer_startup = 0

au! BufEnter *.css ColorHighlight
au! BufEnter *.html ColorHighlight
au! BufLeave * ColorClear
