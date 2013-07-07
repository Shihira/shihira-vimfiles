
"///////////////////////////////////////////////////////////////////////////////
"// Tagbar & NERDTree
let s:CurrentPlugin = [0, "TagbarClose", "NERDTreeToggle"]
autocmd User SwitchPluginWindow execute s:CurrentPlugin[1]
autocmd User SwitchPluginWindow execute s:CurrentPlugin[2]
autocmd User SwitchPluginWindow call g:GotoMostWindow('h')
autocmd User SwitchPluginWindow call g:SetWindowWidth(25)
autocmd User SwitchPluginWindow call g:GotoMostWindow('l')
autocmd User SwitchPluginWindow if s:CurrentPlugin[0] == 0
autocmd User SwitchPluginWindow         let s:CurrentPlugin = [1, "NERDTreeClose", "TagbarOpen"]
autocmd User SwitchPluginWindow elseif s:CurrentPlugin[0] == 1
autocmd User SwitchPluginWindow         let s:CurrentPlugin = [0, "TagbarClose", "NERDTreeToggle"]
autocmd User SwitchPluginWindow endif

let g:tagbar_left = 1

nmap <F11> :doautocmd User SwitchPluginWindow<CR>

"///////////////////////////////////////////////////////////////////////////////
"// Clang Complete

let g:clang_user_options = ""
for ipath in include_path
        let g:clang_user_options .= " -isystem" . ipath
        let &path .= "," . ipath
endfor
let g:clang_user_options .= " -pthread"


let g:clang_use_library = 1
let g:clang_snippets = 1
let g:clang_close_preview = 1
let g:clang_complete_macros = 1
" let g:clang_user_options = include_path . flag 
let g:clang_complete_patterns = 1

nmap <F5>  :call g:ClangUpdateQuickFix()<CR>
imap <C-C> <C-X><C-O><C-P>

"//////////////////////////////////////////////////////////////////////////////
"// NeoComplcache

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_force_overwrite_completefunc = 1
inoremap <expr><space>  pumvisible() ? neocomplcache#close_popup() . "\<SPACE>" : "\<SPACE>"

