
DoTextScript:
	; TextScriptLo/Hi: Current read address of script
	; TextScriptPPULo/Hi: Current address to write to in PPU mem
	; TextScriptSpeed: Frames to wait between commands
	; TextScriptDelay: Frames left until next command

	; Get command
	JSR DoTextScript_GetNextByte

	; Based on A, do things
	; @TODO this would probably make for a nice
	; jump table in the future, since it's a little. oof. yikes.
	CMP #TextScript_End				; If the next byte is terminating, done
	BEQ DoTextScript_End

	CMP #TextScript_NewAddress		; New PPU address to write to
	BEQ DoTextScript_NewAddress

	CMP #TextScript_ChangeSpeed		; New speed to use
	BEQ DoTextScript_ChangeSpeed

	CMP #TextScript_DoDelay			; Wait some frames before continuing
	BEQ DoTextScript_DoDelay

	CMP #TextScript_AdvanceLine		; Advance one line downwards
	BEQ DoTextScript_AdvanceLine

	CMP #TextScript_Scroll			; Time to scroll down some
	BEQ DoTextScript_Scroll

	; Nothing, guess we're drawing another character.
	STA TextScriptPPUChar
	LDA #<TextScriptPPUHi
	STA PPUBufferLo
	LDA #>TextScriptPPUHi
	STA PPUBufferHi
	LDA #$2
	STA PPUBufferReady


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
	STA TextScriptPPUBaseHi			; ...and store it
	STA TextScriptPPUHi				; ...and store it
	JSR DoTextScript_GetNextByte	; Get the low byte, too...
	STA TextScriptPPUBaseLo			; ...and store that too.
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

DoTextScript_AdvanceLine:
	CLC
	LDA TextScriptPPUBaseLo			; Get the old startind area
	ADC #$20						; Bump it down one line
	STA TextScriptPPUBaseLo			; Store it to our new place
	STA TextScriptPPULo				; As well as the current address
	BCC +
	INC TextScriptPPUBaseHi			; Bump up the high byte if needed too
	LDA TextScriptPPUBaseHi			; Get the new address
	STA TextScriptPPUHi				; and store it to the current one too

+	JMP DoTextScript


DoTextScript_GetNextByte:
	LDY #$00				; Get the current byte of the script...
	LDA (TextScriptLo), Y
	INC TextScriptLo		; Increment read address by one
	BNE +
	INC TextScriptHi		; Update high byte if overflow
+	RTS

DoTextScript_Scroll:
	; Scroll 8 pixels ...
	LDX #$08						; Scroll up for 8 frames, one pixel/fr
	STX FramesToWait
-	JSR WaitForNMI
	INC PPUScrollY
	DEC FramesToWait
	BNE -
	JSR DoTextScript_GetNextByte	; Assume next byte = line to clear
	LDX #$00						; then clear that line
	JSR ClearOneTileRow
	JSR WaitForNMI

	JMP DoTextScript
