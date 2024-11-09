; handling of command LIGHT
; data, command string
CMD_LIGHT_LAMP	asc "LIGHT LAMP"
				hex 00
; implementation of command LIGHT LAMP
; INPUT: BUFFER
; OUTPUT: none
; DESTROYS: PTR, PTR1, PTR2 registers a, y, flags: c, z
IsCmdLightLamp	lda #<CMD_LIGHT_LAMP	; PTR1 low byte
				sta PTR1
				lda #>CMD_LIGHT_LAMP	; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				lda #$0A			; string CMD_LIGHT_LAMP length
				sta PTR
				jsr CmpStrLeft		; compare PTR1, PTR2 up to len PTR (left)
				beq CmdLightLamp
				rts
CmdLightLamp	lda OBJ_LAMP_IDX
				sta PTR1			; PTR1 = lamp index
				jsr GetObjLoc		; get lamp location
				lda (PTR)			; PTR = lamp location
				cmp LOC_INVENTORY	; is it on player's inventory
				bne ErrNoLamp		; if not, show error msg
				lda OBJ_LAMP_IDX
				sta PTR				; PTR = lamp index
				jsr GetObjDesc		; (PTR) = lamp description
				jsr StrCpy			; copies below string to (PTR)
				asc "a lit lamp"
				hex 00
				lda LOC_DARK
				sta PTR				; PTR = dark room index
				jsr GetLocDesc		; PTR = location description
				jsr StrCpy			; copies below string to PTR
				asc "an empty room. You see doors leading west and south"
				hex 00
				lda LOC_DARK
				sta PTR1			; PTR1 = dark room index
				lda SOUTH
				sta PTR2			; PTR2 = south
				jsr NewLocIdx		; PTR = address of dark room east south
				lda LOC_OUTSIDE		; location outside
				sta (PTR)			; replaces the former exit south
				jsr PrintString
				asc "Now you have a lit lamp."
				hex 00
				rts
ErrNoLamp		jsr PrintString
				asc "You don't have a lamp."
				hex 8D00
				rts