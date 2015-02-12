let d = $VIMFILES . "/bundle/"

call plug#begin(d)

Plug 'Valloric/YouCompleteMe',                  {'dir': d.'youcompleteme', 'on': ['YCMComes'] }
Plug 'lilydjwg/colorizer'
Plug 'scrooloose/nerdtree'
Plug 'mattn/emmet-vim'
Plug 'jmcantrell/vim-virtualenv',               {'dir': d.'virtualenv'}
Plug 'neilagabriel/vim-geeknote',               {'dir': d.'geeknote'}
Plug 'bling/vim-airline',                       {'dir': d.'airline'}

call plug#end()
