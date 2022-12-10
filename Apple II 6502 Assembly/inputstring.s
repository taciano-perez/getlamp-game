; gets keyboard input and stores at address pointed by PTR
InputString		ldx #$00
				jsr GETLN
InpStrClear		txa				; x = string length
				tay
				lda #$00
				sta BUFFER,Y		; put EOF marker
				dey					; y-1 for proper indexing
InpStrC2		lda BUFF,Y
				sta BUFFER,Y		; put in new loc
				lda #$00
				sta BUFF,Y			; clear buffer
				dey
				cpy #$FF
				bne InpStrC2
InpStrDone		rts
; prints string on address set on PTR
PrintBufString	ldy	#$00	; start at offset = 0
PrtBufStrLoop	lda BUFFER,Y	; load next character
				beq PrtBufStrExit	; if character = 00, finish
				jsr COUT	; print character
				iny			; increment offset
				bne PrtBufStrLoop	; loop until y <= 255
PrtBufStrExit	rts
; data
BUFFER			ds	256
EoF				brk