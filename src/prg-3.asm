
.include "src/init.asm"
.include "src/interrupts.asm"
.include "src/ppu.asm"
.include "src/mmc3.asm"
.include "src/textscript.asm"


WaitXFrames:
	; This assumes you set X to an amount of frames to wait.
	; If you didn't do that you did something dumb.
	STX FramesToWait
-	JSR WaitForNMI
	DEC FramesToWait
	BNE -
	RTS


Start:
	JSR DisableNMI				; Turn off NMI while we're busy
	JSR DisablePPURendering		; And that pesky PPU too

	JSR DrawCactus
	JSR AddCactusSprites

	LDA #<Palette_Main
	STA PPUBufferLo
	LDA #>Palette_Main
	STA PPUBufferHi

	JSR EnableNMI
	JSR WaitForNMI
	JSR EnablePPURendering

	LDX #60
	JSR WaitXFrames
	LDA #song_index_mus_tcrf
	STA sound_param_byte_0
	JSR play_song

	LDX #240
	JSR WaitXFrames
	LDA #<Palette_Fade1
	STA PPUBufferLo
	LDA #>Palette_Fade1
	STA PPUBufferHi


	LDX #10
	JSR WaitXFrames
	LDA #<Palette_Fade2
	STA PPUBufferLo
	LDA #>Palette_Fade2
	STA PPUBufferHi

	LDX #10
	JSR WaitXFrames
	LDA #<Palette_Fade3
	STA PPUBufferLo
	LDA #>Palette_Fade3
	STA PPUBufferHi

	LDX #10
	JSR WaitXFrames
	LDA #<Palette_Fade4
	STA PPUBufferLo
	LDA #>Palette_Fade4
	STA PPUBufferHi

	;LDA #<Text_HelloWorld
	;STA PPUBufferLo
	;LDA #>Text_HelloWorld
	;STA PPUBufferHi
	;JSR WaitForNMI

	;LDX #120
	;JSR WaitXFrames

	;LDA #<TScript_Test
	;STA TextScriptLo
	;LDA #>TScript_Test
	;STA TextScriptHi
	;JSR DoTextScript

	LDX #240
	JSR WaitXFrames


	TextScript TScript_HappyBirthday
	INC FunfettiEnable
	LDX #240
	JSR WaitXFrames
	LDX #120
	JSR WaitXFrames
	TextScript TScript_DateOfBirth

	;LDA #<TScript_HappyBirthday
	;STA TextScriptLo
	;LDA #>TScript_HappyBirthday
	;STA TextScriptHi
	;JSR DoTextScript

	JMP DoNothing


DoNothing:
	JSR WaitForNMI
	JMP DoNothing


AnimateConfetti:
	; Animate the confetti
	LDA FrameCounter
	AND #$03
	TAY

	LDX #$7F					; Sprites to animate x 4 bytes per sprite
-	DEX
	DEX
	DEY
	BNE +
	LDA SpriteDMAArea, X		; Get the current tile index
	PHA							; Make a quick copy...
	AND #%11111000				; ...so we can erase the animation number.
	STA Temp0002				; ...and put it here for a bit.
	PLA							; Now get the copy again...
	CLC							; Then clear carry...
	ADC #$01					; ...so we can add one.
	AND #%00000111				; ...and mask off only the animation number.
	ORA Temp0002				; Mix it back in with the tile index...
	STA SpriteDMAArea, X		; ...and then store the full thing back.
	LDY #$03
+	DEX							; Decrement to edit sprite Y positions...
	LDA FrameCounter
	AND FunfettiSpeed
	BNE +
	INC	SpriteDMAArea, X		; ...and increment it by one.
	BNE +
	LDA PRNGSeed+2
	STA SpriteDMAArea+3, X		; Hmm
	LDA PRNGSeed+3
	AND #%00111111
	ORA FunfettiMask
	STA SpriteDMAArea+1, X		; Hmm?
+	DEX
	BPL -
	RTS							; Once we've updated all funfetti, we're done.




DrawCactus:
	LDA PPUSTATUS				; Flush PPU address latch
	LDA #$20					; PPU address, high
	STA PPUADDR
	LDA #$00					; PPU address, low
	STA PPUADDR

	LDA #<CactusNametable		; Low address of cactus nametable data
	STA TempAddrLo
	LDA #>CactusNametable		; High address of cactus nametable data
	STA TempAddrHi

	LDX #$04					; Copying $400 bytes
--	LDY #$00

-	LDA (TempAddrLo), Y			; Get a byte of data...
	STA PPUDATA					; ...stuff it into PPU
	INY
	BNE -						; Continue until we wrap Y...

	INC TempAddrHi				; Increase the read address...
	DEX							; Decrement the read count...
	BNE --						; If still more, keep going.

	RTS							; All done


AddCactusSprites:
	LDA #<ConfettiSprites
	STA TempAddrLo
	LDA #>ConfettiSprites
	STA TempAddrHi
	LDY #$00					; Copying another 100 bytes here

-	LDA (TempAddrLo), Y			; Copy our sprites in
	STA SpriteDMAArea, Y
	INY
	BNE -						; Repeat until all copied
	RTS

