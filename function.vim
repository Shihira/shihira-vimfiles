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

