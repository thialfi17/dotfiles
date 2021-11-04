set nocompatible
filetype plugin on
runtime macros/matchit.vim
" Can't remember
"set packpath+=~/.vim/.pack/
syntax on
" Set noignorecase for searches
set noic
set ruler
set hlsearch
set number
set backspace=indent,start,eol
" Enable line wrapping and set it to wrap at the characters specified by 'breakat' no last character on screen
set wrap linebreak
set wildmenu
set wildmode=longest:full,full
set incsearch
set mouse=a
set history=1000
" Always show the statusline
set laststatus=2
set hidden
set showcmd
set autoindent
" Scroll before the end of the screen
set scrolloff=10

set foldcolumn=1
set foldmethod=manual
set foldenable

set splitright
set splitbelow

" No tabs and set indent to use 2 spaces by default
set et
set sts=2

set sw=2
" Highlight current column
set cursorcolumn

" Removes ":" from being considered part of a file name
" set isfname-=:
set isf-=:

" Don't wrap text on lines when they get too long
set tw=0

" Specify that my terminal only supports 16 colors
set t_Co=16

" Remove whitespace on current line
nnoremap <silent> <Leader>s m':.s/\s\+$//<CR>`'

" Save and load view (includes arglist)
set viewdir=$HOME/.vim/view
nnoremap <silent> <Leader>vs :mkview<CR>:echom "Saved view"<CR>
nnoremap <silent> <Leader>vl :loadview<CR>:echom "Loaded view"<CR>

" cd to current file in (t) tab (l) local window or globally
nnoremap <silent> <Leader>tcd :tcd %:p:h<CR>
nnoremap <silent> <Leader>lcd :lcd %:p:h<CR>
nnoremap <silent> <Leader>cd :cd %:p:h<CR>

" set foldmethod to expr
"nnoremap <silent> <Leader>fe :setlocal foldmethod=expr<CR>

" Make it so // searches for selected text
vnoremap // y/<C-R>"<CR>

" Remove highlighting from search
nnoremap <silent> <Leader>n :nohl<CR>

" Open vimrc
nnoremap <silent> <F4> :tabe $MYVIMRC<CR>

" Arglist
nnoremap <F6> :args<CR>:argument 
" Tablist
nnoremap <F7> :tabs<CR>:tabn 

" Column guidelines
nnoremap <silent> <Leader>go :set cc=113<CR>
nnoremap <silent> <Leader>gO :set cc=<CR>

" Highlight lines over certain length
augroup Settings
    autocmd!
    autocmd ColorScheme *    
        \ highlight LineNr ctermfg=8 |
        "\ highlight link verilogLabel Statement |
        \
        \ highlight ExtraWhitespace cterm=bold ctermbg=1 guibg=Red |
        \ highlight Comment cterm=bold ctermfg=6 |
        \ highlight ColorColumn ctermbg=0 |
        \ highlight Post80 ctermbg=0 |
        \ highlight OverLength ctermbg=darkgrey cterm=bold guibg=gray30
augroup END

" Characters to show in front of lines that have been wrapped
set showbreak====> 
set listchars=tab:..,trail:_,extends:>,precedes:<,nbsp:~
"set list


" Persistent undos
set undodir=~/.vim/undodir
set undofile

" Don't remember but something to do with cursor shape
"if &term == 'xterm'
"        set t_SH=
"endif

" Terminal escape
tnoremap <Esc><Esc> <C-\><C-n>

nnoremap <F5> :buffers<CR>:buffer<Space>

" Centers the screen when moving between search results
nnoremap <silent> n nzz
nnoremap <silent> N Nzz

augroup Buffers
    autocmd!
    au BufRead,BufNewFile *.svh,*.s,*.sv,*.i :set syntax=systemverilog
    " My custom filetypes
    au BufRead,BufNewFile *.grep :set filetype=grep
    au BufRead,BufNewFile *.rpt :set filetype=rpt
    " Automatically reload vimrc on save
    au BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END

command! DiffOrig vert new | set bt=nofile bh=wipe | r # | 0d_ | diffthis
    \ | wincmd p | diffthis

" Not sure what this does
" set diffexpr=MyDiff()
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
    execute "silent" "!diff -a --binary " . opt . v:fname_in . " " .
        \ v:fname_new . " > " . v:fname_out
endfunction

colorscheme elflord

" Opens a scratch buffer in the current window
function! OpenScratch()
  noswapfile hide enew
  setlocal buftype=nofile
  setlocal bufhidden=hide
endfunction

" Variable for storing the buffer ID of the scratch buffer used for command outputs
if !exists('g:run_buf_id')
  let g:run_buf_id = -1
endif

