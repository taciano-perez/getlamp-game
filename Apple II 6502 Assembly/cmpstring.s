; string comparison routines
;
; compares two strings (up to 255 characters)
; INPUT: PTR1 (string1), PTR2 (string2)
; OUTPUT:  zero flag is set if the strings are equal, and cleared otherwise
; DESTROYS: registers a, y; flags: z
CompareStrings	ldy	#$00		 ; start at offset = 0
CmpStrLoop		lda (PTR1),Y	 ; load next character
				beq CmpStrDone	 ; if character = 00, return true (zero flag on)
				cmp (PTR2),Y 	 ; compare with equivalent char in string2
				bne CmpStrDone	 ; return false (zero flag off)
				iny				 ; increment offset
				bne CmpStrLoop	 ; loop until y <= 255
CmpStrDone		rts
;
; compares the n left characters of two strings (up to 255 characters)
; disregarding case of string1
; INPUT: PTR1 (string1), PTR2 (string2), PTR (length)
; OUTPUT:  zero flag is set if the substrings are equal, and cleared otherwise
; DESTROYS: registers a, y; flags: z
CmpStrLeft		ldy	#$00		  ; start at offset = 0
CmpStrLftLp		lda (PTR1),Y	  ; load next character
				beq CmpStrLftDone ; if character = 00, return true (zero flag on)
				cpy PTR
				beq CmpStrLftDone ; if offset = len, return true (zero flag on)
				cmp (PTR2),Y 	  ; compare with equivalent char in string2
				bne CmpStrLftDone ; return false (zero flag off)
				iny				  ; increment offset
				bne CmpStrLftLp	  ; loop until y <= 255
CmpStrLftDone	rts
;
; compares the n right characters of two strings (up to 255 characters)
; INPUT: PTR1 (string1), PTR2 (string2), PTR (length)
; OUTPUT:  zero flag is set if the substrings are equal, and cleared otherwise
; DESTROYS: registers a, x, y; flags: z; addresses: PTR1, PTR2, PTR3
CmpStrRight		lda PTR1		; PTR3 = PTR1 (LO)
				sta PTR3
				lda PTR1+1		; PTR3 = PTR1 (HI)
				sta PTR3+1
				jsr StrLen
				cmp PTR
				bcc CmpStrRgtDone ; if len < PTR, exit
				tax				; x = string1.len
				dex				; decrement
				dex				; twice
				txa			    ; transfer character offset to accumulator
				adc PTR1		; add offset to PTR1
				sta PTR1		; new PTR1 (LO)
				lda PTR1+1	
				adc #$00	    ; add offset to PTR1 (HI), in case carry flag is set
				sta PTR1+1
				lda PTR2		; PTR3 = PTR2 (LO)
				sta PTR3
				lda PTR2+1		; PTR3 = PTR2 (HI)
				sta PTR3+1
				jsr StrLen
				cmp PTR
				bcc CmpStrRgtDone ; if len < PTR, exit
				tay				; y = string2.len
				dey				; decrement twice
				dey
				tya				; transfer character offset to accumulator
				adc PTR2		; add offset to PTR2
				sta PTR2		; new PTR2 (LO)
				lda PTR2+1	
				adc #$00	 	; add offset to PTR2 (HI), in case carry flag is set
				sta PTR2+1
				lda #$00
				sta	PTR3		; PTR3 = offset 0
CmpStrRgtLp		lda PTR3
				cmp PTR			; if offset == len,
				beq SetZeroFlag ; return true (zero flag on)
				lda (PTR1)
				jsr FixCase
				cmp (PTR2) 	  	; compare with equivalent char in string1
				bne CmpStrRgtDone ; return false (zero flag off)
				dec PTR1
				dec PTR2
				inc PTR3		  ; increase offset counter (PTR3)
				bne CmpStrRgtLp	  ; loop until y <= 255
CmpStrRgtDone	rts
SetZeroFlag		lda #$00
				jmp CmpStrRgtDone
;
; returns the length of a null-terminated string (up to 255 chars)
; INPUT: PTR3 (string)
; OUTPUT: accumulator contains the string length
; DESTROYS: registers a, y
StrLen			ldy	#$00		; start at offset = 0
StrLenLoop		lda (PTR3),Y	; load next character
				beq StrLenDone	; if character = 00, return true (zero flag on)
				iny				; increment offset
				bne StrLenLoop	; loop until y <= 255
StrLenDone		tya				; put result on accumulator
				rts