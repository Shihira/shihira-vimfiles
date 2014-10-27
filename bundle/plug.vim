let d = $VIMFILES . "/bundle/"

call plug#begin(d)

Plug 'fholgado/minibufexpl.vim',                {'dir': d.'minibufexpl'}
Plug 'Valloric/YouCompleteMe',                  {'dir': d.'youcompleteme', 'on': ['YCMComes'] }
Plug 'lilydjwg/colorizer',                      {'dir': d.'colorizer'}
Plug 'scrooloose/nerdtree',                     {'dir': d.'nerdtree'}
Plug 'vim-scripts/c.vim',                       {'dir': d.'cvim'}

call plug#end()
