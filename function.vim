function! g:GotoMostWindow(direction)
	execute "10wincmd " . a:direction 
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

function! g:GotoWindowId(id)
    if winnr() == a:id
        if exists("g:__prev_window")
            call win_gotoid(win_getid(g:__prev_window))
        endif
    else
        let g:__prev_window = winnr()
        call win_gotoid(win_getid(a:id))
    endif
endfunction

function! g:SwitchInputWindow(w1, w2)
    if winnr() == a:w1
        call win_gotoid(win_getid(a:w2))
    elseif winnr() == a:w2
        call win_gotoid(win_getid(a:w1))
    endif
endfunction

