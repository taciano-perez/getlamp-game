; prints a null-terminated string (max 255 chars)
; expects the string to follow the jsr calling this subroutine
; INPUT: stack
; OUTPUT: none
; DESTROYS: PTR, registers a, y, flags: c, z
PrintString		pla			; pull string address from the stack (LO byte)
				sta PTR		; store LO address in PTR
				pla			; pull string address from the stack (HI byte)
				sta PTR+1	; store HI address in PTR
				ldy	#$01	; start at offset = 1
PrtStrLoop		lda (PTR),Y	; load next character
				beq PrtStrFinish	; if character = 00, finish
				jsr COUT	; print character
				iny			; increment offset
				bne PrtStrLoop	; loop until y <= 255
PrtStrFinish	clc			; clear carry flag
				tya			; transfer character offset to accumulator
				adc PTR		; add offset to PTR
				sta PTR		; new PTR (LO)
				lda PTR+1	
				adc #$00	; add offset to PTR (HI), in case carry flag is set
				pha			; push PTR (HI) to stack
				lda PTR
				pha			; push PTR (LO) to stack
PrtStrExit		rts
;
; prints a null-terminated string (max 255 chars) at PTR
; expects the string to be in PTR
; INPUT: PTR
; OUTPUT: none
; DESTROYS: register y, flag z
PrintStringPtr	ldy #$00
PrtStrPLoop		lda (PTR),Y		; load next character
				beq PrtStrPDone	; if character = 00, finish
				jsr COUT		; print character
				iny				; increment offset
				bne PrtStrPLoop	; loop until y <= 255
PrtStrPDone		rts
;
; copies a null-terminated string (max 255 chars) from origin to destination
; expects the origin string to follow the jsr calling this subroutine
; INPUT: stack (origin), PTR (destination)
; OUTPUT: none
; DESTROYS: PTR1, registers a, y, flags: c, z
StrCpy			pla				; pull string address from the stack (LO byte)
				sta PTR1		; store LO address in PTR
				pla				; pull string address from the stack (HI byte)
				sta PTR1+1		; store HI address in PTR
				ldy	#$01		; origin offset starts at one
StrCpyLoop		lda (PTR1),Y	; load next character
				dey				; destination offset starts at zero
				sta (PTR),Y		; copy to destination pointer
				pha				; store character
				iny				; increment y for origin offset
				pla				; restore character
				beq StrCpyFinish ; if character = 00, finish
				iny				; increment offset
				bne StrCpyLoop	; loop until y <= 255
StrCpyFinish	clc				; clear carry flag
				tya				; transfer character offset to accumulator
				adc PTR1		; add offset to PTR
				sta PTR1		; new PTR (LO)
				lda PTR1+1	
				adc #$00		; add offset to PTR (HI), in case carry flag is set
				pha				; push PTR (HI) to stack
				lda PTR1
				pha				; push PTR (LO) to stack
StrCpyExit		rts