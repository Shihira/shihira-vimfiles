let s:program_path = $VIM . "/../../Program"
let s:clang_path = $VIM . "/../Clang"

let include_path = []
let include_path += [s:clang_path   . "/win32-include"]
let include_path += [s:clang_path   . "/std-include"]
let include_path += [s:program_path . "/tinyxml/include"]
let include_path += [s:program_path . "/curl/include"]
let include_path += [s:program_path . "/utility/include"]
let include_path += [s:program_path . "/shihira-eye/include"]
let include_path += [s:program_path . "/shihira-eye/build"]
let include_path += [s:program_path . "/shihira-htmlgen/include"]
let include_path += [s:program_path . "/shihira-htmlgen/build"]
let include_path += [s:program_path . "/qt/include"]
let include_path += [s:program_path . "/qt/include/QtGui"]
let include_path += [s:program_path . "/qt/include/QtCore"]
let include_path += [s:program_path . "/qt/include/QtNetwork"]

let g:clang_library_path = s:clang_path . "/bin"
