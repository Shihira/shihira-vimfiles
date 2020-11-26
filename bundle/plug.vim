let d = $VIMFILES . "/bundle/"

call plug#begin(d)

Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline',                 {'dir': d.'airline'}
Plug 'majutsushi/tagbar'
Plug 'qpkorr/vim-renamer',                      {'dir': d.'renamer'}
Plug 'yegappan/mru'
Plug 'terryma/vim-multiple-cursors',            {'dir': d.'multicursor'}
Plug 'neoclide/coc.nvim',                       {'dir': d.'coc'}

call plug#end()
