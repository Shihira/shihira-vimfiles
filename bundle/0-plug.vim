let d = $VIMFILES . "/bundle/"

call plug#begin(d)

Plug 'vim-airline/vim-airline',                 {'dir': d.'airline'}
Plug 'qpkorr/vim-renamer',                      {'dir': d.'renamer'}
Plug 'neoclide/coc.nvim',                       {'dir': d.'coc', 'branch': 'release'}
Plug 'OmniSharp/omnisharp-vim',                 {'dir': d.'omnisharp'}
Plug 'nfvs/vim-perforce',                       {'dir': d.'perforce'}
"Plug 'lambdalisue/fern.vim',                    {'dir': d.'fern'}
Plug 'easymotion/vim-easymotion',               {'dir': d.'easymotion'}
Plug 'puremourning/vimspector',                 {'dir': d.'vimspector'}
"Plug 'powerman/vim-plugin-AnsiEsc',             {'dir': d.'ansiesc'}

call plug#end()
