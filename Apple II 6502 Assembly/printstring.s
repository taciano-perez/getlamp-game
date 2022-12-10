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