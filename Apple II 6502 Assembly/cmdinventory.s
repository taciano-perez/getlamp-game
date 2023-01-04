; handling of command INVENTORY
; data, command string
CMD_INVENTORY	asc "INVENTORY"
				hex 00
; implementation of command INVENTORY
; INPUT: BUFFER
; OUTPUT: none
; DESTROYS: PTR, PTR1, PTR2 registers a, y, flags: c, z
IsCmdInventory	lda #<CMD_INVENTORY		; PTR1 low byte
				sta PTR1
				lda #>CMD_INVENTORY		; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$04			; string CMD_TAKE length
				sta PTR
				jsr CmpStrLeft		; compare PTR1, PTR2 up to len PTR (left)
				beq CmdInventory
				rts
CmdInventory	jsr PrintString
				asc "You are carrying:"
				hex 8D00
				lda #$00		; object offset = 0
				pha				; push offset to stack
CmdInvCheckObj	pla				; get offset from stack
				sta PTR1		; put object offset on PTR1
				pha				; back to stack
				jsr GetObjLoc	; PTR = object location
				lda (PTR)			; check if object
				cmp LOC_INVENTORY	; is in player's inventory
				bne CmdInvNextObj	; otherwise go to next object
				jsr PrintString
				asc " "
				hex 00
				txa					; put object index
				sta PTR				; on PTR
				jsr GetObjDesc		; PTR = object description address
				jsr PrintStringPtr
				jsr PrintString
				hex 8D00
CmdInvNextObj	pla					; pull offset from stack
				tax					; move to x and
				inx					; increment obj offset
				txa					; back to accumulator
				pha					; push back to stack
				cmp NUM_OBJS		; are we done yet?
				bcc	CmdInvCheckObj	; more objects to check
CmdInvEnd	 	pla					; clean stack
				rts