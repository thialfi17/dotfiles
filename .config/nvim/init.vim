call plug#begin('~/.local/share/nvim/site/plugged')


" nerd tree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }


" Add fzf fuzzy file finder
Plug '/usr/share/fzf'
Plug 'junegunn/fzf.vim'


" colorscheme

"Plug 'wombat256mod.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'chriskempson/base16-vim'
Plug 'w0ng/vim-hybrid'
"Plug 'majutsushi/tagbar'
Plug 'LucHermitte/lh-vim-lib'
Plug 'LucHermitte/local_vimrc'
Plug 'kshenoy/vim-signature'

" Cool symbols for files
Plug 'ryanoasis/vim-devicons'

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

if has('nvim')
    set background=dark
    " Start broken lines with:
    set showbreak=\ ↳

    " Set which characters to show and their symbols
    set listchars=tab:→\ ,nbsp:⍽,trail:␣,extends:⇒,precedes:⇐
else
endif

" Key bindings
nnoremap <Space> :
cnoremap ; <CR>
nnoremap <Leader>w :w<CR>

nnoremap <silent> <Leader><Tab> :TagbarOpen fjc<CR>
noremap  <silent> <F9>          :TagbarToggle<CR>

noremap <silent> <C-j> :tabprevious<CR>
noremap <silent> <C-k> :tabnext<CR>
noremap <silent> <C-h> :prev<CR>
noremap <silent> <C-l> :next<CR>

" Make escaping from terminals easier
tnoremap <silent> <Esc><Esc> <C-\><C-n>

" Shortcut for FZF
nnoremap <silent> <Leader>f :FZF<CR>
nnoremap <silent> <Leader>g :GitFiles<CR>
nnoremap <silent> <Leader>F :FZF ~<CR>
nnoremap <silent> <Leader>t :BTags<CR>
nnoremap <silent> <Leader>T :Tags<CR>
nnoremap <silent> <Leader>l :BLines<CR>
nnoremap <silent> <Leader>L :Lines<CR>

"nnoremap <silent> <Leader>F :call FZFHomeCustom()<CR>
augroup Buffers
    autocmd!
    au BufEnter *     :call clearmatches()
    au BufEnter *.v   :set syntax=verilog
    au BufEnter *.tex :set filetype=tex

    au FileType c    call SetCOptions()
    au FileType tex  call SetTexOptions()
    au FileType text call Matches()

    au FileType systemverilog,verilog :set list
    au FileType fzf :silent! tunmap <Esc><Esc>

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



" FileType specific options
function! SetCOptions()
    setlocal foldmethod=syntax
    map <buffer><silent> <Leader>/ :s/^/\/\//<Esc>:nohl<Esc>
    map <buffer><silent> <Leader>? :s/\/\///<Esc>:nohl<Esc>
endfunction

function! SetTexOptions()
    setlocal tw=80
    setlocal colorcolumn=80
    setlocal spell
    map <buffer> <F5> :call CompileLatex()<CR>
endfunction

" FZF Options

" Reverse the layout to make the FZF list top-down
let $FZF_DEFAULT_OPTS='--layout=reverse'

" Change default command to ag
let $FZF_DEFAULT_COMMAND='ag --hidden --ignore .git/ -U -g ""'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
" let g:fzf_commands_expect = 'alt-enter,ctrl-x'
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --no-ignore-vcs --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options':['--bind','ctrl-d:preview-page-down,ctrl-u:preview-page-up']}), <bang>0)

command! -bang -nargs=* AG call AgFzf(<q-args>, <bang>0)
command! -bang -nargs=* Ag
  \ call fzf#vim#grep(
  \   'ag -U --hidden --ignore .git/ -g ""', 1,
  \   fzf#vim#with_preview({'options':['--bind','ctrl-d:preview-page-down,ctrl-u:preview-page-up'], 'dir':<q-args>}), <bang>0)

" Using floating windows of Neovim to start fzf
if has('nvim')
    let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'

    function! FloatingFZF()
        let width  = float2nr(&columns * 0.8)
        let height = float2nr(&lines * 0.9)
        let opts   = { 'relative' : 'editor',
                     \ 'row'      : ( &lines   - height ) / 2,
                     \ 'col'      : ( &columns -  width ) / 2,
                     \ 'width'    : width,
                     \ 'height'   : height }

        let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)

        " Override the normal floating window highlighting with the ColorColumn
        " group
        call setwinvar(win, '&winhighlight', 'NormalFloat:ColorColumn')
    endfunction

    " Using the custom window creation function
    let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif

function! AgFzf(dir, fullscreen)
    let command_fmt = 'ag -U --hidden --ignore .git/ -g %s || true'
    let initial_command = 'ag -U --hidden --ignore .git/ -g "" || true'
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--bind', 'change:reload:'.reload_command, '--bind','ctrl-d:preview-page-down,ctrl-u:preview-page-up'], 'dir':a:dir}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

function! RipgrepFzf(dir, fullscreen)
    let command_fmt = 'rg --no-ignore-vcs --column --line-number --no-heading --color=always --smart-case --iglob "!.git/" %s || true'
    let initial_command = 'rg --no-ignore-vcs --column --line-number --no-heading --color=always --smart-case --iglob "!.git/" || true'
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--bind', 'change:reload:'.reload_command, '--bind','ctrl-d:preview-page-down,ctrl-u:preview-page-up'], 'dir':a:dir}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

function! FZFHomeCustom()
    call fzf#run(fzf#wrap({
        'source'  : 'ag -U --ignore .git/ --ignore packages -g ""',
        'dir'     : '~',
        'options' : ['--ansi','--multi','--nth','2..,..','--tiebreak=index','--prompt','~/']
    }))
endfunction

function! FZFWithDevIcons(options)
    let l:fzf_files_options = [' -m --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up --preview "',
        fzf#shellescape("/home/josh/.local/share/nvim/site/plugged/fzf.vim/bin/preview.sh").' {2..}"']

    function! s:files(opts)
        echom a:opts['source'] . " " . a:opts['dir']
        let l:files = split(system(a:opts['source'] . " " . a:opts['dir']), '\n')
        return s:prepend_icon(l:files)
    endfunction

    function! s:prepend_icon(candidates)
        let result = []
        for candidate in a:candidates
            let filename = fnamemodify(candidate, ':p:t')
            let icon = WebDevIconsGetFileTypeSymbol(filename, isdirectory(filename))
            call add(result, printf("%s %s", icon, fnamemodify(copy(candidate), ":~:.")))
        endfor
        return result
    endfunction

    function! s:edit_file(items)
        let items = a:items
        let i     = 1
        let ln    = len(items)

        while i < ln
            let item      = items[i]
            let parts     = split(item, ' ')
            let file_path = get(parts, 1, '')
            let items[i]  = file_path
            let i        += 1
        endwhile

        call s:Sink(items)
    endfunction

    let opts           = fzf#wrap(a:options)
    let opts.source    = <sid>files(opts)
    let s:Sink         = opts['sink*']
    let opts['sink*']  = function('s:edit_file')
    let opts.options  .= join(l:fzf_files_options)

    call fzf#run(opts)
endfunction

function! Matches()
    call clearmatches()

    "    let w:over_length_match = matchadd("Post80", '\%>113v.\+', -1)

    "    let w:extra_whitespace_match = matchadd("ExtraWhitespace", '\s\+$')
    let w:question_match = matchadd("Todo", '\S.*?')
    let w:todo_match = matchadd("Todo", 'TODO: .*')
endfunction

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

colorscheme jellybeans
