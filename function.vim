function! g:GotoMostWindow(direction)
	execute winnr() . "wincmd " . a:direction 
endfunction

function! g:SetWindowWidth(width)
	let cur_width = winwidth(winnr())
	let cur_width -= a:width
	if cur_width > 0
		execute cur_width . "wincmd <"
	elseif cur_width < 0
		execute - cur_width . "wincmd >"
	endif
endfunction

function! g:RefreshCtags(language, name)
	let cur_dir = getcwd()
        let div_idx = strridx(cur_dir, "\\")
        let tag_name = strpart(cur_dir, div_idx + 1, strlen(cur_dir) - div_idx - 1)

        if a:name != ""
                let tag_name = a:name
        endif

	execute "cd $VIMFILES/tags/"
	execute "!ctags -R " . a:language . " --c++-kinds=+p --fields=+iaS --extra=+q -f " . tag_name . ".tags " . cur_dir
        execute "cd " . cur_dir
endfunction

let g:cp_types = {
      \ "c": ["gcc %s -o %s -Wall -g -std=c99", "%s", ""],
      \ "cpp": ["g++ %s -o %s -Wall -g -std=c++11", "%s", ""],
      \ "dot": ["dot -Tpng %s -o %s", "shotwell %s &", ".png"],
      \ }

function! g:SuperF9(ctrl)
        if(exists(printf('g:cp_types["%s"]', &syntax)))
                write
                let conf = g:cp_types[&syntax]
                let fin = expand("%:p")
                let fout = expand("%:p:r").conf[2]
                let orgprg = &makeprg
                if(a:ctrl)
                        let &makeprg = printf("%s && %s", printf(conf[0], fin, fout), printf(conf[1], fout))
                else
                        let &makeprg = printf("%s", printf(conf[0], fin, fout))
                endif
                make
                let &makeprg = orgprg
        endif
endfunction

