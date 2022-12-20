" An example for a vimrc file.
"
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last change:  2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"           for OpenVMS:  sys$login:.vimrc
set encoding=utf-8
set fileencoding=utf-8

filetype off
let g:pathogen_disabled = ['jedi-vim']
"call pathogen#runtime_append_all_bundles()
call pathogen#infect('bundle/{}')
call pathogen#helptags()
syntax on
filetype plugin indent on

" When started as 'evim', evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
	set nobackup          " do not keep a backup file, use versions instead
else
	set backup            " keep a backup file
endif
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hls
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=120

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
					\ if line("'\"") > 0 && line("'\"") <= line("$") |
					\   exe "normal g`\"" |
					\ endif

	augroup END

else

	set autoindent                " always set autoindenting on

endif " has("autocmd")
set wmh=0
map <space> za
map <C-J> <C-W>j<C-W>_
map <C-Down> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-Up> <C-W>k<C-W>_
map! <C-J> <esc><C-W>j<C-W>_
map! <C-Down> <esc><C-W>j<C-W>_
map! <C-K> <esc><C-W>k<C-W>_
map! <C-Up> <esc><C-W>k<C-W>_
au BufNewFile,BufRead * exe "normal \<C-J>\<C-K>"

map h :tabp<ENTER>
map l :tabn<ENTER>
map j :tabp<ENTER>
map k :tabn<ENTER>
map <C-H> <C-W>h
map <C-L> <C-W>l

" Folding
set foldmethod=marker
fun! ToggleFold()
	if foldlevel('.') == 0
		normal! l
	else
		if foldclosed('.') < 0
			. foldclose
		else
			. foldopen
		endif
	endif
	" Clear status line
	echo
endfun

set textwidth=120
set linebreak
set bs=2                " allow backspacing over everything in insert mode
set noautoindent
set ts=4
set shiftwidth=4
set softtabstop=4
set expandtab
set laststatus=2
set statusline=%<%f%=%(%h%m%r%=\ %{fugitive#statusline()}\ %l,%c%V\ %P%)
set noai
set si
set incsearch
set wmh=0
set hls
"set mouse=a

set tags+=./tags,tags,~/work/naaya/eggs/Zope2-2.12.26-py2.6-linux-x86_64.egg/tags,tags;~/work/naaya/

" key mapping
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>

colorscheme slate
let &colorcolumn=join(range(121,125),",")
highlight ColorColumn ctermbg=237 guibg=#2c2d27
highlight MatchParen  ctermbg=red

"Bracket matching color
hi MatchParen cterm=bold ctermbg=none ctermfg=yellow

"hi Folded cterm=bold ctermfg=red ctermbg=0
"hi StatusLine term=bold cterm=bold ctermfg=yellow ctermbg=0
hi Comment	ctermfg=lightblue
hi Directory	ctermfg=lightblue
"hi Search		guifg=#90fff0 guibg=#2050d0						ctermfg=white ctermbg=green
"hi IncSearch	guifg=#b0ffff guibg=#2050d0							ctermfg=green ctermbg=white
let g:MultipleSearchMaxColors=5
let g:MultipleSearchColorSequence="Red,Green,Blue,Cyan,Magenta"
let g:MultipleSearchTextColorSequence="White,Black,White,Black,Black"

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

map <F5> oimport IPython; IPython.embed() ### XXX BREAKPOINT<esc>
map <F6> oimport ipdb; ipdb.set_trace() ### XXX BREAKPOINT<esc>
map <F7> :PymodeLint<CR>
map <F8> :sign unplace *<CR>
map <F9> :TagbarToggle<CR>

" Syntastic
let g:syntastic_python_python_exec='/usr/local/bin/python3'
" use this if syntastic fails to handle some things in python3, like f strings
let g:syntastic_mode_map = {"mode": "active", "passive_filetypes": ["python"] }

map <leader>v :rightbelow vsplit 
au BufRead * normal zR
" find a way to put this in ftplugin specific files with no au trigger
au BufRead *.py normal zM

set fillchars="fold: "
let g:pymode_run_key = '<F3>'

"let g:pyflakes_use_quickfix = 0
"au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1
let g:pymode_rope_complete_on_dot = 0
set completeopt-=preview
autocmd CursorMovedI * if pumvisible() == 0|pclose|winc _|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|winc _|endif

"change cursor in insert mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
