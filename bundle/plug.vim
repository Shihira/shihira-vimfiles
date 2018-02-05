let d = $VIMFILES . "/bundle/"

call plug#begin(d)

Plug 'Valloric/YouCompleteMe',                  {'dir': d.'youcompleteme', 'on': 'PlugLoadYcm'}
Plug 'scrooloose/nerdtree'
Plug 'mattn/emmet-vim',                         {'dir': d.'emmet'}
"Plug 'jmcantrell/vim-virtualenv',               {'dir': d.'virtualenv'}
Plug 'bling/vim-airline',                       {'dir': d.'airline'}
Plug 'fholgado/minibufexpl.vim',                {'dir': d.'minibufexpl'}
Plug 'amoffat/snake',                           {'on': 'PlugLoadSnake'}
Plug 'vim-erlang/vim-erlang-runtime',           {'dir': d.'erlrt'}
Plug 'vim-erlang/vim-erlang-omnicomplete',      {'dir': d.'erlomni'}
Plug 'majutsushi/tagbar'
Plug 'vimoutliner/vimoutliner'
Plug 'qpkorr/vim-renamer',                      {'dir': d.'renamer'}
Plug 'OmniSharp/omnisharp-vim',                 {'dir': d.'omnisharp'}
Plug 'tpope/vim-dispatch',                      {'dir': d.'dispatch'}
Plug 'KabbAmine/zeavim.vim',                    {'dir': d.'zeavim'}
Plug 'tpope/vim-fireplace',                     {'dir': d.'fireplace'}
Plug 'yegappan/mru'
Plug 'shime/vim-livedown',                      {'dir': d.'livedown'}
Plug 'terryma/vim-multiple-cursors',            {'dir': d.'multicursor'}

call plug#end()
