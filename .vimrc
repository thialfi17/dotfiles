syntax on
set noic
set ruler
set hlsearch
set number
set backspace=indent,start
set wrap linebreak
set wildmode=longest,list
set wildmenu
set history=1000
set laststatus=2
set hidden
set showcmd
set autoindent
set cursorcolumn
set scrolloff=10
set viewdir=$HOME/.vim/view

set foldcolumn=1
set foldmethod=manual
set foldexpr=FoldExpr()
set foldtext=FoldText()
set foldenable

set splitright
set splitbelow

" Remove whitespace on current line
nnoremap <silent> <Leader>s m':.s/\s\+$//<CR>`'

" Save and load view (includes arglist)
nnoremap <silent> <Leader>vs :mkview<CR>:echom "Saved view"<CR>
nnoremap <silent> <Leader>vl :loadview<CR>:echom "Loaded view"<CR>

" cd to current file
nnoremap <silent> <Leader>tcd :tcd %:p:h<CR>
nnoremap <silent> <Leader>lcd :lcd %:p:h<CR>
nnoremap <silent> <Leader>cd :cd %:p:h<CR>

" set foldmethod to expr
nnoremap <silent> <Leader>fe :setlocal foldmethod=expr<CR>

" Make it so // searches for selected text
vnoremap // y/<C-R>"<CR>

" Open vimrc
nnoremap <silent> <F4> :tabe $MYVIMRC<CR>

" Arglist
nnoremap <F6> :args<CR>:argument 
nnoremap <F7> :tabs<CR>

" Column guidelines
nnoremap <silent> <Leader>go :set cc=113<CR>
nnoremap <silent> <Leader>gO :set cc=<CR>

" Highlight lines over certain length
augroup Settings
    autocmd!
    autocmd ColorScheme *
        \ highlight ExtraWhitespace cterm=bold ctermbg=1 guibg=Red |
        \ highlight ColorColumn ctermbg=0 |
        \ highlight Post80 ctermbg=0 |
        \ highlight OverLength ctermbg=darkgrey cterm=bold guibg=gray30
augroup END

set showbreak=\ 
set listchars=tab:..,trail:_,extends:>,precedes:<,nbsp:~
set list!

" augroup SaveView
"     autocmd!
"     autocmd BufWrite * mkview
"     autocmd BufWinEnter * silent! loadview
" augroup END


" augroup Whitespace
"     autocmd!
"     autocmd ColorScheme * highlight ExtraWhitespace cterm=bold ctermbg=1 guibg=Red
"     autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
"     autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"     autocmd InsertLeave * match ExtraWhitespace /\s\+$/
"     autocmd BufWinLeave * call clearmatches()
" augroup END

set tabstop=4
set shiftwidth=4
nnoremap <silent> <Leader>t :set expandtab!<CR>:echom "Toggled expand tab"<CR>
nnoremap <Leader>tlo :set showtabline=1<CR>
nnoremap <Leader>tlO :set showtabline=0<CR>

set undodir=~/.vim/undodir
set undofile

if &term == 'xterm'
        set t_SH=
endif

" Terminal escape
tnoremap <Esc><Esc> <C-\><C-n>

nnoremap <Leader><C-w>t <C-w>t

nnoremap <Leader>r yiw:%s/\V\<"\>//gc

noremap <C-j> :tabprevious<CR>
noremap <C-k> :tabnext<CR>
noremap <C-h> :prev<CR>
noremap <C-l> :next<CR>
noremap <C-p> :vne<CR>:setlocal buftype=nofile bufhidden=wipe noswapfile<CR>

nnoremap  mz0i//<Esc>`zll
nnoremap  mz0xx<Esc>`zhh
vnoremap  mz0I//<Esc>`zll

nnoremap <F5> :buffers<CR>:buffer<Space>
nnoremap <C-w>t :split<CR><C-w>T

nnoremap n nzz
nnoremap N Nzz

augroup Buffers
    autocmd!
    au BufEnter *.v :set syntax=verilog
    au FileType systemverilog,verilog :call Matches()
    au FileType systemverilog,verilog :set list
    au BufEnter *.sv,*.i :set syntax=systemverilog
    au BufWritePost $MYVIMRC nested source $MYVIMRC
    au BufNewFile,BufRead,BufEnter *.v,*.sv hi! link verilogLabel Statement
augroup END

command DiffOrig vert new | set bt=nofile bh=wipe | r # | 0d_ | diffthis
    \ | wincmd p | diffthis

set diffexpr=MyDiff()
function! MyDiff()
    let opt = ""
    if exists("g:diffignore") && g:diffignore != ""
        let opt = "-I " . g:diffignore . " "
    endif
    if &diffopt =~ "icase"
        let opt = opt . "-i "
    endif
    if &diffopt =~ "iwhite"
        let opt = opt . "-b "
    endif
    silent execute "!diff -a --binary " . opt . v:fname_in . " " .
        \ v:fname_new . " > " . v:fname_out
endfunction

colorscheme ron

" Stolen from: https://www.reddit.com/r/vim/comments/c18895/foldtext_align_number_of_lines_on_righthand/erdx7b2?utm_source=share&utm_medium=web2x
function! FoldText()
    " set the max number of nested fold levels + 1
    let fnum = 3
    " set the max number of digits in the number folded lines
    let nnum = 3

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

    " extract the folding text from the folding line
    let txta = substitute(line,'^[^a-zA-Z0-9\t ]* \(.*\)', '\1', '')
    let txta = substitute(txta,'^   \(.*\)','\1','')

    let txta = ' ' . txta . ' '
    let txtb = '[' . spac . lnum . ' lines ]'
    let fill = repeat(char, winwidth(0) - fnum - len(txta . txtb) - &foldcolumn - (&number ? &numberwidth : 0))

    return plus . dash . txta . fill . txtb
endfunction

function! FoldExpr()
    let current_line = getline(v:lnum)
    let previous_line = getline(v:lnum - 1)
    let previous2_line = getline(v:lnum - 2)
    let next_line = getline(v:lnum + 1)
    let next2_line = getline(v:lnum + 2)
    let next3_line = getline(v:lnum + 3)

    let header_comment = '^\s*\/\/-\+'
    let just_comment_line = '^\s*\/\/$'
    let comment_line = '^\s*\/\/'
    let comment_not_header = '^\s*\/\/\([^-].*\)\=$'
    let empty_line = '^\s*$'
    let not_empty_line = '^.\+$'
    let not_comment_line = '^\s*\w'

    if current_line =~ header_comment && next2_line =~ header_comment
        return ">2"
    elseif current_line =~ comment_not_header && previous_line =~ comment_not_header
        return "="
    elseif current_line =~ empty_line && next_line =~ just_comment_line && next2_line =~ comment_line
        return "s1"
    elseif current_line =~ empty_line && next_line =~ empty_line && next2_line =~ empty_line
        return "1"
    elseif current_line =~ not_empty_line && next_line =~ empty_line && next2_line =~ empty_line
        return "s1"
    elseif current_line =~ comment_not_header && next_line =~ comment_not_header && next2_line =~ comment_not_header
        return "a1"
    else
        return "="
    endif
endfunction

function! Matches()
    call clearmatches()
    let w:over_length_match = matchadd("Post80", '\%>113v.\+', -1)
    let w:extra_whitespace_match = matchadd("ExtraWhitespace", '\s\+$')
endfunction
