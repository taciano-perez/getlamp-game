; Get Lamp - 6502 Assembly version (Apple IIe)
; (c) Taciano Dreckmann Perez 2022
				org $4000
PTR				equ $06		; used by PrintString, InputString
COUT			equ	$FDF0	; used by PrintString
GETLN			equ $FD6F
BUFF			equ $200	; used by InputString
;
Entry			jsr PrintString
				asc "You are in an empty room"
				hex 8D00
				jsr PrintString
				asc "> "
				hex 00
				jsr InputString
				jsr PrintBufString
Done			rts
; prints a string located on the top of stack
				put	printstring.s
				put	inputstring.s