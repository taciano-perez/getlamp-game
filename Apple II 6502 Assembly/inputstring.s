; gets a line from keyboard and stores at address (BUFF)
; all characters are converted to uppercase. Max chars = 255.
; INPUT: BUFF
; OUTPUT: (BUFF)
; DESTROYS: registers x, a, y, flags: c, z
InputString		jsr GETLN
InpStrClear		txa					; x = string length
				tay
				lda #$00
				sta BUFFER,Y		; put EOF marker
				dey					; y-1 for proper indexing
InpStrC2		lda BUFF,Y
				jsr FixCase			; make uppercase
				sta BUFFER,Y		; put in new loc
				lda #$00
				sta BUFF,Y			; clear buffer
				dey
				cpy #$FF
				bne InpStrC2
InpStrDone		rts
;
; prints string on address (BUFF)
PrintBufString	ldy	#$00	; start at offset = 0
PrtBufStrLoop	lda BUFFER,Y	; load next character
				beq PrtBufStrExit	; if character = 00, finish
				jsr COUT	; print character
				iny			; increment offset
				bne PrtBufStrLoop	; loop until y <= 255
PrtBufStrExit	rts
;
; tests the accumulator for a lowercase character,
; in present, forces lowercase by addding $20
FixCase 	cmp #$E1 	; if "a" or more
			bcc FixCseEnd
			cmp #$FB 	; and if "z" or less
			bcs	FixCseEnd
			sec 		; then subtract $20 to
			sbc #$20 	; force upper case
FixCseEnd	rts 		; and return
BUFFER			ds	256		
				brk