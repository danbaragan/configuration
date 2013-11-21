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
filetype off
"let g:pathogen_disabled = ['supertab']
"call pathogen#runtime_append_all_bundles()
call pathogen#incubate()
call pathogen#helptags()

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

	set autoindent                " always set autoindenting on

endif " has("autocmd")
set wmh=0
"set fc+=r
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



"hi Identifier     term=underline  ctermfg=white ctermbg=black
"hi Statement      term=bold  ctermfg=2
"hi Special        term=bold  ctermfg=6 ctermbg=black

"set textwidth=72
"set wrap
set linebreak
set bs=2                " allow backspacing over everything in insert mode
"set ai                 " always set autoindenting on
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set noautoindent
set ts=4
set shiftwidth=4
set softtabstop=4
set laststatus=2
set statusline=%<%f%=%(%h%m%r%=\ %{fugitive#statusline()}\ %l,%c%V\ %P%)
set noai
set si
set incsearch
set wmh=0
set hls

set tags+=./tags,tags,~/work/naaya/eggs/Zope2-2.12.26-py2.6-linux-x86_64.egg/tags,tags;~/work/naaya/

" key mapping
"map <C-j> <C-W>j<C-W>_
"map <C-k> <C-W>k<C-W>_
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

colorscheme elflord

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


"map <leader>h :GundoToggle<CR>
map <leader>d <Plug>TaskList
"let g:pyflakes_use_quickfix = 0
"au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1
"change supertab.vim:571 to 'doautocmd supertab_preview_closed User <supertab>'
augroup supertab_preview_closed
	autocmd User <supertab> winc _
augroup END

"map <leader>j :RopeGotoDefinition<CR>
"map <leader>r :RopeRename<CR>
map <F5> oimport IPython; IPython.embed() ### XXX BREAKPOINT<esc>
map <F6> oimport ipdb; ipdb.set_trace() ### XXX BREAKPOINT<esc>
map <F7> :PyLint<CR>
map <F8> :sign unplace *<CR>
map <F9> :TagbarToggle<CR>
let g:pymode_lint_write = 0
let g:pymode_syntax_space_errors = 1
let g:pymode_utils_whitespaces = 0 " do not remove unused whitespaces by default

map <leader>v :rightbelow vsplit 
"zpt file type
au BufRead,BufNewFile *.zpt setfiletype xhtml
