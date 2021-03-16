call plug#begin('~/.local/share/nvim/site/plugged')


" nerd tree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }


" colorscheme

"Plug 'wombat256mod.vim'
Plug 'nanotech/jellybeans.vim'
"Plug 'chriskempson/base16-vim'
"Plug 'w0ng/vim-hybrid'
"Plug 'majutsushi/tagbar'
"Plug 'embear/vim-localvimrc'
"Plug 'LucHermitte/lh-vim-lib'
"Plug 'LucHermitte/local_vimrc'
"Plug 'kshenoy/vim-signature'

" Cool symbols for files
Plug 'ryanoasis/vim-devicons'

Plug 'lervag/vimtex'

" Text alignment
Plug 'godlygeek/tabular'

"Plug 'vim-latex/vim-latex'

"
call plug#end()


" let g:python3_host_prog='C:/Users/Josh/Envs/neovim3/Scripts/python.exe'

" let g:python_host_prog='C:/Users/Josh/Envs/neovim/Scripts/python.exe'


"set encoding to utf8
if &encoding != 'utf-8'
    set encoding=utf-8              "Necessary to show Unicode glyphs
endif

" Enable syntax highlighting
syntax on

" Show number column
set number

" Allow hidden buffers
set hidden

" Number of rows from the edge of the screen before the screen scrolls
set scrolloff=10

" Show current position on status line
set ruler

" Highlight current cursor column
set cursorcolumn

" Highlight search
set hlsearch

" Set line wrapping
set wrap

" Set wildmenu
set wildmenu

" Set wildmenu modes. Complete longest first and list options, then cycle options.
set wildmode=longest:full,full

" Set command history
set history=1000

" Always show the status line
set laststatus=2

" Set backspace to only work back to start of line
set backspace=indent,start,eol

" Show partial commands on status line
set showcmd

" Automatically indent lines
set autoindent

" Setup folding
set foldcolumn=1
set foldmethod=manual
set foldenable

" Custom text on folds
set foldtext=FoldText()

" Default folds to being open
set foldlevelstart=99

" Automatically split right and below when opening new windows
set splitright
set splitbelow

" Set width of tab in spaces
set tabstop=4

" Set number of spaces to indent by
set shiftwidth=4

" Set expand tabs to spaces
set expandtab

" Show tabs and other characters
set list

" Set location of undofiles
set undodir=~/.vim/undo

" Store undo history to file
set undofile

" Enable mouse in all modes
set mouse=a

if has('nvim')
    set background=dark
    " Start broken lines with:
    set showbreak=\ ↳

    " Set which characters to show and their symbols
    set listchars=tab:→\ ,nbsp:⍽,trail:␣,extends:⇒,precedes:⇐
else
endif

" Fix issues due to icons and re-sourcing the vim config
if exists('g:loaded_webdevicons')
    tabdo call webdevicons#refresh()
endif

" Key bindings
nnoremap <Leader>w :w<CR>

nnoremap <silent> <Leader><Tab> :TagbarOpen fjc<CR>
noremap  <silent> <F9>          :TagbarToggle<CR>

"noremap <silent> <C-j> :tabprevious<CR>
"noremap <silent> <C-k> :tabnext<CR>
"noremap <silent> <C-h> :prev<CR>
"noremap <silent> <C-l> :next<CR>

" Make escaping from terminals easier
tnoremap <silent> <Esc><Esc> <C-\><C-n>

" Make searches automatically center the result
nnoremap <silent> n nzz
nnoremap <silent> N Nzz

"nnoremap <silent> <Leader>F :call FZFHomeCustom()<CR>
augroup Buffers
    autocmd!
    au BufEnter *.v   :set syntax=verilog
    au BufEnter *.tex :set filetype=tex

    "au BufNewFile,BufRead * if expand('%:t') !~ '\.' | set filetype=text | endif
    " These should be moved into ftplugins
    au FileType c,h  :call SetCOptions()
    au FileType tex  :call SetTexOptions()
    au FileType make :call SetMakeOptions()

    au FileType systemverilog,verilog :set list
    au FileType fzf :silent! tunmap <Esc><Esc>

    au BufEnter *.sv,*.i :set syntax=systemverilog
    " nested is needed to get the colorscheme stuff to load properly
    au BufWritePost init.vim nested source %
    au BufNewFile,BufRead,BufEnter *.v,*.sv hi! link verilogLabel Statement
augroup END

