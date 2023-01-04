; handling of command HELP
; data, command string
CMD_HELP		asc "HELP"
				hex 00
; implementation of command HELP
IsCmdHelp		lda #<CMD_HELP		; PTR1 low byte
				sta PTR1
				lda #>CMD_HELP		; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$04			; string CMD_TAKE length
				sta PTR
				jsr CmpStrLeft		; compare PTR1, PTR2 up to len PTR (left)
				beq CmdHelp
				rts
CmdHelp			jsr PrintString
				asc "Try some of the following commands: GO, TAKE, DROP, INVENTORY, LIGHT, UNLOCK"
				hex 8D00
				rts