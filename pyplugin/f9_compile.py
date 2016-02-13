from snake import *
from functools import *
import re

cmd_map = {
        "c": ["gcc <filename> -o <dirname>/<basename> -Wall -g -std=c99 -O0",
                "cd <dirname> && <dirname>/<basename>"],
        "cpp": ["g++ <filename> -o <dirname>/<basename> -Wall -g -std=c++11 -O0",
                "cd <dirname> && <dirname>/<basename>"],
        "java": ["javac <filename>",
                "cd <dirname> && java <basename>"],
        "dot": ["dot -Tpng <filename> -o <dirname>/<basename>.png",
                "shotwell <dirname>/<basename>.png &"],
}

cmd_pattern = {
        "c":   [r"\/\*\s*build-cmd:\s*(.+?)\s*\*\/",
                  r"//\s*build-cmd:\s*(.+?)\s*\n"],
        "cpp": [r"\/\*\s*build-cmd:\s*(.+?)\s*\*\/",
                  r"//\s*build-cmd:\s*(.+?)\s*\n"],
}

cflags_pattern = {
        "c":   [r"\/\*\s*cflags:\s*(.+?)\s*\*\/",
                  r"//\s*cflags:\s*(.+?)\s*\n"],
        "cpp": [r"\/\*\s*cflags:\s*(.+?)\s*\*\/",
                  r"//\s*cflags:\s*(.+?)\s*\n"],
}

def execute_complication(exec_cmd):
        command("set makeprg=make")
        global cmd_map, cmd_pattern

        filename = expand("%:p")
        basename = expand("%:p:t:r")
        dirname = expand("%:p:h")

        filetype = get_option("filetype")
        commands = []

        # search build command in file comment
        buf = "\n".join(vim.current.buffer)
        if filetype in cmd_pattern:
                for cp in cmd_pattern[filetype]:
                        commands += re.findall(cp, buf)
        # use default while build command cannot be found
        if not commands and filetype in cmd_map:
                commands += cmd_map[filetype]
                if filetype in cflags_pattern:
                        for flag in cflags_pattern[filetype]:
                                commands[0] = " ".join(commands[:1] +
                                        re.findall(flag, buf))

        for i, sub_cmd in enumerate(commands):
                commands[i] = sub_cmd \
                        .replace("<basename>", basename) \
                        .replace("<filename>", filename) \
                        .replace("<dirname>",  dirname)

        vim.options['makeprg'] = " && " \
                        .join(commands[:exec_cmd])
        command("make")
        #command("set makeprg=make")

key_map("<F9>", partial(execute_complication, 1))
key_map("<C-F9>", partial(execute_complication, 2))

