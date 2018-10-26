
DoTextScript:
	; TextScriptLo/Hi: Current read address of script
	; TextScriptPPULo/Hi: Current address to write to in PPU mem
	; TextScriptSpeed: Frames to wait between commands
	; TextScriptDelay: Frames left until next command

	; Get command
	JSR DoTextScript_GetNextByte

	; Based on A, do things
	CMP #TextScript_End				; If the next byte is terminating, done
	BEQ DoTextScript_End

	CMP #TextScript_NewAddress		; New PPU address to write to
	BEQ DoTextScript_NewAddress

	CMP #TextScript_ChangeSpeed		; New speed to use
	BEQ DoTextScript_ChangeSpeed

	CMP #TextScript_DoDelay			; Wait some frames before continuing
	BEQ DoTextScript_DoDelay

	; Nothing, guess we're drawing another character.
	STA TextScriptPPUChar
	LDA #<TextScriptPPUHi
	STA PPUBufferLo
	LDA #>TextScriptPPUHi
	STA PPUBufferHi

	LDX TextScriptSpeed				; Wait frames as required
	JSR WaitXFrames

	INC TextScriptPPULo				; Advance PPU pointer
	BNE +
	INC TextScriptPPUHi				; and its high byte, if needed

+	JMP DoTextScript

DoTextScript_End:
	RTS								; Laters.


DoTextScript_NewAddress:
	JSR DoTextScript_GetNextByte	; Get the next PPU address...
	STA TextScriptPPUHi				; ...and store it
	JSR DoTextScript_GetNextByte	; Get the low byte, too...
	STA TextScriptPPULo				; ...and store that too.
	LDA #$01						; Mark PPU buffer as having one char...
	STA TextScriptPPULen
	LDA #$00						; ...and ensure it ends properly.
	STA TextScriptPPUEnd
	JMP DoTextScript				; Resume


DoTextScript_ChangeSpeed:
	JSR DoTextScript_GetNextByte	; Get the next byte, our delay
	STA	TextScriptSpeed				; Set it as our new delay
	JMP DoTextScript				; Resume

DoTextScript_DoDelay:
	JSR DoTextScript_GetNextByte	; Get number of frames to wait
	TAX
	JSR WaitXFrames					; Wait for some frames!
	JMP DoTextScript


DoTextScript_GetNextByte:
	LDY #$00				; Get the current byte of the script...
	LDA (TextScriptLo), Y
	INC TextScriptLo		; Increment read address by one
	BNE +
	INC TextScriptHi		; Update high byte if overflow
+	RTS
