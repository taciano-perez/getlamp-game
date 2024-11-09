; Get Lamp - a text-adventure game
; 6502 Assembly version (Apple IIe)
; (c) Taciano Dreckmann Perez 2023
; https://github.com/taciano-perez
				org $4000
; game entry point
Begin			jmp InitIO
; data
LOC_IDX			hex 00		; start at location zero
CMD_QUIT		asc "QUIT"
				hex 00
				brk
; include subroutine source files
				put common.s
				put	printstring.s
				put	inputstring.s
				put	cmpstring.s
				put	location.s
				put	objects.s
				put cmdgo.s
				put cmdtake.s
				put cmddrop.s
				put cmdinventory.s
				put cmdunlock.s
				put cmdlight.s
				put cmdhelp.s
;				
InitIO			jsr SETVID	; remove ProDOS screen hooks
				jsr SETKBD 	; remove ProDOS keyboard hooks
PrintBanner		jsr PrintString
				asc "* GET LAMP - A (SHORT) TEXT ADVENTURE *"
				hex 8D8D00
; command loop
CmdLoop			jsr PrintString
				asc "You are in "
				hex 00
PrintLoc		ldy LOC_IDX			
				sty PTR				; PTR = LOC_IDX address
				jsr GetLocDesc		; PTR = location description
				jsr PrintStringPtr	; print location description
				jsr PrintString
				asc "."
				hex 8D00
PrintObjects	jsr DisplayObjs				
PrintPrompt		jsr PrintString
				asc "> "
				hex 00
GetCmd	 		jsr InputString		; get input command
IsCmdQuit		lda #<CMD_QUIT		; PTR1 low byte
				sta PTR1
				lda #>CMD_QUIT		; PTR1 high byte
				sta PTR1+1
				lda #<BUFFER		; PTR2 low byte
				sta PTR2
				lda #>BUFFER		; PTR2 high byte
				sta PTR2+1
				jsr CompareStrings	; compare PTR1, PTR2
				beq ExitGame		; if CMD = QUIT, exit
				jsr EvalCmd
EndCmdLoop		jsr PrintString		; else print \r
				hex 8D00
CheckWin		lda LOC_IDX
				cmp LOC_OUTSIDE
				beq GameWon
				jmp CmdLoop			;  loop again
; exit game
ExitGame		jsr PRDBI			; reset screen and keyboard handlers
				rts
EvalCmd			jsr IsCmdGo
				jsr IsCmdTake
				jsr IsCmdDrop
				jsr IsCmdInventory
				jsr IsCmdUnlckDoor
				jsr IsCmdLightLamp
				jsr IsCmdHelp
EvalCmdDone		rts
GameWon			jsr PrintString
				asc "You are in the world outside."
				hex 8D00
				jsr PrintString
				asc "Congratulations, you have won the game!"
				hex 8D00
				jmp ExitGame