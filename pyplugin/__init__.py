import os
import glob
import snake

modules = glob.glob(os.path.dirname(__file__)+"/*.py")
__all__ = [ os.path.basename(f)[:-3] for f in modules]

def function_map(fname, func):
    tag = snake.register_fn(lambda: func)
    snake.command("""
    function! %s(...)
        let g:function_map_arguments = a:000
        python %s(*list(vim.vars["function_map_arguments"]))
        unlet g:function_map_arguments
    endfunction
    """ % (fname, tag))

