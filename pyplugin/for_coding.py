import snake
from . import function_map

def show_goto(func, winnr):
    if snake.get_buffer_in_window(winnr) == -1:
        print "Window does not exist."
        return

    cur_winnr = snake.get_current_window()
    pos = snake.get_cursor_position()
    bufnr = snake.get_current_buffer()
    snake.command("%d wincmd w" % winnr)
    snake.set_buffer(bufnr)
    snake.set_cursor_position(pos)

    snake.command("YcmCompleter GoTo" + func)
    snake.set_option("cursorline")
    snake.command("au BufWinEnter * set nocursorline")
    snake.command("%d wincmd w" % cur_winnr)

def rotate_parentheses():
    proc = "%s"

    cont = snake.get_register('"')
    if cont[0] == "(" and cont[-1] == ")":
        proc = "(%s)"
        cont = cont[1:-1]

    cont_list = map(lambda x: x.strip(), cont.split(","))
    old_order = range(len(cont_list))
    new_order = old_order

    if len(cont_list) > 2:
        print ", ".join(map(str, cont_list))
        print ", ".join(map(lambda x: "%-"+str(len(x))+"d", cont_list)) % tuple(old_order)
        new_order = snake.raw_input(prompt="--> ")
        if new_order: new_order = map(int, new_order.split(","))
    elif len(cont_list) == 2:
        new_order = [1, 0]

    new_cont_list = []
    for i in new_order:
        new_cont_list += [cont_list[i]]

    snake.set_register('"', proc % (", ".join(new_cont_list)))

function_map("ShowGoTo", show_goto)
function_map("RotateParentheses", rotate_parentheses)

