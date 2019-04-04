""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" winlayout.vim
"       WinLayout v1.0: 2018.11.9
"
" Author: Shihira Fung (fengzhiping@hotmail.com)
"
" Description: 
"     WinLayout helps you manage your windows in a much more intuitive way
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:winlayout_label_map = {}

function! s:is_hsplit_line(layout, i)
    let layout = a:layout
    let i = a:i
    if i == 0 | return 0 | endif

    let edge = 1
    for j in range(len(layout[0]))
        let edge = edge && (layout[i][j] != layout[i - 1][j])
        if !edge | return edge | endif
    endfor
    return edge
endfunction

function! s:is_vsplit_line(layout, j)
    let layout = a:layout
    let j = a:j
    if j == 0 | return 0 | endif

    let edge = 1
    for i in range(len(layout))
        let line = layout[i]
        let edge = edge && (line[j] != line[j - 1])
        if !edge | return edge | endif
    endfor
    return edge
endfunction

function! s:hsplit(layout, i, wid)
    let layout = a:layout
    let i = a:i
    let wid = a:wid

    let res = [layout[:i - 1], layout[i:]]
    if res[1][0][0] =~ "-"
        let res[1] = res[1][1:]
    endif

    let bottom_id = wid
    call win_gotoid(wid)
    split
    let top_id = win_getid()
    return res + [top_id, bottom_id]
endfunction

function! s:vsplit(layout, j, wid)
    let layout = a:layout
    let j = a:j
    let wid = a:wid

    let res = [layout[:], layout[:]]
    for i in range(len(layout))
        let res[0][i] = res[0][i][:j - 1]
        if res[1][i][j] != "|"
            let res[1][i] = res[1][i][j:]
        else
            let res[1][i] = res[1][i][j+1:]
        endif
    endfor

    let right_id = wid
    call win_gotoid(wid)
    vsplit
    let left_id = win_getid()
    return res + [left_id, right_id]
endfunction

function! s:find_split_line(layout, wid)
    let layout = a:layout
    let wid = a:wid

    if len(layout) < 1 | return | endif
    if len(layout[0]) < 1 | return | endif

    for i in range(1, len(layout) - 1)
        if s:is_hsplit_line(layout, i)
            let res = s:hsplit(layout, i, wid)
            call s:find_split_line(res[0], res[2])
            call s:find_split_line(res[1], res[3])
            return
        endif
    endfor

    for j in range(1, len(layout[0]) - 1)
        if s:is_vsplit_line(layout, j)
            let res = s:vsplit(layout, j, wid)
            call s:find_split_line(res[0], res[2])
            call s:find_split_line(res[1], res[3])
            return
        endif
    endfor

    let s:winlayout_label_map[layout[0][0]] = wid
    call setwinvar(win_id2win(wid), "winlayout_label", layout[0][0])
endfunction

function! s:mock_window(infodict)
    exec "buffer! " . a:infodict["bufnr"]
    for k in keys(a:infodict["variables"])
        let w:[k] = a:infodict["variables"][k]
    endfor
    "call s:swap_window(infodict["winnr"])
endfunction

" create a given layout under the current window
function! winlayout#new_layout(layout)
    let s:winlayout_label_map = {}
    edit __winlayout_placeholder__
    setlocal buftype=nofile
    setlocal nomodifiable
    call s:find_split_line(a:layout, win_getid())
endfunction

" create a given layout globally
function! winlayout#switch_layout(layout)
    let wininfo = getwininfo()[:]
    let old_map = s:winlayout_label_map
    let win_label = winlayout#get_window_label()

    new
    wincmd L

    call winlayout#new_layout(a:layout)

    for wi in wininfo
        if has_key(wi["variables"], "winlayout_label")
            if winlayout#goto_window(wi["variables"]["winlayout_label"]) != 0
                call s:mock_window(wi)
            endif
        endif

        call win_gotoid(wi["winid"])
        hide
    endfor

    call winlayout#goto_window(win_label)
endfunction

function! winlayout#goto_window(label)
    let id = a:label == "" ? 0 : winlayout#get_window_id(a:label)
    if id > 0 | call win_gotoid(id) | endif
    return id
endfunction

function! winlayout#get_window_label()
    return has_key(w:, "winlayout_label") ? w:winlayout_label : ""
endfunction

function! winlayout#get_window_id(label)
    let label = a:label
    if has_key(s:winlayout_label_map, label)
        return s:winlayout_label_map[label]
    else
        "echomsg "Cannot find winlayout label '".label."'"
        return 0
    endif
endfunction

function! winlayout#get_window_labels()
    return s:winlayout_label_map
endfunction

function! winlayout#set_window_height(label, h)
    let id = winlayout#get_window_id(a:label)
    let h = max([a:h, 1])
    if id > 0 | exec win_id2win(id)."resize ".h | endif
endfunction

function! winlayout#set_window_width(label, w)
    let id = winlayout#get_window_id(a:label)
    let w = max([a:w, 1])
    if id > 0 | exec "vertical ".win_id2win(id)."resize ".w | endif
endfunction

function! winlayout#get_window_width(label)
    let id = winlayout#get_window_id(a:label)
    return id > 0 ? winwidth(win_id2win(id)) : 0
endfunction

function! winlayout#get_window_height(label)
    let id = winlayout#get_window_id(a:label)
    return id > 0 ? winheight(win_id2win(id)) : 0
endfunction

function! winlayout#get_sizes()
    let sizes = {}
    for w in getwininfo()
        if !has_key(w["variables"], "winlayout_label")
            continue
        endif
        let label = w["variables"]["winlayout_label"]
        let sizes[label] = [w["width"], w["height"]]
    endfor

    return sizes
endfunction

function! winlayout#calculate_rules(base, rules, flags)
    let layout = []
    for ln in range(len(a:base))
        let layout += [[]]
        let l = a:base[ln]
        for cn in range(len(l))
            let c = a:base[ln][cn]
            let rule = has_key(a:rules, ln.",".cn) ? a:rules[ln.",".cn] : []
            for wn in range(len(rule))
                let w = rule[wn]
                if has_key(a:flags, w) && a:flags[w]
                    let c = w
                    break
                endif
            endfor
            let layout[-1] += [c]
        endfor
    endfor

    return layout
endfunction

function! winlayout#restore_sizes(sizes)
    for [l, w] in items(a:sizes)
        call winlayout#set_window_width(l, w[0])
        call winlayout#set_window_height(l, w[1])
    endfor
endfunction

function! winlayout#eval_geometry(str)
    let str = a:str
    let str = substitute(str, '\([a-zA-Z0-9_]\+\)\.w\s=\(.*\)', 'winlayout#set_window_width("\1", \2)', 'g')
    let str = substitute(str, '\([a-zA-Z0-9_]\+\)\.h\s=\(.*\)', 'winlayout#set_window_height("\1", \2)', 'g')
    let str = substitute(str, '\([a-zA-Z0-9_]\+\)\.w', 'winlayout#get_window_width("\1")', 'g')
    let str = substitute(str, '\([a-zA-Z0-9_]\+\)\.h', 'winlayout#get_window_height("\1")', 'g')
    return eval(str)
endfunction

" @param commands: A list of commands used to open a buffer and set the cursor in the target buffer
" @param bufexpr: name or number of the target buffer. use the current buffer if not set
function! winlayout#open_buffer(commands, ...)
    if a:0 >= 1
        let bufexpr = a:1
        if bufnr(bufexpr) >= 0
            exec "buffer! " . bufexpr
        else
            for cmd in a:commands
                exec cmd
            endfor
            call win_gotoid(bufwinid(bufexpr))
        endif
    else
        for cmd in a:commands
            exec cmd
        endfor
    endif
endfunction

" @param label: The corresponding name of window in layout table
" @param commands: A list of commands used to open a buffer and set the cursor in the target buffer
" @param bufexpr: name or number of the target buffer. use the current buffer if not set
function! winlayout#assign_window_buffer(label, commands, ...)
    let old_winid = win_getid()

    let wid = winlayout#get_window_id(a:label)
    if wid > 0
        let winfo = winlayout#get_sizes()

        call win_gotoid(wid)
        if a:0 >= 1
            call winlayout#open_buffer(a:commands, a:1)
        else
            call winlayout#open_buffer(a:commands)
        endif

        if win_getid() != wid
            let new_wid = win_getid()
            call win_gotoid(wid)
            call s:mock_window(getwininfo(new_wid)[0])
            call win_gotoid(new_wid)
            hide
        endif

        call winlayout#restore_sizes(winfo)
    endif

    call win_gotoid(old_winid)
endfunction

