if !has("python3")
    finish
endif

python3 << EOF

import re
import difflib

class SSATool:
    def __init__(self):
        self.ssa_diff_method = str(vim.eval("g:ssa_diff_method"))
        self.ssa_time_thershold = float(vim.eval("g:ssa_time_thershold"))
        self.ssa_text_thershold = float(vim.eval("g:ssa_text_thershold"))

        if len(vim.windows) < 2:
            raise Exception("Required dual-pane")

    def extract_time(self, line, return_timestamp=False):
        match = re.search(r'(\d+):(\d+):(\d+)\.(\d+),(\d+):(\d+):(\d+)\.(\d+)', line)
        if match:
            t1 = int(match.group(1)) * 60 * 60 + \
                 int(match.group(2)) * 60 + \
                 int(match.group(3)) * 1 + \
                 int(match.group(4)) * 0.01
            t2 = int(match.group(5)) * 60 * 60 + \
                 int(match.group(6)) * 60 + \
                 int(match.group(7)) * 1 + \
                 int(match.group(8)) * 0.01

            return t2 - t1 if not return_timestamp else (t2 - t1, t1, t2)

    def extract_dialog(self, line):
        return ','.join(line.split(',')[9:])

    def remove_styles(self, line):
        return re.sub(r'\{.*\}', '', line)

    def diff_line(self, ln, verbose):
        if self.ssa_diff_method == "time":
            for wid in [0, 1]:
                l = self.remove_styles(vim.windows[wid].buffer[ln])
                t = self.extract_time(l)
                if verbose:
                    print(f"{l} -> {t:.2f}s")

            diff = (max(time_elapses) - min(time_elapses)) / min(time_elapses)
            print(f"Diff-Time: {diff * 100:.2f}%")

            if diff < self.ssa_time_thershold and not verbose:
                vim.command("normal j")

        if self.ssa_diff_method == "text":
            l1 = self.remove_styles(vim.windows[0].buffer[ln])
            l2 = self.remove_styles(vim.windows[1].buffer[ln])
            d1 = self.extract_dialog(l1).lower()
            d2 = self.extract_dialog(l2).lower()

            m = difflib.SequenceMatcher(a=d1, b=d2)
            m.ratio()
            min_a = min(map(lambda x: x.a, m.matching_blocks))
            min_b = min(map(lambda x: x.b, m.matching_blocks))
            max_a = max(map(lambda x: x.a + x.size if x.size else min_a, m.matching_blocks))
            max_b = max(map(lambda x: x.b + x.size if x.size else min_b, m.matching_blocks))
            l1 = d1[min_a:max_a - min_a]
            l2 = d2[min_b:max_b - min_b]
            m = difflib.SequenceMatcher(a=l1, b=l2)
            if verbose:
                print(l1)
                print(l2)
            diff = 1 - m.ratio()
            print(f"Diff-Text: {diff * 100:.2f}%")

            if diff < self.ssa_text_thershold and not verbose:
                vim.command("normal j")

    def join_another_pane(self, ln):
        wid = vim.current.window.number - 1
        another_wid = max(0, 1 - wid)

        l1 = vim.windows[wid].buffer[ln]
        l2 = vim.windows[another_wid].buffer[ln]
        d2 = self.extract_dialog(l2)

        vim.windows[wid].buffer[ln] = l1 + "\\N" + d2
        vim.command("normal j")

EOF

" @bind-menu: Shihira.Start\ SSA
function! s:start_ssa()
    normal gg
    setl cursorbind
    setl scrollbind
    setl cursorline
    wincmd w
    normal gg
    setl cursorbind
    setl scrollbind
    setl cursorline
    wincmd w

    call function#process_script(s:sfile, expand('<SID>'), "ssatool")
endfunction

" @phase: ssatool
" @bind-menu: SSATool.Stop\ SSA
function! s:stop_ssa()
    setl nocursorbind
    setl noscrollbind
    setl nocursorline
    wincmd w
    setl nocursorbind
    setl noscrollbind
    setl nocursorline
    wincmd w

    nunmenu SSATool
endfunction

" @bind-menu: Shihira.Hide\ Columns
function! s:hide_columns()
    exec "syntax match Concealed '^.\\{".(getpos('.')[2] - 1)."\\}' conceal"
    set conceallevel=2
endfunction

" @phase: ssatool
" @bind-key: <F5>
" @bind-menu: SSATool.Diff\ Line
function! s:diff_line()
python3 << EOF
ssa_tool = SSATool()
ssa_tool.diff_line(vim.current.window.cursor[0] - 1, False)
del ssa_tool
EOF
endfunction

" @phase: ssatool
" @bind-key: <F6>
" @bind-menu: SSATool.Show\ Diff\ Details
function! s:show_diff_details()
python3 << EOF
ssa_tool = SSATool()
ssa_tool.diff_line(vim.current.window.cursor[0] - 1, True)
del ssa_tool
EOF
endfunction

" @phase: ssatool
" @bind-key: <C-J>
" @bind-menu: SSATool.Join\ Lines
function! s:join_lines()
python3 << EOF
ssa_tool = SSATool()
ssa_tool.join_another_pane(vim.current.window.cursor[0] - 1)
del ssa_tool
EOF
endfunction

" @phase: ssatool
" @options: time|text
" @bind-menu: SSATool.Options.ssa_diff_method
let g:ssa_diff_method = "time"
" @phase: ssatool
" @tips: Range 0.0-0.1
" @bind-menu: SSATool.Options.ssa_time_thershold
let g:ssa_time_thershold = 0.8
" @phase: ssatool
" @tips: Range 0.0-0.1
" @bind-menu: SSATool.Options.ssa_text_thershold
let g:ssa_text_thershold = 0.2

let s:sfile = expand('<sfile>')
call function#process_script(s:sfile, expand('<SID>'))

