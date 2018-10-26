
.include "src/init.asm"
.include "src/interrupts.asm"
.include "src/mmc3.asm"
.include "src/textscript.asm"


WaitXFrames:
	; This assumes you set X to an amount of frames to wait.
	; If you didn't do that you did something dumb.
-	JSR WaitForNMI
	DEX
	BNE -
	RTS


Start:

	JSR EnableNMI

	LDA #<Palette_Main
	STA PPUBufferLo
	LDA #>Palette_Main
	STA PPUBufferHi

	JSR WaitForNMI
	;LDX #60
	;JSR WaitXFrames

	LDA #<Text_HelloWorld
	STA PPUBufferLo
	LDA #>Text_HelloWorld
	STA PPUBufferHi

	LDX #120
	JSR WaitXFrames

	LDA #<TScript_Test
	STA TextScriptLo
	LDA #>TScript_Test
	STA TextScriptHi
	JSR DoTextScript

	JMP DoNothing


DoNothing:
	JSR WaitForNMI
	JMP DoNothing



Palette_Main:
	;   PPU Addr  Len
	.db $3F, $00, $20
	.db $0F, $01, $11, $31 ; BG 0
	.db $0F, $03, $13, $33 ; BG 1
	.db $0F, $05, $15, $35 ; BG 2
	.db $0F, $07, $17, $37 ; BG 3
	.db $0F, $02, $12, $32 ; SP 0
	.db $0F, $04, $14, $34 ; SP 1
	.db $0F, $06, $16, $36 ; SP 2
	.db $0F, $08, $18, $38 ; SP 3
	.db $00 ; End

Text_HelloWorld:
	.db $22, $c7, 19, " This ROM is for a "
	.db $22, $e7, 19, "special thing soon."
	.db $23, $27, 19, "It's not ready yet,"
	.db $23, $47, 19, "   so be patient!  "
	.db $00 ; End


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
