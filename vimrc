set number
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set title

"" highlight whitespace at the end of a line
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

function StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction
