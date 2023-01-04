; handling of command GO
; data, command string
CMD_GO			asc "GO"
				hex 00
; implementation of command GO
; INPUT: BUFFER
; OUTPUT: none
; DESTROYS: PTR1, PTR2 registers a, y, flags: c, z
IsCmdGo			lda #<CMD_GO		; PTR1 low byte
				sta PTR1
				lda #>CMD_GO		; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$02			; string CMD_GO length
				sta PTR
				jsr CmpStrLeft		; compare PTR1, PTR2 up to len PTR (left)
				beq CmdGoChkDir
				rts
CmdGoChkDir		jmp CmdGoIsSouth
CmdGoIsSouth	lda #<DIR_SOUTH		; PTR1 low byte
				sta PTR1
				lda #>DIR_SOUTH		; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$05			; string DIR_SOUTH length
				sta PTR
				jsr CmpStrRight		; compare PTR1, PTR2 up to len PTR (right)
				bne CmdGoIsNorth	; next check
				lda #$02			; SOUTH = 02
				sta PTR2
				jmp CmdGo
CmdGoIsNorth	lda #<DIR_NORTH		; PTR1 low byte
				sta PTR1
				lda #>DIR_NORTH		; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$05			; string DIR_NORTH length
				sta PTR
				jsr CmpStrRight		; compare PTR1, PTR2 up to len PTR (right)
				bne CmdGoIsEast		; next check 
				lda #$01			; NORTH = 01
				sta PTR2
				jmp CmdGo
CmdGoIsEast		lda #<DIR_EAST		; PTR1 low byte
				sta PTR1
				lda #>DIR_EAST		; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$04			; string DIR_EAST length
				sta PTR
				jsr CmpStrRight		; compare PTR1, PTR2 up to len PTR (right)
				bne CmdGoIsWest		; next check
				lda #$03			; EAST = 01
				sta PTR2
				jmp CmdGo
CmdGoIsWest		lda #<DIR_WEST		; PTR1 low byte
				sta PTR1
				lda #>DIR_WEST		; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$04			; string DIR_EAST length
				sta PTR
				jsr CmpStrRight		; compare PTR1, PTR2 up to len PTR (right)
				bne CmdGoDone		; no next check
				lda #$04			; WEST = 01
				sta PTR2
				jmp CmdGo
CmdGo			lda LOC_IDX			; put current location
				sta PTR1			; on PTR1
									; direction is already on PTR2
				jsr NewLocIdx
				lda (PTR)
				cmp #$FF			; invalid direction ?
				beq CantGo
				sta LOC_IDX			; update location index
CmdGoDone		rts
CantGo			jsr PrintString
				asc "You cannot go in that direction."
				hex 8D00
				rts