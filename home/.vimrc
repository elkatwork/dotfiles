scriptencoding utf-8

"-----------------------------------------------------------------------
" terminal setup
"-----------------------------------------------------------------------

if (&term =~ "xterm" || &term =~ "screen" || &term =~ "rxvt-unicode") && (&termencoding == "")
	set termencoding=utf-8
endif

" http://superuser.com/questions/401926/how-to-get-shiftarrows-and-ctrlarrows-working-in-vim-in-tmux
if &term =~ '^screen'
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
endif

"-----------------------------------------------------------------------
" global settings
"-----------------------------------------------------------------------

" load bundles
source /home/thi/.vim/autoload/pathogen.vim
call pathogen#infect("/home/thi/.vim/bundle")
call pathogen#helptags()

" don't be compatible with vi
set nocompatible

" fast redrawing
set ttyfast
set lazyredraw

" enable a nice big viminfo file
set viminfo='1000,f1,:1000,/1000
set history=500

" make backspace delete lots of things
set backspace=indent,eol,start

" show us the command we're typing
set showcmd

" highlight matching parens
set showmatch

" search options: incremental search, highlight search
set hlsearch
set incsearch

" case insensitive
set ignorecase
set infercase
set smartcase

" show line numbers
set number

" highlight current line
set cursorline

" always show the statusbar
set laststatus=2

" show full tags when doing search completion
set showfulltag

" use hidden buffers
set hidden

" scrolling context
set scrolloff=6
set sidescrolloff=5

" wrap on these
set whichwrap+=<,>,[,]

" but by default do not wrap
set nowrap

" by default, go for an indent of 4 and do not expand tabs
set shiftwidth=4
set tabstop=4
set noexpandtab

" fold automatically on markers
set foldmethod=marker

" load nice colors
set t_Co=256
set background=dark
colorscheme solarized

" enable syntax highlighting
if has("syntax")
	syntax on
endif

" enable and reload filetype settings
if has("eval")
	filetype on
	filetype plugin on
	filetype indent on
endif

" enable modelines only on secure vim versions
if (v:version >= 604)
	set modeline modelines=10
else
	set nomodeline
endif

" Nice window title
set title
if has('title') && (has('gui_running') || &title)
	set titlestring=
	set titlestring+=%f\                     " file name
	set titlestring+=%h%m%r%w                " flags
	set titlestring+=\ -\ %{v:progname}      " program name
endif

" if possible, try to use a narrow number column.
if v:version >= 700
	try
		setlocal numberwidth=3
	catch
	endtry
endif

" show tabs and trailing whitespace visually
if (&termencoding == "utf-8") || has("gui_running")
	if v:version >= 700
		set list listchars=tab:»·,trail:·,extends:…,nbsp:‗
	else
		set list listchars=tab:»·,trail:·,extends:…
	endif
else
	if v:version >= 700
		set list listchars=tab:>-,trail:.,extends:>,nbsp:_
	else
		set list listchars=tab:>-,trail:.,extends:>
	endif
endif

"-----------------------------------------------------------------------
" final commands
"-----------------------------------------------------------------------

" some basic commands
augroup basics
	au!

	" turn of previous search results
	au VimEnter * nohls

	" always do a full syntax refresh
	au BufEnter * syntax sync fromstart

	" cd to buffer directory
	au BufEnter * execute ":silent! lcd " . expand("%:p:h")
augroup END

" restore cursor without mkview overhead (and bugs)
function! ResCur()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction

augroup resCur
	au!
	au BufWinEnter * call ResCur()
augroup END

" file type specific settings
augroup filetype_settings
	au BufRead,BufNewFile *.json set ft=javascript
	au BufRead,BufNewFile *.coffee set ft=coffee
	au BufRead,BufNewFile *.applescript set ft=applescript

	au FileType {css,scss} set ts=2 sw=2 et
	au FileType {coffee,javascript,json} set ts=2 sw=2 et
	au FileType {haml,html} set ts=2 sw=2 et
	au FileType {ruby,eruby,yaml} set ts=2 sw=2 et
	au FileType python set ts=4 sw=4 tw=79 et
augroup END

" personal leader key
let mapleader = "\\"

" GUI and colors
highlight PMenu gui=bold guibg=#CECECE guifg=#444444

if has("gui_running")
    set guioptions=egmrt
endif

" bash like completion
set wildmenu
set wildmode=full

" remember the git root of the current project
autocmd VimEnter,BufEnter * let b:git_root_dir = system("git rev-parse --show-toplevel 2>/dev/null")[:-2]

" ctrlp options
let g:ctrlp_max_height = 50
let g:ctrlp_working_path_mode = 2
let g:ctrlp_root_markers = ['.hg/']
let g:ctrlp_custom_ignore = { 'dir': '\.jhw-cache$\|\.git$\|\.hg$\|\.tags$', 'file': '\.class$\|\.jar$' }

" disable search hilight
noremap <silent> <leader>ns :silent :nohlsearch<cr>

" make ctrlp and dwm work together
function! DWMOpenFunc(action, line)
    if a:action == 'v' || a:action == 'h'
        let filename = fnameescape(fnamemodify(a:line, ':p'))
        call DWM_New()
        execute ":silent! lcd " . b:git_root_dir
        execute 'edit' filename
    else
        call call('ctrlp#acceptfile', [a:action, a:line])
    endif
