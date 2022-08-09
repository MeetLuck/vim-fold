"Safe Guard:"
"if exists("g:loaded_pythonindentfold")
"    finish
"endif
"
"let g:loaded_pythonindentfold = 1

augroup fold_python
  autocmd!
  autocmd FileType python
    set foldmethod=expr
    set foldexpr=GetPythonIndentFold(v:lnum)
    set foldcolumn=2 foldminlines=2
  autocmd TextChanged,InsertLeave <buffer> call GetPythonIndentFold(v:lnum)
augroup END

"                  \ setlocal foldtext=VimFoldText() |
"                  \ set foldcolumn=2 foldminlines=2
"setlocal foldmethod=expr
"setlocal foldexpr=GetPythonIndentFold(v:lnum)

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1

    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif

        let current += 1
    endwhile

    return -2
endfunction

function! GetPythonIndentFold(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    let thisindent = IndentLevel(a:lnum)
    let nextindent = IndentLevel( NextNonBlankLine(a:lnum) )
    "let nextindent = IndentLevel( nextnonblankline(a:lnum) )

    if nextindent == thisindent
        return thisindent
    elseif nextindent < thisindent
        return thisindent
    elseif nextindent > thisindent
        return '>' . nextindent
    endif
endfunction
