if exists("loaded_text_helper")
	finish
endif

let loaded_text_helper = 1


" Trim
function Trim(text)
	let s:res = substitute(a:text, '^[ ]\+', "", '')
	let s:res = substitute(s:res, '[ ]\+$', "", '')

	return s:res
endfunction


" Modify the closing bracket appending the specified text
fun! Close_bracket(text)
	let regq= @"
	let mps = substitute(&mps,'\(.\).','\1','g')
 
	norm! vy
	if stridx(mps,@0) != -1
		let curline  = line('.')
		let curcol   = virtcol('.')
		norm! H
		let hline    = line('.')
		norm! ``
		norm! %
		let mtchline = line('.')
		let mtchcol  = virtcol('.')
		norm! %
		exe 'norm! '.hline.'Gzt'.curline.'G'.curcol."\<bar>"
		let s:lastline = getline(mtchline)
		call setline(mtchline, s:lastline . a:text)
	else
		match none
	endif
 
	let @"= regq
endfun
