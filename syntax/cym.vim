" Vim syntax file
" Language:         Cytosim Configuration File
" Maintainer:       Krishna Iyer V S
" Latest Revision:  07 August 2024
" Filenames:        *.cym *.cym.tpl

if exists("b:current_syntax")
	finish
endif

syn keyword cymCommand set change new add delete move mark run read include cut report import export call repeat for restart
syn keyword cymObject hand couple single fiber solid aster space simul field nucleus sphere bead bundle fake event

syn match cymOperator "[=;,]"
syn match cymBracket "[{}()]"
syn match cymParameter "\w\+\s*=" contains=inParam, cymOperator
syn match inParam "\w\+" contained

" Regular int like number with - + or nothing in front
syn match cymNumber '\d\+'
syn match cymNumber '[-+]\d\+'

" Floating point number with decimal no E or e (+,-)
syn match cymNumber '\d\+\.\d*'
syn match cymNumber '[-+]\d\+\.\d*'

" Floating point like number with E and no decimal point (+,-)
syn match cymNumber '[-+]\=\d[[:digit:]]*[eE][\-+]\=\d\+'
syn match cymNumber '\d[[:digit:]]*[eE][\-+]\=\d\+'

" Floating point like number with E and decimal point (+,-)
syn match cymNumber '[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'
syn match cymNumber '\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'

" Match inf as a number
syn keyword cymNumber inf

" Use python-style highlighting for cym.tpl python blocks
syn include @cymPy syntax/python.vim
syn region cymPyBlock start="\[\[" end="\]\]" contains=@cymPy

" matlab-style comments: % or %{...}
syn match cymComment "%.*$"
syn region cymCommentBlock start="%{" end="}" fold
" C++-style comments: '//' or '/*...*/'
syn match cymComment "//.*$"
syn region cymCommentBlock start="/\*" end="\*/" fold

" title comments
syn match cymCommentTitle "%%.*$"

let b:current_syntax = "cym"

hi def link cymCommand      Function
hi def link cymObject       Type
hi def link inParam         Keyword
hi def link cymOperator     Operator
hi def link cymBracket      Operator
hi def link cymNumber       Number 
hi def link cymCommentBlock Comment
hi def link cymComment      Comment
hi def link cynCommentTitle vimCommentTitle
