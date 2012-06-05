if exists("loaded_fold_helper")
	finish
endif

let loaded_fold_helper = 1

" Toggle Fold
function FoldToggle()
	exe 'silent! normal! za'.(foldlevel('.')?'':'l')
endfunction

" Unfold
function UnFold()
	exe 'silent! normal! za'
endfunction

" Fold
function Fold()
	exe 'silent! normal! zc'
endfunction

" Folding settings and mappings
set foldmethod=marker
nnoremap  <silent>  <space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<cr>
