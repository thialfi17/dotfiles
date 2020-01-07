call plug#begin('~/.local/share/nvim/site/plugged')

" nerd tree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }


" colorscheme
"Plug 'wombat256mod.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'chriskempson/base16-vim'
Plug 'w0ng/vim-hybrid'
Plug 'majutsushi/tagbar'
"Plug 'vim-latex/vim-latex'

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
set backspace=indent,start

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

" Set tags to include any .tags files
"   There's definitely a better way of doing this...
"   Apparently you can make .vimrc's for individual directories that can be
"   loaded automatically. Check exrc and also look into set path
set tags=./tags,tags,~/files/university/individual_project/nrf_SDK_16/components/tags,~/files/university/individual_project/nrf_SDK_16/config/nrf52840/tags,~/files/university/individual_project/nrf_SDK_16/external/tags,~/files/university/individual_project/nrf_SDK_16/external_tools/tags,~/files/university/individual_project/nrf_SDK_16/integration/tags,~/files/university/individual_project/nrf_SDK_16/modules/tags"

if has('nvim')
    set background=dark

    " Start broken lines with:
    set showbreak=\↳

    " Set which characters to show and their symbols
    set listchars=tab:..,trail:␣,extends:⇒,precedes:⇐,nbsp:·
else

endif

nnoremap <silent> <Leader><Tab> :TagbarOpen fjc<CR>
noremap <silent> <F9> :TagbarToggle<CR>

noremap <silent> <C-j> :tabprevious<CR>
noremap <silent> <C-k> :tabnext<CR>
noremap <silent> <C-h> :prev<CR>
noremap <silent> <C-l> :next<CR>

tnoremap <silent> <Esc><Esc> <C-\><C-n>

augroup Buffers
    autocmd!
    au BufEnter * :call clearmatches()
    au BufEnter *.v :set syntax=verilog
    au BufEnter *.c call SetCOptions()
    au BufEnter *.tex :set filetype=tex

    au FileType text :call Matches()
    au FileType systemverilog,verilog :set list
    au FileType tex map <buffer> <F5> :call CompileLatex()<CR>

    au BufEnter *.sv,*.i :set syntax=systemverilog
    " nested is needed to get the colorscheme stuff to load properly
    au BufWritePost *.vim nested source %
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
augroup END

function SetCOptions()
    setlocal foldmethod=syntax
    map <buffer><silent>  :s/^/\/\//<Esc>:nohl<Esc>
    map <buffer><silent> <M-C-_> :s/\/\///<Esc>:nohl<Esc>
endfunction

function! Matches()
    call clearmatches()
"    let w:over_length_match = matchadd("Post80", '\%>113v.\+', -1)
"    let w:extra_whitespace_match = matchadd("ExtraWhitespace", '\s\+$')
    let w:question_match = matchadd("Todo", '\S.*?')
    let w:todo_match = matchadd("Todo", 'TODO: .*')
endfunction

function CompileLatex()
    execute "!pdflatex -syntex=1 -interaction=nonstopmode " . g:tex_master
    "execute "new | 0read !pdflatex -syntex=1 -interaction=nonstopmode " . g:tex_master
    "setlocal buftype=nofile
    "setlocal bufhidden=delete
    "setlocal noswapfile
    "normal 20_
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

colorscheme jellybeans