augroup Highlights
    autocmd!
    autocmd ColorScheme * highlight ExtraWhitespace cterm=bold ctermbg=1 guibg=Red
                      \ | highlight ColorColumn ctermbg=0
                      \ | highlight Post80 ctermbg=0
                      \ | highlight OverLength ctermbg=darkgrey cterm=bold guibg=khaki
                      \ | highlight FoldColumn ctermfg=110 guifg=#8fbfdc
                      \ | highlight LineNr ctermfg=215 guifg=#ffb964
                      \ | highlight CursorLineNr ctermfg=215 guifg=#ffb964 cterm=bold
augroup END

" FileType specific options
function! SetCOptions()
    setlocal foldmethod=syntax
    map <buffer><silent> <Leader>/ :s/^\(\s*\)/\1\/\//<Esc>:nohl<Esc>
    map <buffer><silent> <Leader>? :s/^\(\s*\)\/\//\1/<Esc>:nohl<Esc>
endfunction

function! SetTexOptions()
    setlocal tw=80
    setlocal colorcolumn=80
    setlocal spell
    map <buffer> <F5> :call CompileLatex()<CR>
endfunction

function! SetMakeOptions()
    nmap <buffer><silent> <Leader>/ :s/^\(\s*\)/\1#/<Esc>:nohl<Esc>
    nmap <buffer><silent> <Leader>? :s/^\(\s*\)#/\1/<Esc>:nohl<Esc>
endfunction

function! SetTextOptions()
    call clearmatches()

    setlocal spell

"    let w:over_length_match = matchadd("Post80", '\%>113v.\+', -1)
"    let w:extra_whitespace_match = matchadd("ExtraWhitespace", '\s\+$')
    let w:question_match = matchadd("Todo", '\S.*?')
    let w:todo_match = matchadd("Todo", 'TODO: .*')
    let w:exclamation_match = matchadd("Todo", '\S.*!')
    let w:unchecked_match = matchadd("diffRemoved", '\s* .*')
    let w:checked_match = matchadd("diffAdded", '\s* .*')

    imap <buffer><silent> :check: 
    imap <buffer><silent> :cross: 

    map <buffer><silent> <Leader>/ m`:s/^\(\s*\)\( \)\?/\1 /e<Esc>:nohl<Esc>``
    map <buffer><silent> <Leader>? m`:s/^\(\s*\)\( \)\?/\1 /e<Esc>:nohl<Esc>``

    call TextEnableCodeSnip('c','@begin c@', '@end c@', 'SpecialComment')
    call TextEnableCodeSnip('masm','@begin asm@', '@end asm@', 'SpecialComment')
    call TextEnableCodeSnip('java','@begin java@', '@end java@', 'SpecialComment')
    call TextEnableCodeSnip('json','@begin json@', '@end json@', 'SpecialComment')
endfunction

" vimtex

let g:vimtex_view_method="zathura"
" Slightly simpler compilation option that doesn't do continuous compilation
" let g:vimtex_compiler_method="latexrun"

function! CompileLatex()
    execute "!pdflatex -syntex=1 -interaction=nonstopmode " . g:tex_master
    "execute "new | 0read !pdflatex -syntex=1 -interaction=nonstopmode " . g:tex_master
    "setlocal buftype=nofile
    "setlocal bufhidden=delete
    "setlocal noswapfile
    "normal 20
endfunction

function! FoldText()
    " set the max number of nested fold levels + 1
    let fnum = 3
    " set the max number of digits in the number folded lines
    let nnum = 3
    let char = '-' "matchstr(&fillchars, 'fold:\zs.')
    let lnum = v:foldend - v:foldstart + 1
    let plus = repeat('+', v:foldlevel)
    let dash = repeat(char, 0)
    let spac = repeat(' ', nnum - len(lnum))
    let txta = ''
    let txtb = '[' . spac . lnum . ' lines ]'
    let fill = repeat(char, winwidth(0) - fnum - len(txta . txtb) - &foldcolumn - (&number ? &numberwidth : 0))
    return plus . dash . txta . fill . txtb
endfunction

function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
  let ft=toupper(a:filetype)
  let group='textGroup'.ft
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
  try
    execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif
  execute 'syntax region textSnip'.ft.'
  \ matchgroup='.a:textSnipHl.'
  \ keepend
  \ start="'.a:start.'" end="'.a:end.'"
  \ contains=@'.group
endfunction

colorscheme jellybeans
