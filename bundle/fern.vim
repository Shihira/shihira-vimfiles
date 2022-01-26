let g:fern#disable_default_mappings = 1
let g:fern#disable_default_mappings = 1
let g:fern#disable_drawer_auto_quit = 1
let g:fern#disable_viewer_hide_cursor = 1

function! FernInit() abort
  nmap <buffer> l <Plug>(fern-action-open)
  nmap <buffer> h <Plug>(fern-action-leave)
  nmap <buffer> <2-LeftMouse> <Plug>(fern-action-open)

  nmap <buffer> m <Plug>(fern-action-mark:toggle)j
  nmap <buffer> N <Plug>(fern-action-new-file)
  nmap <buffer> K <Plug>(fern-action-new-dir)
  nmap <buffer> D <Plug>(fern-action-remove)
  nmap <buffer> C <Plug>(fern-action-move)
  nmap <buffer> R <Plug>(fern-action-rename)
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> <nowait> d <Plug>(fern-action-hidden:toggle)
  nmap <buffer> <nowait> < <Plug>(fern-action-leave)
  nmap <buffer> <nowait> > <Plug>(fern-action-enter)
endfunction

augroup FernEvents
  autocmd!
  autocmd FileType fern call FernInit()
augroup END

let g:fern#mark_symbol                       = '●'
let g:fern#renderer#default#collapsed_symbol = '▶ '
let g:fern#renderer#default#expanded_symbol  = '▼ '
let g:fern#renderer#default#leading          = '  '
let g:fern#renderer#default#leaf_symbol      = '  '
let g:fern#renderer#default#root_symbol      = '# '
