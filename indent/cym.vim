" Vim indent file
" Language:         Cytosim Configuration File
" Maintainer:       Krishna Iyer V S
" Latest Revision:  07 August 2024
" Filenames:        *.cym *.cym.tpl
" Adapted from https://github.com/vim/vim/blob/master/runtime/indent/json.vim

if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal nosmartindent

setlocal indentexpr=GetCytosimIndent(v:lnum)
setlocal indentkeys=0{,0},0),0[,0],!^F,o,O,e

let b:undo_indent = "setl inde< indk< si<"

if exists("*GetCytosimIndent")
	finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Check if line 'lnum' has more opening brackets than closing ones.
function s:LineHasOpeningBrackets(lnum)
	let open_0 = 0
	let open_2 = 0
	let open_4 = 0
	let line = getline(a:lnum)
	let pos = match(line, '[][(){}]', 0)
	while pos != -1
		let idx = stridx('(){}[]', line[pos])
		if idx % 2 == 0
			let open_{idx} = open_{idx} + 1
		else
			let open_{idx - 1} = open_{idx - 1} - 1
		endif
		let pos = match(line, '[][(){}]', pos + 1)
	endwhile
	return (open_0 > 0) . (open_2 > 0) . (open_4 > 0)
endfunction

function GetCytosimIndent(...)
	" current linenumber
	let clnum = a:0 ? a:1 : v:lnum
	let vcol = col('.')

	let line = getline(clnum)
	let ind = -1

	" match and indent closing bracket on empty line
	let col = matchend(line, '^\s*[]}]')
	if col > 0
		call cursor(clnum, col)
		let bs = strpart('{}[]', stridx('}]', line[col - 1]) * 2, 2)

		let pairstart = escape(bs[0], '[')
		let pairend = escape(bs[1], ']')
		let pairline = searchpair(pairstart, '', pairend, 'bW')

		if pairline > 0
			let ind = indent(pairline)
		else
			let ind = virtcol('.') - 1
		endif

		return ind
	endif

	" get previous non blank line
	let lnum = prevnonblank(clnum -1)
	if lnum == 0
		return 0
	endif

	let line = getline(lnum)
	let ind = indent(lnum)

	if line =~ '[[({]'
		let counts = s:LineHasOpeningBrackets(lnum)
		if counts[0] == '1' || counts[1] == '1' || counts[2] == '1'
			return ind + shiftwidth()
		else
			call cursor(clnum, vcol)
		end
	endif
	return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
