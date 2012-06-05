
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set ts=4
set shiftwidth=4
set nohlsearch
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set nohlsearch
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
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
set wmh=0
"set fc+=r
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
au BufNewFile,BufRead * exe "normal \<C-J>\<C-K>"

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



"hi Identifier     term=underline  ctermfg=white ctermbg=black
"hi Statement      term=bold  ctermfg=2 
"hi Special        term=bold  ctermfg=6 ctermbg=black

"set textwidth=72
"set wrap
set linebreak
set bs=2		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set noautoindent
set ts=4
set shiftwidth=4
set laststatus=2
set statusline=%<%f%=%(%h%m%r%=\ %l,%c%V\ %P%)
set ai
set si
set incsearch
set wmh=0
set nohlsearch

" key mapping
map <C-j> <C-W>j<C-W>_
map <C-k> <C-W>k<C-W>_


hi Folded cterm=bold ctermfg=red ctermbg=0
hi StatusLine term=bold cterm=bold ctermfg=yellow ctermbg=0

colorscheme default

