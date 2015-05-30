
function! g:FromBufName()
        let path = ""
        let name = bufname("%")

        if(name == "")
                let path = " "
        elseif(name =~ 'NERD_tree_\d*')
                let path = input("Change to Path: ",
                \ g:NERDTreeDirNode.GetSelected().path.str())
        else
                let path = input("Change to Path:", name)
        endif

        " windows needs them
        if(path[len(path) - 1] == ":") |let path .= "\\" | endif
        exec "NERDTree " . path
        if(path =~ "[A-Z]:\\.*") | exec "cd " . path[0:2] | endif

        " set width
        let cur_win = winnr()
        call g:GotoMostWindow("h")
        exec "normal 20\<C-w>|"
        exec "normal ".cur_win."<C-w>w"
endfunction

nmap <F11> :call g:FromBufName()<CR>
