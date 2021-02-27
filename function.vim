"///////////////////////////////////////////////////////////
" LAYOUTS

let g:base_layout = [
    \ "F|00",
    \ "T|00",
    \ ]
let g:layout_rules = {
    \ "0,3": "10",
    \ "1,2": "Q0",
    \ "1,3": "Q10",
    \ }
let g:enabled_window = { }

function! s:apply_rules()
    let layout = winlayout#calculate_rules(g:base_layout, g:layout_rules, g:enabled_window)
    call winlayout#switch_layout(layout)
endfunction

function! s:geometry_restriction()
    call winlayout#eval_geometry("F.w = 30")
    call winlayout#eval_geometry("F.h = (F.h + T.h) / 2")
    call winlayout#eval_geometry("Q.h = 10")
    call winlayout#eval_geometry("1.w = (0.w + 1.w) / 2")
endfunction

function! g:OpenMyLayout()
    let cur_buf = bufnr('%')

    call s:apply_rules()
    call winlayout#assign_window_buffer("F", ["NERDTree"], "NERD")
    call winlayout#assign_window_buffer("T", ["Tagbar"], "Tagbar")
    call winlayout#assign_window_buffer("0", [], cur_buf)
    silent call s:geometry_restriction()

    call winlayout#goto_window("0")
    exec "buffer " . cur_buf
endfunction

function! g:ToggleQuickfix()
    let qfwin = win_id2win(getqflist({'winid': 0})['winid'])
    if winnr() != qfwin
        botright cwindow
        let qfwin = win_id2win(getqflist({'winid': 0})['winid'])
        execute qfwin."wincmd w"
    else
        cclose
    end
endfunction

function! g:ToggleDualPane()
    let g:enabled_window["1"] = !winlayout#get_window_id("1")
    call s:apply_rules()
    silent call s:geometry_restriction()
endfunction

function! g:SwitchQuickfix()
endfunction

function! g:SwitchFileWindows()
    let init_winnr = winnr()
    wincmd w
    while !&modifiable && winnr() != init_winnr
        wincmd w
    endwhile
endfunction

"///////////////////////////////////////////////////////////
" FUNCTIONALITIES

function! g:CommentOut() range
    exec "normal " . a:firstline . "G^"
    exec "normal \<c-v>"
    exec "normal " . a:lastline . "G^"
    exec "normal I" . input("Comment with: ", "// ")
endfunction

function! g:GetSelectedText() range
    let old_content = @@
    if visualmode() ==# 'v'
        normal! `<v`>y
    elseif visualmode() ==# 'char'
        normal! `[v`]y
    else
        return ""
    endif

    let new_content = @@
    let @@ = old_content

    return new_content
endfunction
