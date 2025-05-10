let g:copilot_filetypes = {
      \ '*': v:false,
      \ }

"imap <silent><script><expr> <C-Enter> copilot#Accept("\<CR>")
"let g:copilot_no_tab_map = v:true

"let g:tabby_agent_start_command = ["npx", "tabby-agent", "--stdio"]
"let g:tabby_inline_completion_trigger = "auto"

imap <silent><script><nowait><expr> <C-Enter> codeium#Accept()
let g:codeium_no_map_tab = v:true

