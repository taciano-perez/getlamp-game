; common memory addresses used by all modules
; memory addresses
PTR				equ $06		; used by printstring, location
PTR1			equ $FA		; used by cmpstring, location
PTR2			equ $FC		; used by cmpstring, location
PTR3			equ $FE		; used by cmpstring
BUFF			equ $200	; used by inputstring, cmdgo
; monitor hooks
COUT			equ	$FDF0	; used by printstring
GETLN			equ $FD6F	; used by inputstring
PRBYTE			equ $FDDA	; debug
SETVID			equ $FE93	; Set port 0 (screen) for output.
SETKBD			equ $FE89	; Set port 0 (keyboard) for input.
PRDBI			equ $BE00	; ProDOS BASIC Interpreter (BI)