endfunction

let g:ctrlp_open_func = { 'files': 'DWMOpenFunc' }


" git shortcuts
map <leader>gb :Gblame<cr>

" rails shortcuts
map <leader>rc :Rcontroller<cr>
map <leader>rh :Rhelper<cr>
map <leader>rj :Rjavascript<cr>
map <leader>rl :Rlayout<cr>
map <leader>rm :Rmodel<cr>
map <leader>rs :Rstylesheet<cr>
map <leader>rv :Rview<cr>

" relative line numbers
set rnu

" no auto changedir
au! basics BufEnter
au BufEnter * syntax sync fromstart

" no swap/backup files
set nobackup
set noswapfile

" pastetoggle - disable autoindent for pasting
set pastetoggle=<F2>

" force sudo write
cmap w!! w !sudo tee % >/dev/null

" fugitive shortcuts
noremap <Leader>gs :Gstatus<cr>
noremap <Leader>gc :Gcommit<cr>
noremap <Leader>ga :Gwrite<cr>
noremap <Leader>gl :Glog<cr>
noremap <Leader>gb :Gblame<cr>

" Bubble single lines
nmap <C-k> ddkP
nmap <C-j> ddp
" Bubble multiple lines
vmap <C-k> xkP`[V`]
vmap <c-j> xp`[V`]

" expand tabs in c/java-code
augroup filetype_settings
	au FileType {c,cpp,java} set ts=4 sw=4 tw=79 expandtab et
augroup END

" ctags settings
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<CR>
map <F5> :!/usr/local/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T
nnoremap <silent><C-]> g<C-]>

" specs in vim config
let g:ruby_conque_rspec_command='bundle exec rspec -cfs'

map <F6> :call RunRspecCurrentFileConque()<CR>
map <F7> :call RunRspecCurrentLineConque()<CR>
map <F8> :call RunRspecAllFilesConque()<CR>
let g:ruby_conque_window_height=20

" fancy powerline icons
let g:Powerline_symbols = 'fancy'

" paste debugger snippet
nnoremap <silent><Leader>ad Orequire 'ruby-debug'<CR>debugger<ESC>

" remove trailing whitespaces and convert tabs into spaces
noremap <silent> <Leader>w :set expandtab<CR>:retab<CR>:g/^\s*$/,/\S/-j<Bar>%s/\s\+$//<CR>

" turn on indentation highlighting by default
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=0

" highlight current line
set cursorline

" turn off line wrapping
set nowrap

" horizontal frame resizing shortcuts
nmap <c-l> <c-w><
nmap <c-h> <c-w>>

" syntastic
let g:syntastic_auto_loc_list=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

" taglist
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
let Tlist_Highlight_Tag_On_BufEnter = 0
let Tlist_Sort_Type = "name"

" ruby completion
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

" all remaining filetypes use syntaxcomplete
autocmd Filetype *
            \ if &omnifunc == "" |
            \   setlocal omnifunc=syntaxcomplete#Complete |
            \ endif

" delete fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" find next merge conflict
nmap <silent> ]n /<<<<<CR>

" tab switching
map  <silent> <C-Up> :tabprevious<cr>
imap <silent> <C-Up> <esc>:tabprevious<cr>
map  <silent> <C-Down> :tabnext<cr>
imap <silent> <C-Down> <esc>:tabnext<cr>

" git-grep function
if !exists('g:git_grep_command')
	let g:git_grep_command = 'git grep -n '
endif

function! s:GitGrep(terms)
	let expr = g:git_grep_command."'".a:terms."'"

	execute ":silent! lcd " . b:git_root_dir
	cgetexpr system(expr)
	execute ":silent! lcd " . expand("%:p:h")

	cwin
	echo 'Number of matches: ' . len(getqflist())
endfunction

function! s:GitGrepWord()
	call s:GitGrep(expand("<cword>"))
endfunction

function! s:GitGrepWordBoundaries()
	call s:GitGrep("\\b".expand("<cword>")."\\b")
endfunction

command! -nargs=0 GitGrepWordBoundaries :call s:GitGrepWordBoundaries()
command! -nargs=0 GitGrepWord :call s:GitGrepWord()
command! -nargs=+ GitGrep :call s:GitGrep(<q-args>)

" git grep for word under the cursor
nmap <silent> <leader>gw :GitGrepWordBoundaries<CR>
nmap <silent> <leader>gW :GitGrepWord<CR>

function! s:try(cmd, default)
  if exists(':' . a:cmd) && !v:count
    let tick = b:changedtick
    exe a:cmd
    if tick == b:changedtick
      execute 'normal! '.a:default
    endif
  else
    execute 'normal! '.v:count.a:default
  endif
endfunction

nnoremap <silent> gJ :<C-U>call <SID>try('SplitjoinJoin', 'gJ')<CR>
nnoremap <silent> J :<C-U>call <SID>try('SplitjoinJoin', 'J')<CR>
nnoremap <silent> gS :SplitjoinSplit<CR>
nnoremap <silent> S :<C-U>call <SID>try('SplitjoinSplit', 'S')<CR>
nnoremap <silent> r<CR> :<C-U>call <SID>try('SplitjoinSplit', "r\015")<CR>


" vim: set sw=4 ts=4 tw=72
