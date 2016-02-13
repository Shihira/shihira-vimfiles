let d = $VIMFILES . "/bundle/"

call plug#begin(d)

Plug 'Valloric/YouCompleteMe',                  {'dir': d.'youcompleteme', 'on': 'PlugLoadYcm'}
Plug 'lilydjwg/colorizer'
Plug 'scrooloose/nerdtree'
Plug 'mattn/emmet-vim'
Plug 'jmcantrell/vim-virtualenv',               {'dir': d.'virtualenv'}
Plug 'neilagabriel/vim-geeknote',               {'dir': d.'geeknote'}
Plug 'bling/vim-airline',                       {'dir': d.'airline'}
Plug 'fholgado/minibufexpl.vim',                {'dir': d.'minibufexpl'}
Plug 'amoffat/snake'
Plug 'vim-erlang/vim-erlang-runtime',           {'dir': d.'erlrt'}
Plug 'vim-erlang/vim-erlang-omnicomplete',      {'dir': d.'erlomni'}
Plug 'majutsushi/tagbar'

call plug#end()
