; data and subroutines handling location
; constants, location indices
LOC_OFFICE	equ	#$00
LOC_STOCK	equ	#$01
LOC_DARK	equ	#$02
LOC_OUTSIDE	equ	#$03
; constants, direction indices
NORTH	equ #$01
SOUTH	equ #$02
EAST	equ #$03
WEST	equ #$04
NO_EXIT	equ #$FF
; data, direction names
DIR_NORTH		asc "NORTH"
				hex 00
DIR_SOUTH		asc "SOUTH"
				hex 00
DIR_EAST		asc "EAST"
				hex 00
DIR_WEST		asc "WEST"
				hex 00
; data, location descriptions
LOC_0	asc "an empty office. There is a door to the south and a locked door to the east"
		hex 008D	; \n\r
LOC_1	asc "the stock room. There is a door to the north"
		hex 008D	; \n\r
LOC_2	asc "a dark room. You can barely see anything"
		hex 0000000000000000000000008D	; \n\r
LOC_3	asc "the world outside"
		hex 008D	; \n\r
; data, possible exits from each location
; 		orig  N S E W
EXTS_0	hex 00ff01ffff
EXTS_1	hex 0100ffffff
EXTS_2	hex 02ffffff00
EXTS_3	hex 02ffffffff
;
; get new location given origin and direction
; INPUT: origin location on address PTR1, direction on address PTR2
;		directions are N (01), S (02), E (03), or W (04)
; OUTPUT: new location (PTR)
; DESTROYS: registers x, y, a
NewLocIdx	ldx	#$00	; x = location index
			lda #<EXTS_0	; base addr (LO)
			sta PTR
			lda #>EXTS_0	; base addr (HI)
			sta PTR+1
NewLocLoop1	cpx PTR1	; compare to origin location
			beq NewLocDir
			clc
			lda PTR		; increment
			adc #5		; by five (record size)
			sta PTR		; the address in PTR
			lda PTR+1	; and carry 
			adc #0		; to PTR+1
			sta PTR+1	; if needed
			inx
			jmp NewLocLoop1
NewLocDir	ldy #$01	; y = direction index
NewLocLoop2	clc
			lda PTR		; increment
			adc #1		; by one
			sta PTR		; the address in PTR
			lda PTR+1	; and carry 
			adc #0		; to PTR+1
			sta PTR+1	; if needed
			cpy PTR2	; compare to desired location
			beq	NewLocEnd
			iny
			jmp NewLocLoop2
NewLocEnd	rts
;
; get location description
; INPUT: location index on address PTR
; OUTPUT: location description (PTR)
; DESTROYS: PTR2 (index), registers a,x,y
GetLocDesc	lda PTR			; take index
			sta PTR2		; and store in PTR2
			lda #<LOC_0 	; store base list address (LO)
			sta PTR			; on PTR 
			lda #>LOC_0 	; store base list address (HI)
			sta PTR+1		; on PTR
			ldx #0        	; string count (x) = 0
			ldy #0        	; char count (y) = 0
			jmp loopTest  	; test loop condition before starting
loopStart	clc
			lda PTR		; increment
			adc #1		; by one
			sta PTR		; the address in PTR
			lda PTR+1	; and carry 
			adc #0		; to PTR+1
			sta PTR+1	; if needed
			iny         ; increment y
    		bne loopTest
loopTest	cpx PTR2		; compare string count (x) with desired index (PTR2)
			beq GetLocDone 	; we're done here
							; else
			lda (PTR)		; load next char
			cmp #$8D		; \r
			bne loopStart	; char is not \r, keep looping
							; else
			inx				; increment index count
			ldy #0        	; zero the char count
			jmp loopStart 	; keep looping
GetLocDone	lda PTR
			lda PTR+1
			rts