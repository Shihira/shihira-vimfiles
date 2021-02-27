let d = $VIMFILES . "/bundle/"

call plug#begin(d)

Plug 'vim-airline/vim-airline',                 {'dir': d.'airline'}
Plug 'qpkorr/vim-renamer',                      {'dir': d.'renamer'}
Plug 'airblade/vim-rooter',                     {'dir': d.'rooter'}
Plug 'terryma/vim-multiple-cursors',            {'dir': d.'multicursor'}
Plug 'neoclide/coc.nvim',                       {'dir': d.'coc'}
Plug 'OmniSharp/omnisharp-vim',                 {'dir': d.'omnisharp'}
"Plug 'puremourning/vimspector'
"Plug 'vim-scripts/ShaderHighLight',             {'dir': d.'shaderhl'}

call plug#end()
