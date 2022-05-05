" Vim syntax file
    " Language:	JSON
    " Maintainer:	Eli Parra <eli@elzr.com> https://github.com/elzr/vim-json
    " Last Change:	2014-12-20 Load ftplugin/json.vim

" Reload the definition of g:vim_json_syntax_conceal
" see https://github.com/elzr/vim-json/issues/42
runtime! ftplugin/json.vim

if !exists("main_syntax")
    if exists("b:current_syntax")
        finish
    en
    let main_syntax = 'json'
en

hi def link jsonNoise			Noise
  syntax match   jsonNoise           /\v%(:|,)/


" Strings
" Separated into a match and region because a region by itself is always greedy
    syn match  jsonStringMatch /"\([^"]\|\\\"\)\+"\ze[[:blank:]\r\n]*[,}\]]/ contains=jsonString
             " 定义了但没有使用?
    syn region  jsonString oneline matchgroup=jsonQuote start=/"/  skip=/\\\\\|\\"/  end=/"/ concealends contains=jsonEscape contained

syn region  jsonStringSQError oneline  start=+'+  skip=+\\\\\|\\"+  end=+'+
    " JSON does not allow strings with single quotes

" JSON Keywords
" Separated into a match and region because a region by itself is always greedy
syn match  jsonKeywordMatch /"\([^"]\|\\\"\)\+"[[:blank:]\r\n]*\:/ contains=jsonKeyword

syn region  jsonKeyword matchgroup=jsonQuote start=/"/  end=/"\ze[[:blank:]\r\n]*\:/ concealends contains=jsonEscape contained

" Escape sequences
    syn match   jsonEscape    "\\["\\/bfnrt]" contained
    syn match   jsonEscape    "\\u\x\{4}" contained
    hi def link jsonEscape		Special

" Numbers
syn match   jsonNumber    "-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>\ze[[:blank:]\r\n]*[,}\]]"

if (!exists("g:vim_json_warnings") || g:vim_json_warnings==1)
    " Strings should always be enclosed with quotes.
    syn match   jsonNoQuotesError  "\<[[:alpha:]][[:alnum:]]*\>"
    syn match   jsonTripleQuotesError  /"""/

    " An integer part of 0 followed by other digits is not allowed.
    syn match   jsonNumError  "-\=\<0\d\.\d*\>"

    " Decimals smaller than one should begin with 0 (so .1 should be 0.1).
    syn match   jsonNumError  "\:\@<=[[:blank:]\r\n]*\zs\.\d\+"

    " No comments in JSON, see http://stackoverflow.com/questions/244777/can-i-comment-a-json-file
    syn match   jsonCommentError  "//.*"
    syn match   jsonCommentError  "\(/\*\)\|\(\*/\)"

    " No semicolons in JSON
    syn match   jsonSemicolonError  ";"

    " No trailing comma after the last element of arrays or objects
    syn match   jsonTrailingCommaError  ",\_s*[}\]]"

    " Watch out for missing commas between elements
    syn match   jsonMissingCommaError /\("\|\]\|\d\)\zs\_s\+\ze"/
    syn match   jsonMissingCommaError /\(\]\|\}\)\_s\+\ze"/ "arrays/objects as values
    if (expand('%:e') !=? 'jsonl')
        syn match   jsonMissingCommaError /}\_s\+\ze{/ "objects as elements in an array
    en
    syn match   jsonMissingCommaError /\(true\|false\)\_s\+\ze"/ "true/false as value
en


" Allowances for JSONP: function call at the beginning of the file,
" parenthesis and semicolon at the end.
" Function name validation based on
" http://stackoverflow.com/questions/2008279/validate-a-javascript-function-name/2008444#2008444
    syn match  jsonPadding "\%^[[:blank:]\r\n]*[_$[:alpha:]][_$[:alnum:]]*[[:blank:]\r\n]*("
    syn match  jsonPadding ");[[:blank:]\r\n]*\%$"

" Boolean
    syn match  jsonBoolean /\(true\|false\)\(\_s\+\ze"\)\@!/

" Null
    syn keyword  jsonNull      null

" Braces
syn region  jsonFold matchgroup=jsonBraces start="{" end=/}\(\_s\+\ze\("\|{\)\)\@!/ transparent fold
syn region  jsonFold matchgroup=jsonBraces start="\[" end=/]\(\_s\+\ze"\)\@!/ transparent fold

" Define the default highlighting.
if version >= 508 || !exists("did_json_syn_inits")
    hi def link jsonPadding		Operator
    hi def link jsonString		String
    hi def link jsonTest			Label
    hi def link jsonNumber		Number
    hi def link jsonBraces		Delimiter
    hi def link jsonNull			Function
    hi def link jsonBoolean		Boolean
    hi def link jsonKeyword		Label

    if (!exists("g:vim_json_warnings") || g:vim_json_warnings==1)
        hi def link jsonNumError					Error
        hi def link jsonCommentError				Error
        hi def link jsonSemicolonError			Error
        hi def link jsonTrailingCommaError		Error
        hi def link jsonMissingCommaError		Error
        hi def link jsonStringSQError				Error
        hi def link jsonNoQuotesError				Error
        hi def link jsonTripleQuotesError		Error
    en
    hi def link jsonQuote			Quote
en

let b:current_syntax = "json"
if main_syntax == 'json'
    unlet main_syntax  " why this?
en

