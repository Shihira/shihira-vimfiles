let d = $VIMFILES . "/bundle/"

call plug#begin(d)

"Plug 'vim-airline/vim-airline',                 {'dir': d.'airline'}
Plug 'itchyny/lightline.vim',                   {'dir': d.'lightline'}
Plug 'qpkorr/vim-renamer',                      {'dir': d.'renamer'}
Plug 'neoclide/coc.nvim',                       {'dir': d.'coc', 'branch': 'release'}
Plug 'OmniSharp/omnisharp-vim',                 {'dir': d.'omnisharp'}
"Plug 'lambdalisue/fern.vim',                    {'dir': d.'fern'}
Plug 'easymotion/vim-easymotion',               {'dir': d.'easymotion'}
Plug 'puremourning/vimspector',                 {'dir': d.'vimspector'}
"Plug 'github/copilot.vim',                      {'dir': d.'copilot', 'branch': 'release'}
"Plug 'powerman/vim-plugin-AnsiEsc',             {'dir': d.'ansiesc'}
"
Plug 'Exafunction/windsurf.vim',                {'dir': d.'windsurf', 'branch': 'main'}

if has('nvim')
    let nd = $VIMFILES . "/bundle/nvim/"

    " Deps
"    Plug 'nvim-treesitter/nvim-treesitter', {'dir': nd.'treesitter', 'branch': 'main'}
"    Plug 'stevearc/dressing.nvim', {'dir': nd.'dressing', 'branch': 'master'}
"    Plug 'nvim-lua/plenary.nvim', {'dir': nd.'plenary', 'branch': 'master'}
"    Plug 'MunifTanjim/nui.nvim', {'dir': nd.'nui', 'branch': 'main'}
"    Plug 'MeanderingProgrammer/render-markdown.nvim', {'dir': nd.'render-markdown', 'branch': 'main'}
"
"    " Yay, pass source=true if you want to build from source
"    Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make', 'dir': nd.'avante'}

    Plug 'TabbyML/vim-tabby', {'dir': nd.'tabby', 'branch': 'main'}
    Plug 'neovim/nvim-lspconfig', {'branch': 'master', 'dir': nd.'lspconfig'}
endif

call plug#end()
