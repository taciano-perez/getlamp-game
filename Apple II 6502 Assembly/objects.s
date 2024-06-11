; data and subroutines handling objects
; constants
NUM_OBJS		equ #$02	; two objects in total
LOC_INVENTORY	equ #$AA	; location = in inventory
OBJ_LAMP_IDX	equ #$00
OBJ_KEY_IDX		equ #$01
; data, object descriptions
OBJDSC_LAMP	asc "a lamp"
			hex 00000000008D	; \n\r
OBJDSC_KEY	asc "a key"
			hex 008D	; \n\r
; data, object locations
OBJLOC_LAMP	hex 00
OBJLOC_KEY	hex 01
;
; get location of an object
; INPUT: object index on PTR1
; OUTPUT: location (PTR)
; DESTROYS: registers x, a
GetObjLoc	lda #<OBJLOC_LAMP	; base addr (LO)
			sta PTR
			lda #>OBJLOC_LAMP	; base addr (HI)
			sta PTR+1
			ldx	#$00			; x = current object index
GetObjLocLp	cpx PTR1			; compare to origin location
			beq GetObLocEnd
			clc
			lda PTR		; increment
			adc #1		; by one
			sta PTR		; the address in PTR
			lda PTR+1	; and carry 
			adc #0		; to PTR+1
			sta PTR+1	; if needed
			inx
			jmp GetObjLocLp
GetObLocEnd	rts
;
; get object description
; INPUT: location index on address PTR
; OUTPUT: location description (PTR)
; DESTROYS: PTR2 (index), registers a,x,y
GetObjDesc	lda PTR			; take index
			sta PTR2		; and store in PTR2
			lda #<OBJDSC_LAMP 	; store base list address (LO)
			sta PTR			; on PTR 
			lda #>OBJDSC_LAMP 	; store base list address (HI)
			sta PTR+1		; on PTR
			ldx #0        	; string count (x) = 0
			ldy #0        	; char count (y) = 0
			jmp GtObDscLpCk	; check loop condition before starting
GtObDscLpSt	clc
			lda PTR		; increment
			adc #1		; by one
			sta PTR		; the address in PTR
			lda PTR+1	; and carry 
			adc #0		; to PTR+1
			sta PTR+1	; if needed
			iny         ; increment y
    		bne GtObDscLpCk
GtObDscLpCk	cpx PTR2		; compare string count (x) with desired index (PTR2)
			beq GtObjDscEnd 	; we're done here
							; else
			lda (PTR)		; load next char
			cmp #$8D		; \r
			bne GtObDscLpSt	; char is not \r, keep looping
							; else
			inx				; increment index count
			ldy #0        	; zero the char count
			jmp GtObDscLpSt	; keep looping
GtObjDscEnd	lda PTR
			lda PTR+1
			rts
;
; display all objects in the current location
; INPUT: NONE
; OUTPUT: NONE
; DESTROYS: PTR, PTR1, PTR2; registers a, x
DisplayObjs		lda #$00		; object offset = 0
				pha				; push offset to stack
DisplayObjsLp	pla				; get offset from stack
				sta PTR1		; put object offset on PTR1
				pha				; back to stack
				jsr GetObjLoc	; PTR = object location
				lda (PTR)		; check if object
				cmp LOC_IDX		; is in current location
				bne DisplayObjsNxt	; otherwise go to next object
				jsr PrintString
				asc "You see "
				hex 00
				txa					; put object index
				sta PTR				; on PTR
				jsr GetObjDesc		; PTR = object description address
				jsr PrintStringPtr
				jsr PrintString
				hex 8D00
DisplayObjsNxt	pla					; pull offset from stack
				tax					; move to x and
				inx					; increment obj offset
				txa					; back to accumulator
				pha					; push back to stack
				cmp NUM_OBJS		; are we done yet?
				bcc	DisplayObjsLp	; more objects to check
DisplayObjsEnd 	pla					; clean stack
				rts