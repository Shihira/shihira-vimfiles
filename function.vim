
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
