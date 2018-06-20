let s:cqueryInitArg = {
    \ "cacheDirectory": expand('~/.cache/cquery/'),
    \ "compilationDatabaseCommand": "bash -c cat\ \$1/build/compile_commands.json",
\ }

let s:clangServerCommands = ['cquery',
    \ '--language-server',
    \ '--init='.json_encode(s:cqueryInitArg)
\ ]

let g:LanguageClient_serverCommands = {
    \ 'cpp': s:clangServerCommands,
    \ 'c': s:clangServerCommands,
    \ 'python': ['pyls'],
    \ 'cs.disabled': ['mono', expand('~/Software/OmniSharp/omnisharp-mono/OmniSharp.exe'), '--languageserver'],
\ }

let g:LanguageClient_rootMarkers = {
    \ 'cpp': ['.git', 'build'],
    \ 'cs.disabled': ['.git', '*.csproj'],
\ }

let g:LanguageClient_windowLogMessageLevel = "Info"
let g:LanguageClient_loggingLevel = 'DEBUG'
let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
let g:LanguageClient_settingsPath = expand($VIMFILES.'/lsp_settings.json')

" OmniSharp
let g:OmniSharp_server_path = '/home/shihira/Software/OmniSharp/omnisharp.http-mono/OmniSharp.exe'
let g:OmniSharp_server_use_mono = 1
let g:syntastic_cs_checkers = ['code_checker']
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

let g:deoplete#enable_at_startup = 1

autocmd FileType cs call deoplete#custom#var('omni', 'input_patterns', { 'cs': ['[^. *\t]\.\w*'] })
autocmd FileType cs call deoplete#enable_logging("DEBUG", "/tmp/deoplete.log")

