; handling of command TAKE
; data, command string
CMD_TAKE		asc "TAKE"
				hex 00
; implementation of command TAKE
; INPUT: BUFFER
; OUTPUT: none
; DESTROYS: PTR, PTR1, PTR2 registers a, y, flags: c, z
IsCmdTake		lda #<CMD_TAKE		; PTR1 low byte
				sta PTR1
				lda #>CMD_TAKE		; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$04			; string CMD_TAKE length
				sta PTR
				jsr CmpStrLeft		; compare PTR1, PTR2 up to len PTR (left)
				beq CmdTakeChkObj
				rts
CmdTakeChkObj	jmp CmdTakeIsLamp
CmdTakeIsLamp	lda #<OBJDSC_LAMP		; PTR1 low byte
				sta PTR1
				lda #>OBJDSC_LAMP		; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$04			; string 'LAMP' length
				sta PTR
				jsr CmpStrRight		; compare PTR1, PTR2 up to len PTR (right)
				bne CmdTakeIsKey	; next check
				lda #$00			; LAMP = 00
				sta PTR2
				jmp CmdTake
CmdTakeIsKey	lda #<OBJDSC_KEY	; PTR1 low byte
				sta PTR1
				lda #>OBJDSC_KEY	; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$03			; string 'KEY' length
				sta PTR
				jsr CmpStrRight		; compare PTR1, PTR2 up to len PTR (right)
				bne ErrNotHere		; we don't know this object
				lda #$01			; KEY = 01
				sta PTR2
				jmp CmdTake
CmdTake			lda PTR2			; put selected object
				sta PTR1			; on PTR1
				jsr GetObjLoc		; get PTR to object location
				lda (PTR)
				cmp LOC_IDX			; if it's not on current location
				bne	ErrNotHere		; show error message
				lda LOC_INVENTORY
				sta (PTR)			; (PTR) = LOC_INVENTORY
				jsr PrintString	
				asc "You have picked up "
				hex 00
				lda PTR1			; put obj description address
				sta PTR				; on PTR
				jsr GetObjDesc		; PTR = object descripton
				jsr PrintStringPtr
				jsr PrintString
				asc "."
				hex 8D00
CmdTakeDone		rts
ErrNotHere		jsr PrintString
				asc "You don't see that object in here."
				hex 8D00
				jsr CmdTakeDone