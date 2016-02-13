shihira-vimfiles
==========================

USAGE
-----------

1. Clone this repo into directory ~/.vim. Note that if your directory is not
   ~/.vim, it is not guaranteed that the configuration could work well.
2. Create two rc-files and make sure that python is usable for vim:

        echo source ~/.vim/_vimrc > ~/.vimrc
        echo import sys > ~/.vimrc.py
        echo "sys.path.append('$HOME/.vim')" >> ~/.vimrc.py
        echo import _vimrc > ~/.vimrc.py


3. Then run `:PlugInstall` to pull all plugins from github and install.
4. Follow <http://valloric.github.io/YouCompleteMe/> to build and install YCM.
5. Happy viming!

FEATURES
------------

1. Typegame plugin `typegame.vim`. See the source for details.
2. F9 to compile with custom command or built-in command (with custom flags attached).
3. Using Plug to manager plugins.

