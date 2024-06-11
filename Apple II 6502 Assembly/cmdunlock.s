; handling of command UNLOCK
; data, constants
CMD_UNLCK_DOOR	asc "UNLOCK DOOR"
				hex 00
; command unlock door
; INPUT: BUFFER
; OUTPUT: none
; DESTROYS: PTR, PTR1, PTR2 registers a, y, flags: c, z
IsCmdUnlckDoor	lda #<CMD_UNLCK_DOOR	; PTR1 low byte
				sta PTR1
				lda #>CMD_UNLCK_DOOR	; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				jsr CompareStrings	; compare PTR1, PTR2
				beq CmdUnlckDoor
				rts
CmdUnlckDoor 	lda OBJ_KEY_IDX
				sta PTR1			; PTR1 = index of key object
				jsr GetObjLoc	
				lda (PTR)			; PTR = location of key object
				cmp LOC_INVENTORY	; is it on player's inventory?
				beq CmdUnlckLocChk	; if player has key, go to location check
				jmp ErrDoor
CmdUnlckLocChk	lda LOC_IDX			; current location
				bne ErrDoor			; we must be in location 00
				sta PTR				; PTR = LOC_IDX address
				jsr GetLocDesc		; PTR = location description
				jsr StrCpy			; copies below string to PTR
				asc "an empty office. There are doors to the south and to the east"
				hex 00
				lda #$00			; location = empty office
				sta PTR1			; on PTR1
				lda #$03			; direction = east
				sta PTR2			; on PTR2
				jsr NewLocIdx		; PTR = address of empty office east exit
				lda (PTR)			; if east exit
				cmp #$02			; is already 02 (dark room)
				beq	ErrAlrdyUnlcked	; the door is already unlocked
				lda #$02			; location = dark room
				sta (PTR)			; replaces the former east exit
				jsr PrintString
				asc "You have unlocked the door."
				hex 8D00
CmdUnlckDoorEnd	rts
ErrDoor			jsr PrintString
				asc "You can't do that."
				hex 8D00
				jmp CmdUnlckDoorEnd
ErrAlrdyUnlcked	jsr PrintString
				asc "The door is already unlocked."
				hex 8D00
				jmp CmdUnlckDoorEnd