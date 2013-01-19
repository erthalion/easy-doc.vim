" File: easy-doc.vim
" Summary: Generate documentation
" Author: erthalion <9erthalion6@gmail.com>
" Version: 0.1.0


function! PythonGoogleStyle()
    let l    = line('.')
    let i    = indent(l)
    let pre  = repeat(' ',i)
    let tab = repeat(' ', 4)
    let text = getline(l)
    let params   = matchstr(text,'([^)]*)')
    let paramPat = '\([=$a-zA-Z_0-9]\+\)[, ]*\(.*\)'
    let vars = []
    let m    = ' '
    let ml = matchlist(params,paramPat)
    
    let kwarguments = []
    let arguments = []

    while ml!=[]
        let [_,var;rest]= ml
        let expression = split(var,'\(=\)')
        if len(expression) == 2
            let kwarguments += [expression[0]]
        else
            if expression[0] != 'self'
                let arguments += [expression[0]]
            endif
        endif
        let ml = matchlist(rest,paramPat,0)
    endwhile
    
    let kwargComment = [pre.tab.'Kwargs:']
    for kw in kwarguments
        let kwargComment += [pre.tab.tab.kw.' (type):']
    endfor

    let argComment = [pre.tab.'Args:']
    for argValue in arguments
        let argComment += [pre.tab.tab.argValue.' (type):']
    endfor

    let retComment = [pre.tab.'Returns:']
    let retComment += [pre.tab.tab.'']

    let raiseComment = [pre.tab.'Raises:']
    let raiseComment += [pre.tab.tab.'']

    let comment = [pre.tab.'"""'] + argComment +kwargComment + retComment  + raiseComment + [pre.tab.'"""']
    call append(l,comment)
endfunction


function! CppDoxygen()
    let l    = line('.')
    let i    = indent(l)
    let pre  = repeat(' ',i)
    let tab = repeat(' ', 4)
    let text = getline(l)
    let params   = matchstr(text,'([^)]*)')
    let paramPat = '\([$a-zA-Z_0-9]\+\)[, ]*\(.*\)'
    let vars = []
    let m    = ' '
    let ml = matchlist(params,paramPat)
    
    let arguments = []

    while ml!=[]
        let [_,var;rest]= ml
        if var != 'this'
            let arguments += [var]
        endif
        let ml = matchlist(rest,paramPat,0)
    endwhile
    
    let mainComment = [pre.' * @brief ']

    let argComment = []
    for argValue in arguments
        let argComment += [pre.' * @param '.argValue]
    endfor

    let retComment = [pre.' * @return ']

    let raiseComment = [pre.' * @throw ']

    let comment = [pre.'/*'] + mainComment + argComment + retComment  + raiseComment + [pre.'*/']
    call append(l-1,comment)
endfunction
