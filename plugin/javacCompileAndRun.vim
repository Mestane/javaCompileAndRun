function! GetProjectRoot()

    let currentFile = expand('%:p')
    let parts = split(currentFile, '/')
    let index = index(parts, 'src')
    if index >= 0
        let projectRoot = join(parts[:index], '/')
        return projectRoot
    else
        return ''
    endif
endfunction

function! JavacCompileAndRun()
    let projectRoot = GetProjectRoot()
    if projectRoot == ''
        echo "Project root not found."
        return
    endif

    let packageName = substitute(expand('%:p:h:s?' . projectRoot . '/??'), '/', '.', 'g')
    let packageName = substitute(packageName, '^\.', '', '')

"    Find all .java file in your Project folder and compile
    let compileCommand = 'javac -d out $(find . -name \*.java)'
"    Run current java file 
    let runCommand = 'java -cp out ' . packageName . '.' . expand('%:t:r')
    let output = system(compileCommand . ' && ' . runCommand)

    below new
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    call append(0, split(output, "\n"))
    setlocal statusline=Output
    resize 15
endfunction
