let d = $VIMFILES . "/bundle/"

call plug#begin(d)

Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline',                       {'dir': d.'airline'}
Plug 'fholgado/minibufexpl.vim',                {'dir': d.'minibufexpl'}
Plug 'majutsushi/tagbar'
Plug 'qpkorr/vim-renamer',                      {'dir': d.'renamer'}
Plug 'yegappan/mru'
Plug 'terryma/vim-multiple-cursors',            {'dir': d.'multicursor'}
Plug 'Yggdroot/LeaderF',                        {'dir': d.'leaderf'}
Plug 'neoclide/coc.nvim',                       {'dir': d.'coc'}

call plug#end()
