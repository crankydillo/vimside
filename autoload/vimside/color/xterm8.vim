" ============================================================================
" xterm8.vim
"
" File:          xterm8.vim
" Summary:       XTerm 8 (part of Forms Library)
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" ============================================================================

" ------------------------------------------------------------ 
" Define Int_2_Name Dictionary: {{{2
" Refs:
"   Vim syntax doc
" 0       Black         0     0   0
" 1       DarkRed       139   0   0 
" 2       DarkGreen     0   100   0
" 3       DarkYellow    139 139   0 (yellow4)
" 4       DarkBlue      0     0 139
" 5       DarkMagenta   139   0 139  
" 6       DarkCyan      0   139 139
" 7       Gray, Grey    190 190 190
" ------------------------------------------------------------ 


let s:Int_2_Name = {
    \ '0': 'black',
    \ '1': 'DarkRed',
    \ '2': 'DarkReen',
    \ '3': 'yellow4',
    \ '4': 'DarkBlue',
    \ '5': 'DarkMagenta',
    \ '6': 'DarkCyan',
    \ '7': 'Grey'
    \ }

" ------------------------------------------------------------ 
" Define Int_2_RGB Dictionary: {{{2
" Refs:
"   Vim syntax doc
" ------------------------------------------------------------ 
let s:Int_2_RGB = {
    \ '0': '000000',
    \ '1': '8b0000',
    \ '2': '006400',
    \ '3': '8b8b00',
    \ '4': '00008b',
    \ '5': '8b008b',
    \ '6': '008b8b',
    \ '7': 'bebebe'
    \ }

" ------------------------------------------------------------ 
" Generate RGB_2_Int Dictionary: {{{2
" ------------------------------------------------------------ 
let s:RGB_2_Int = {}
for key in sort(keys(s:Int_2_RGB))
  let s:RGB_2_Int[s:Int_2_RGB[key]] = key
endfor

" xterm number to rgb string
let s:ColorTable = []
" TODO make into list of [r,g,b] values
let cnt = 0
while cnt < 8
  let rgb = s:Int_2_RGB[cnt]
  let r = rgb[0:1]
  let g = rgb[2:3]
  let b = rgb[4:5]
  let rn = str2nr(r, 16)
  let gn = str2nr(g, 16)
  let bn = str2nr(b, 16)
  call add(s:ColorTable, [rn,gn,bn])

  let cnt += 1
endwhile

if 0
let s:intensities = [
          \ str2nr("0x00",16),
          \ str2nr("0x5f",16),
          \ str2nr("0x87",16),
          \ str2nr("0xaf",16),
          \ str2nr("0xd7",16),
          \ str2nr("0xff",16)
          \ ]
endif


" ------------------------------------------------------------ 
" ConvertRGB_2_Int: {{{2
"  Converts an rgb String to a xterm 8 Number
"    Tried to make this fast.
"    Returns the xterm 8 Number
"  parameters:
"    rgb : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
function! vimside#color#xterm8#ConvertRGB_2_Int(rn, gn, bn)
"let start = reltime()
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

" call vimside#log("ConvertRGB_2_Int: in rn=". rn)
" call vimside#log("ConvertRGB_2_Int: in gn=". gn)
" call vimside#log("ConvertRGB_2_Int6: in bn=". bn)
"
  let best_match = -1
  let diff = 1000000
  let cnt = 0
  while cnt < 8
    let [rx,gx,bx] = s:ColorTable[cnt]
    let d = abs(rx-rn) + abs(gx-gn) + abs(bx-bn)

    " on equals, prefer gray to color
    if d < diff
      let diff = d
      let best_match = cnt
    endif

    let cnt += 1
  endwhile
  let n = best_match

" call vimside#log("ConvertRGB_2_Int:      time=". reltimestr(reltime(start)))
"call vimside#log("ConvertRGB_2_Int: n=". n)
  return n
endfunction

" ------------------------------------------------------------ 
" ConvertInt_2_RGB: {{{2
"  Converts an xterm 8 String or Number to an rgb String
"    Returns the rgb String
"  parameters:
"    nr : String or Number or xterm 8 value
"           value must be 0 <= value <= 15
" ------------------------------------------------------------ 
" return [0, errormsg] or [1, rgb]
function! vimside#color#xterm8#ConvertInt_2_RGB(nr)
  if (type(a:nr) == g:self#NUMBER_TYPE)
    return [1, s:Int_2_RGB[a:nr]]
  elseif (type(a:nr) == g:self#STRING_TYPE)
    return [1, s:Int_2_RGB[a:nr]]
  else
    return [0, "Bad number: " . string(a:nsstr)]
  endif
endfunction

" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
