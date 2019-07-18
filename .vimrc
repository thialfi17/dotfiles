syntax on

"
" Set options
"

set number
set backspace=indent,eol,start
set path=.,,**
set hidden
set laststatus=2
set noic
set scrolloff=3

" Display column for indicating which lines are part of a fold
set foldcolumn=1

" Display whitespace characters
set list
" Characters to use
set listchars=tab:..,trail:_
" Character to use on wrapped lines
set showbreak=>\ 

" Set undo directory
set undodir=$HOME/.vim/undodir
" Store undos in a file making them persistent
set undofile

" Tab Stop
set tabstop=4
" Shift Width
set shiftwidth=4

" Set autocomplete in command menu
set wildmenu
set wildmode=longest,list

" Show partially typed commands
set showcmd

" Smart indentation
set autoindent

" Prevent vim from changing options like the current working directory when
" opening files with a saved view
set viewoptions=folds
set viewdir=$HOME/.vim/view

" Custom fold text function to always display the most useful first line
set foldtext=FoldText()

"
" Key mappings
"

" Toggle expand tab
nnoremap <silent> <Leader>t :set expandtab!<CR>

" Remove whitespace on current line
nnoremap <silent> <Leader>s m':.s/\s\+$//<CR>`'


" Various tab related keyboard shortcuts
nnoremap tj <Esc>:tabprevious<CR>
nnoremap tk <Esc>:tabnext<CR>
nnoremap td <Esc>:tabclose<CR>
nnoremap th <Esc>:tabfirst<CR>
nnoremap tl <Esc>:tablast<CR>
nnoremap tn <Esc>:tabnew<Space>
nnoremap tt <Esc>:tabedit<Space>
nnoremap tm <Esc>:tabm<Space>

" Bind F5 to save file if modified and execute python script in a buffer.
nnoremap <silent> <F5> :call SaveAndExecutePython()<CR>
vnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>

"
" Autocommands
"

augroup ReloadVimRC
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

augroup SaveView
    autocmd!
    autocmd BufWrite * mkview
    autocmd BufWinEnter * silent! loadview
augroup END

"
" Functions
"

function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
endfunction

" Stolen from: https://www.reddit.com/r/vim/comments/c18895/foldtext_align_number_of_lines_on_righthand/erdx7b2?utm_source=share&utm_medium=web2x
function! FoldText()
    " set the max number of nested fold levels + 1
    let fnum = 3
    " set the max number of digits in the number folded lines
    let nnum = 4

    let char = matchstr(&fillchars, 'fold:\zs.')
    let lnum = v:foldend - v:foldstart + 1
    let plus = repeat('+', fnum - v:foldlevel + 1)
    let dash = repeat(char, v:foldlevel - 1)
    let spac = repeat(' ', nnum - len(lnum))

    let line = getline(v:foldstart)
    let matches = matchstr(line, '[0-9a-zA-Z]')
    let offset = 1

    while matches == ''
        let line = getline(v:foldstart+offset)
        let matches = matchstr(line, '[0-9a-zA-Z]')
        let offset = offset + 1
    endwhile

    echo line

    " extract the folding text from the folding line
    let txta = substitute(line,'^[^a-zA-Z0-9\t ]* \(.*\)', '\1', '')
    let txta = substitute(txta,'^   \(.*\)','\1','')

    let txta = ' ' . txta . ' '
    let txtb = '[' . spac . lnum . ' lines]'
    let fill = repeat(char, winwidth(0) - fnum - len(txta . txtb) - &foldcolumn - (&number ? &numberwidth : 0))

    return plus . dash . txta . fill . txtb
endfunction
