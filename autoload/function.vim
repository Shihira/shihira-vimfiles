" @bind-menu
let g:function_annotation_debug = 0

function! function#get_selected_text() range
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

function! function#get_possible_cd_paths(fname)
    let cd_list = [fnamemodify(a:fname, ':h')]

    let current = cd_list[0]
    while 1
        let parent = fnamemodify(current, ':h')

        if parent == current | break | endif

        for pattern in split(g:function_cd_patterns, ':')
            "echo printf('Finding %s in %s', pattern, parent)
            if !empty(globpath(parent, pattern))
                "echo "Yes!"
                let cd_list += [parent]
                break
            endif
            "echo "No!"
        endfor

        let current = parent
    endwhile

    return cd_list
endfunction

function! function#ask_for_option(n, t, tips = "", options = [])
    let current_value = g:[a:n]

    if a:tips != ""
        echo "g:".a:n." (".a:t.")    ".a:tips
    else
        echo "g:".a:n." (".a:t.")"
    endif

    let input_value = current_value
    if a:options != []
        let textlist = ["Available values: (currently ".input_value.")"]
        for i in range(len(a:options))
            let textlist += [(i + 1).". ".a:options[i]]
        endfor
        let input_index = inputlist(textlist)
        if input_index == 0
            return
        endif
        let input_value = a:options[input_index - 1]
    else
        let input_value = input("New value: ", input_value)
    endif

    if a:t == "number"
        let input_value = str2nr(input_value)
    elseif a:t == "float"
        let input_value = str2float(input_value)
    endif

    let g:[a:n] = input_value
endfunction

function! function#process_script_variable(annotations)
    let var_name = a:annotations["var-name"]

    if has_key(a:annotations, "bind-menu")
        let menu_name = a:annotations["bind-menu"]
        if menu_name == ""
            let menu_name = "Shihira.Options.".var_name
        endif

        let cmd = printf('nmenu %s :call function#ask_for_option("%s", "%s", "%s", %s)<CR>',
                    \ menu_name,
                    \ var_name,
                    \ typename(g:[var_name]),
                    \ get(a:annotations, 'tips', ''),
                    \ split(get(a:annotations, 'options', ''), '|'))
        if g:function_annotation_debug | echo cmd | endif
        execute cmd
    endif

    if g:function_annotation_debug | echo a:annotations | endif
endfunction

function! function#process_script_function(annotations, sid)
    let func_name = a:annotations["func-name"]
    if func_name =~ '\(s:\|<SID>\).*'
        let func_name = substitute(func_name, 's:\|<SID>', '', '')
        let func_name = a:sid .. func_name
    endif

    if has_key(a:annotations, "bind-key")
        let cmd = printf("%smap %s :call %s<CR>",
                    \ get(a:annotations, 'bind-key-prefix', 'n'),
                    \ a:annotations["bind-key"],
                    \ func_name)
        if g:function_annotation_debug | echo cmd | endif
        execute cmd
    endif

    if has_key(a:annotations, "bind-command")
        let cmd = printf("command! %s call %s",
                    \ a:annotations["bind-command"],
                    \ func_name)
        if g:function_annotation_debug | echo cmd | endif
        execute cmd
    endif

    if has_key(a:annotations, "bind-menu")
        let cmd = printf("%smenu %s :call %s<CR>",
                    \ get(a:annotations, 'bind-menu-prefix', 'n'),
                    \ a:annotations["bind-menu"],
                    \ func_name)
        if g:function_annotation_debug | echo cmd | endif
        execute cmd
    endif

    if g:function_annotation_debug | echo a:annotations | endif
endfunction

function! function#process_script(fname, sid, phase = "initial")
    let lines = readfile(a:fname)

    let annotations = {}

    let annotation_regex = '^"\s*@\(\S*\)\(:\s*\(.*\)\)\?$'
    let function_regex = '^function.\? \(.*\)(.*$'
    let map_regex = '^\(.\?\)map \(\S*\) :call \(.*\)<[cC][rR]>$'
    let command_regex = '^command.\? \(\S*\) call \(.*\)$'
    let let_regex = '^let\s*g:\(\S*\)\s*=.*$'

    for l in lines
        if l =~ annotation_regex
            let annotation = substitute(l, annotation_regex, '\1', 'g')
            let annotation_value = substitute(l, annotation_regex, '\3', 'g')
            let annotations[annotation] = annotation_value
        elseif l =~ function_regex
            let func_name = substitute(l, function_regex, '\1', 'g')
            let annotations["func-name"] = func_name."()"
            if has_key(annotations, "bind-menu") && has_key(annotations, "bind-command")
                let annotations["bind-menu"] .= '<Tab>:'.annotations["bind-command"]
            elseif has_key(annotations, "bind-menu") && has_key(annotations, "bind-key")
                let annotations["bind-menu"] .= '<Tab>'.annotations["bind-key"]
            endif
            if get(annotations, "phase", "initial") == a:phase
                call function#process_script_function(annotations, a:sid)
            endif
            let annotations = {}
        elseif l =~ map_regex
            let prefix = substitute(l, map_regex, '\1', 'g')
            let key_binding = substitute(l, map_regex, '\2', 'g')
            let func_name = substitute(l, map_regex, '\3', 'g')
            let annotations["func-name"] = func_name
            if has_key(annotations, "bind-menu")
                let annotations["bind-menu"] .= '<Tab>'.key_binding
            endif
            if get(annotations, "phase", "initial") == a:phase
                call function#process_script_function(annotations, a:sid)
            endif
            let annotations = {}
        elseif l =~ let_regex
            let var_name = substitute(l, let_regex, '\1', 'g')
            let annotations["var-name"] = var_name
            if get(annotations, "phase", "initial") == a:phase
                call function#process_script_variable(annotations)
            endif
            let annotations = {}
        else
            let annotations = {}
        endif
    endfor
endfunction

call function#process_script(expand('<sfile>'), expand('<SID>'))