Palette_Main:
	;   PPU Addr  Len
	.db $3F, $00, $20
	.db $0F, $00, $10, $30 ; BG 0
;	.db $0F, $09, $19, $38 ; BG 1
	.db $0F, $0F, $0F, $0F ; BG 1
	.db $0F, $05, $15, $35 ; BG 2
	.db $0F, $07, $17, $37 ; BG 3
;	.db $0F, $08, $29, $38 ; SP 0
	.db $0F, $0F, $0F, $0F ; SP 0
	.db $0F, $06, $26, $30 ; SP 1
	.db $0F, $1a, $2a, $30 ; SP 2
	.db $0F, $12, $22, $30 ; SP 3
	.db $00 ; End

Palette_Fade1:
	;   PPU Addr  Len
	.db $3F, $05, $03, $0F, $0F, $08 ; BG 1
	.db $3F, $11, $03, $0F, $0F, $08 ; SP 0
	.db $00 ; End

Palette_Fade2:
	;   PPU Addr  Len
	.db $3F, $05, $03, $0F, $0F, $18 ; BG 1
	.db $3F, $11, $03, $0F, $09, $18 ; SP 0
	.db $00 ; End

Palette_Fade3:
	;   PPU Addr  Len
	.db $3F, $05, $03, $0F, $09, $28 ; BG 1
	.db $3F, $11, $03, $0F, $19, $28 ; SP 0
	.db $00 ; End

Palette_Fade4:
	;   PPU Addr  Len
	.db $3F, $05, $03, $09, $19, $38 ; BG 1
	.db $3F, $11, $03, $08, $29, $38 ; SP 0
	.db $00 ; End


Text_HelloWorld:
	;.db $22, $e7, 19, "TCRF POO  CHALLENGE"
	;.db $23, $07, 19, " Our 9th birthday! "
	;.db $23, $42, 28, "Featuring the most realistic"
	PPUPos 4, 5
	;.db 22, "Happy birthday,  TCRF!"
	PPUDat "Happy birthday,  TCRF!"
;	.db $20, $85, 22, "Happy birthday,  TCRF!"
	.db $00 ; End


TScript_HappyBirthday:
	TS_NewPos 3, 4
	TS_Speed 1
	.db "  Happy 9th birthday,  "
	TS_Delay 95
	TS_Speed 1
	.db TextScript_AdvanceLine
	.db TextScript_AdvanceLine
	.db "The Cutting Room Floor!"
	.db TextScript_End

TScript_DateOfBirth:
	TS_NewPos 23, 4
	TS_Speed 3
	.db "TCRF, the wiki"
	TS_Delay 60
	.db TextScript_AdvanceLine
	.db "        October 25, "
	TS_Delay 20
	.db "2009"
	TS_Delay 60
	.db TextScript_AdvanceLine
	.db TextScript_AdvanceLine
	.db "Original website"
	TS_Delay 60
	.db TextScript_AdvanceLine
	.db "       November 20, "
	TS_Delay 20
	.db "2002"
	.db TextScript_End

TScript_Test:
	.db TextScript_NewAddress, $20, $a1
	.db TextScript_ChangeSpeed, 2
	.db "Some sample text for the new"
	.db TextScript_DoDelay, 20
	.db TextScript_NewAddress, $20, $e1
	.db TextScript_ChangeSpeed, 5
	.db "'Text Script System'. "
	.db TextScript_DoDelay, 90
	.db TextScript_ChangeSpeed, 45
	.db "..."
	.db TextScript_ChangeSpeed, 2
	.db "yep."
	.db TextScript_NewAddress, $21, $21
	.db TextScript_DoDelay, 60
	.db "It can type"
	.db TextScript_ChangeSpeed, 40
	.db " slow"
	.db TextScript_ChangeSpeed, 10
	.db ", or "
	.db TextScript_ChangeSpeed, 1
	.db "fast."
	.db TextScript_DoDelay, 30
	.db TextScript_NewAddress, $21, $61
	.db TextScript_ChangeSpeed, 2
	.db "It can pause, too."
	.db TextScript_DoDelay, 120
	.db TextScript_ChangeSpeed, 3
	.db " Like that."
	.db TextScript_DoDelay, 180
	.db TextScript_ChangeSpeed, 1
	.db TextScript_NewAddress, $21, $c1
	.db "I think it's pretty neat."
	.db TextScript_End


CactusNametable:
	.incbin "src/data/cactus-nametable.bin"

ConfettiSprites:
	.incbin "src/data/funfetti-blank.bin"




UpdatePRNG:
	LDA PRNGSeed+2	; Keep the last two generated bytes for use later
	STA PRNGSeed+3
	LDA PRNGSeed+0
	STA PRNGSeed+2

	LDX #8     ; iteration count (generates 8 bits)
	LDA PRNGSeed
-
	ASL        ; shift the register
	ROL PRNGSeed+1
	BCC +
	EOR #$2D   ; apply XOR feedback whenever a 1 bit is shifted out
+
	DEX
	BNE -
	STA PRNGSeed
	CMP #0     ; reload flags
	RTS
