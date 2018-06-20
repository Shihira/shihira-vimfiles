let d = $VIMFILES . "/bundle/"

call plug#begin(d)

Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline',                       {'dir': d.'airline'}
Plug 'fholgado/minibufexpl.vim',                {'dir': d.'minibufexpl'}
Plug 'amoffat/snake',                           {'on': 'PlugLoadSnake'}
Plug 'majutsushi/tagbar'
Plug 'qpkorr/vim-renamer',                      {'dir': d.'renamer'}
Plug 'KabbAmine/zeavim.vim',                    {'dir': d.'zeavim'}
Plug 'yegappan/mru'
Plug 'terryma/vim-multiple-cursors',            {'dir': d.'multicursor'}
Plug 'Yggdroot/LeaderF',                        {'dir': d.'leaderf'}

""" Completion
Plug 'Shougo/deoplete.nvim',                    {'dir': d.'deoplete'}
Plug 'autozimu/LanguageClient-neovim',          {'dir': d.'langclient', 'branch': 'next'}
Plug 'OmniSharp/omnisharp-vim',                 {'dir': d.'omnisharp'}
"Plug 'prabirshrestha/async.vim',                {'dir': d.'DEPS/async'}
"Plug 'prabirshrestha/vim-lsp',                  {'dir': d.'lsp'}

""" DEPS
Plug 'roxma/nvim-yarp',                         {'dir': d.'DEPS/nvim-yarp'}
Plug 'roxma/vim-hug-neovim-rpc',                {'dir': d.'DEPS/vim-hug-neovim-rpc'}

call plug#end()
