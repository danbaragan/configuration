if exists("loaded_php_helper")
	finish
endif

let loaded_php_helper = 1

" Comment a PHP function
function Comment_PHP_function()
	" get line and line number
	let s:current_line = getline(".")
	let s:line_no = line(".") - 1

	" get function type, name and args
	let s:mx = '\([a-zA-Z0-9_* -]\+\)\s\+\([a-zA-Z0-9_*-]\+\)('
	let s:mx_args = '(\(.*\))'
	let s:mtch_args = matchstr(s:current_line, s:mx_args)
	let s:mtch = matchstr(s:current_line, s:mx)
	
	let s:ftype = substitute(s:mtch, s:mx, '\1', '')
	let s:fname = substitute(s:mtch, s:mx, '\2', '')
	let s:fargs = substitute(s:mtch_args, s:mx_args, '\1', '')

	let s:mx = '(\([a-zA-Z0-9_&=$ -]\+\)'
	let s:mx2 = '\([a-zA-Z0-9_&=$ -]\+\)'

	let s:smatch = 0

	let s:m = matchstr(s:current_line, s:mx, s:smatch)
	let s:pos = matchend(s:current_line, s:mx, s:smatch)

	let s:arg = substitute(s:m, s:mx, '\1', '')

	" begin comment
	call append(s:line_no, "/*!\\fn " . s:fname . "(" . s:fargs . ") {{{")
	call append(s:line_no + 1, " * \\brief")
	call append(s:line_no + 2, " *  ")
	call append(s:line_no + 3, " * <detailed>")
	call append(s:line_no + 4, " *  ")
	call append(s:line_no + 5, " * \\param " . s:arg . " <desc>")

	while (s:pos > 0)
		let s:m2 = matchstr(s:current_line, s:mx2, s:pos)
		let s:arg = substitute(s:m2, s:mx2, '\1', '')
		let s:pos = matchend(s:current_line, s:mx2, s:pos)
	
		" let s:arg = substitute(s:arg, '^[ ]\+', "", '')
		" let s:arg = substitute(s:arg, '[ ]\+$', "", '')
		let s:arg = Trim(s:arg)
	
		if s:arg != ""
			let s:line_no = line(".") - 1
			call append(s:line_no, " * \\param " . s:arg . " <desc>")
		endif
	endwhile

	" close comment
	let s:line_no = line(".") - 1
	call append(s:line_no, " * ")
	call append(s:line_no + 1, " * \\return <ret>")
	call append(s:line_no + 2, " */")

	" Close comment

	" Unfold to get a match
	call UnFold()

	let s:result_line = search("{", "W")
	if s:result_line != 0
		call Close_bracket(" /* }}} " . s:fname . " */")
	endif

endfunction


" Automatically insert a PHP function
fun! Insert_PHP_function()
	let s:fname = input("function name: ")
	let s:fargs = input("function args: ")
	
	let s:line_no = line(".")

	call append(s:line_no, "function " . s:fname . "(" . s:fargs . ") {")
	call append(s:line_no + 1, "")
	call append(s:line_no + 2, "}")
	call append(s:line_no + 3, "")
	call append(s:line_no + 4, "")
	
	exe "normal \<DOWN>"
	
	call Comment_PHP_function()
	
	exe "normal \<DOWN>"
	
endfun

" Mappings
map <Leader>o :call Insert_PHP_function()<CR><INS>
map <Leader>p :call Comment_PHP_function()<CR>

