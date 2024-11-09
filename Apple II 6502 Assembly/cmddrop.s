; handling of command DROP
; data, command string
CMD_DROP		asc "DROP"
				hex 00
; implementation of command DROP
; INPUT: BUFFER
; OUTPUT: none
; DESTROYS: PTR, PTR1, PTR2 registers a, y, flags: c, z
IsCmdDrop		lda #<CMD_DROP		; PTR1 low byte
				sta PTR1
				lda #>CMD_DROP		; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$04			; string CMD_TAKE length
				sta PTR
				jsr CmpStrLeft		; compare PTR1, PTR2 up to len PTR (left)
				beq CmdDropChkObj
				rts
CmdDropChkObj	jmp CmdDropIsLamp
CmdDropIsLamp	lda #<OBJDSC_LAMP		; PTR1 low byte
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
				bne CmdDropIsKey	; next check
				lda #$00			; LAMP = 00
				sta PTR2
				jmp CmdDrop
CmdDropIsKey	lda #<OBJDSC_KEY	; PTR1 low byte
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
				bne ErrNotCarrying	; we don't know this object
				lda #$01			; KEY = 01
				sta PTR2
				jmp CmdDrop
CmdDrop			lda PTR2			; put selected object
				sta PTR1			; on PTR1
				jsr GetObjLoc		; get PTR to object location
				lda (PTR)
				cmp LOC_INVENTORY	; if it's not in inventory
				bne	ErrNotCarrying	; show error message
				lda LOC_IDX			; current location
				sta (PTR)			; update obj location
				jsr PrintString	
				asc "You have dropped "
				hex 00
				lda PTR1			; put obj description address
				sta PTR				; on PTR
				jsr GetObjDesc		; PTR = object descripton
				jsr PrintStringPtr
				jsr PrintString
				asc "."
				hex 8D00
CmdDropDone		rts
ErrNotCarrying	jsr PrintString
				asc "You don't have that object."
				hex 8D00
				jsr CmdDropDone