" Redirect the output of a shell command to a scratch buffer.
" Will create a buffer if needed and will open the buffer depending on the provided options
function! Redirect(cmd, opts)
  let windows = win_findbuf(a:opts.buf_id)
  let switched = v:false

  " Allows vim helpers to be used within the command like '%' for current file
  let cmd = expandcmd(a:cmd)

  for win_id in windows
    if win_id2win(win_id) " If window is in our tab switch to it
      let switched = win_gotoid(win_id)
      if switched
        break
      endif
    endif
  endfor

  if !switched
    let switched = v:true
    if a:opts.split
      vsplit " We haven't switched already which means that there isn't a window with the buffer open in this tab
    elseif a:opts.anytab
      if !len(windows)
        tab split " Buffer isn't open in any tabs so make a new tab
      else
        let _ = win_gotoid(windows[0]) " Go to buffer even tho it's in a different tab
      endif
    else
      let switched = v:false
    endif
  endif

  let buf = bufnr("%") " Used for switching back incase we didn't make a window so have to edit the buffer in the current window
  if !bufexists(a:opts.buf_id) " We've already generated the window the buffer will appear in so now make the buffer if it doesn't exist
    echom "Buffer not exists"
    call OpenScratch()
    let a:opts.buf_id = bufnr("%") " Doesn't actually update the external value in some circumstances
  endif

  execute 'silent' 'buffer' . a:opts.buf_id
  execute 'silent' "%delete"
  let job = job_start(cmd, {'out_io': 'buffer', 'out_buf': a:opts.buf_id, 'err_cb': 'Display', 'close_cb': 'EchoDone'})
  let jobi = job_info(job)
  echom "Started job: " . join(jobi.cmd, ' ') . " (" . jobi.process . ")"
  if !switched " Switch back if the editing was done in the current window
    "call win_execute(win_getid(), "buffer " . buf, v:true)
    execute 'silent' 'buffer' buf
  endif
  return a:opts.buf_id
endfunction

" Callback for converting a grep result (with -nH options) to a quickfix list
function GrepFilter(channel, msg)
  let parts = split(a:msg, ':')
  let filename = parts[0]
  let lnr = parts[1]
  let line = join(parts[2:-1], ':')
  call setqflist([{'filename':filename, 'lnum':lnr, 'text':line}], 'a')
endfunction

" Callback for displaying a message from a job to the user
function Display(channel, msg)
  echom a:msg
endfunction

" Echo that the job has finished
function EchoDone(channel)
  let job = ch_getjob(a:channel)
  let jobi = job_info(job)
  echom "Finished job: " . join(jobi.cmd, ' ') . " (" . jobi.process . ")"
endfunction

" Async wrapper for running a find/grep command
function Find(fopts, ...)
  "echo a:000
  if a:0 < 2
    return "Not enough arguments!"
  endif
  let dir = a:1
  let opts = a:000[1:-2]
  let grep = a:000[-1]

  echo 'find ' . dir . ' ' . a:fopts . ' ' . join(opts, ' ') . ' -exec grep -nIHE "' . grep . '" {} +'
  call setqflist([], 'r', { 'title': 'Finding: ' . grep , 'items': []})
  let job = job_start('find ' . dir . ' ' . a:fopts . ' ' . join(opts, ' ') . ' -exec grep -nIHE "' . grep . '" {} +', {"out_cb": 'GrepFilter', 'err_cb': 'Display'})
  copen
endfunction

" Run the 'run' script in the local directory asynchronously. Discards the output
function LocalRun()
  let job = job_start("./run", { 'close_cb': 'EchoDone' })
  let jobi = job_info(job)
  echom "Started job: " . join(jobi.cmd, ' ') . " (" . jobi.process . ")"
endfunction

" Execute the "run" script in the current dir
nnoremap <silent> <Leader>R :call LocalRun()<CR>

" Execute the "run" script in the current dir. and show output in scratch buffer
nnoremap <silent> <Leader>r :Run ./run<CR>

" Open a scratch buffer in the current window
command! OpenScratch call OpenScratch()
noremap <silent> <C-p> :call OpenScratch()<CR>

" Rename the current buffer (intened for use on scratch buffers)
command! -nargs=1 CallScratch execute "file [".<q-args>."]"

" Insert or delete the specified text at the start of the current visual selection
command! -nargs=1 -range I execute "<line1>,<line2>s/^/<args>/ | nohl"
command! -nargs=1 -range D execute "<line1>,<line2>s/^<args>// | nohl"

" Save and execute the current buffer
command! W w | ./%

" Run a shell command and show the output in a scratch buffer
command! -nargs=+ -complete=shellcmd Run  let g:run_buf_id = Redirect(  <q-args>  , { 'buf_id': g:run_buf_id, 'split': v:false, 'anytab': v:false})
command! -nargs=+ -complete=shellcmd RunS let g:run_buf_id = Redirect(  <q-args>  , { 'buf_id': g:run_buf_id, 'split': v:true,  'anytab': v:false})
command! -nargs=+ -complete=shellcmd RunT let g:run_buf_id = Redirect(  <q-args>  , { 'buf_id': g:run_buf_id, 'split': v:false, 'anytab': v:true })

" Combine find and grep to look for occurences of a pattern in specific locations/file types
command! -nargs=+ Findv call Find( '\( -path "*/ignore/*" \) -prune -o \( \( -iname "*.sv" -o -iname "*.v" \) -type f \)', <f-args> )
command! -nargs=+ Findc call Find( '\( -path "*/ignore/*" \) -prune -o \( \( -path "*/config/*" \) -type f \)', <f-args> )

" Count occurences of word
nmap <Leader>m m'yiw:<C-u>%s/\<<C-r>"\>//gn<CR>`'\n

" Edit file in the same dir
nnoremap <expr> <Leader>E ":e " . expand('%:h') . "/*"
