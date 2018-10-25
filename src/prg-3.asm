; public RESET
; This code is called when the NES is reset
RESET:
	SEI
	CLD
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background0000 | PPUCtrl_SpriteSize8x8 | PPUCtrl_NMIDisabled
	STA PPUCTRL
	LDX #$FF ; Reset stack pointer
	TXS

	; Wait for two VBlanks
-	LDA PPUSTATUS
	AND #PPUStatus_VBlankHit
	BEQ -
-	LDA PPUSTATUS
	BPL -

	; Set nametable mirroring
	LDA #HMirror
	STA NametableMapping

	; Enable extended RAM at 6000-7FFF
	LDA #$80
	STA $A001

	JMP ClearMemory



; -----------------------------------------------------------------------------
; If we end up here something probably went wrong, oops
IRQ:
	RTI

; -----------------------------------------------------------------------------
; Non-maskable interrupt routine. Important stuff goes here!!!
; If you overrund this you did a bad, so don't
AlreadyInNMI:
	; If we got here, we were already in NMI, and it hasn't finished yet
	; Just skip this one and hope we get out of it soon
	JMP ExitNMI

NMI:
	; Save registers
	PHP
	PHA
	TXA
	PHA
	TYA
	PHA
	; NMI code here ...

	LDA NMIWaitFlag		; Are we already in NMI?
	BNE AlreadyInNMI	; If yes, let's just leave now

	; If not, go ahead and mark us as being in it now
	LDA #1
	STA NMIWaitFlag

	; Do PPU writes if needed
	LDA PPUBufferHi
	BNE +
	LDA PPUBufferLo
	BEQ ++
+	JSR UpdatePPUFromBuffer

++	LDA PPUScrollX
	STA PPUSCROLL
	LDA PPUScrollY
	STA PPUSCROLL

	; Otherwise, do stuff we can only do during NMI here
	LDA PPUMaskMirror
	STA PPUMASK


	; Exiting NMI.
	; Restore registers
ExitNMI:
	PLA
	TAY
	PLA
	TAX
	PLA
	PLP
	RTI


WaitXFrames:
	; This assumes you set X to an amount of frames to wait.
	; If you didn't do that you did something dumb.
-	JSR WaitForNMI
	DEX
	BNE -
	RTS



; Wait for the next NMI to hit
WaitForNMI:
	LDA #PPUMask_ShowLeft8Pixels_BG | PPUMask_ShowLeft8Pixels_SPR | PPUMask_ShowBackground | PPUMask_ShowSprites
	STA PPUMaskMirror

	LDA #0
	STA NMIWaitFlag
-	LDA NMIWaitFlag
	BEQ -
	RTS

; -----------------------------------------------------------------------------
ChangeMMC3Bank8000:
	STA	MMC3Bank8000
	PHA
	LDA #$86
	STA $8000
	PLA
	STA $8001
	RTS

ChangeMMC3BankA000:
	STA	MMC3BankA000
	PHA
	LDA #$87
	STA $8000
	PLA
	STA $8001
	RTS




; PPUBufferLo / Hi: Address of PPU data to read from
UpdatePPUFromBuffer:
	LDY #$00
--	LDA (PPUBufferLo), Y		; Get high address...
	BEQ +						; No buffer now, just leave
	LDX PPUSTATUS				; Clear address latch
	STA PPUADDR					; ... store high address
	INY
	LDA (PPUBufferLo), Y		; Get low address...
	STA PPUADDR					; .. store it
	INY
	LDA (PPUBufferLo), Y		; Get length
	TAX							; X = bytes to copy

-	INY							; Start copying...
	LDA (PPUBufferLo), Y		; Load data...
	STA PPUDATA					; ...store into PPU
	DEX							; Decrement bytes left
	BNE -						; If we're not done, continue

	INY
	JMP --						; Otherwise, we're done; check for more data

+	LDA #$00					; Mark the buffer as being done with
	STA PPUBufferLo
	STA PPUBufferHi
	RTS							; Done!


; -----------------------------------------------------------------------------

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




; -----------------------------------------------------------------------------

ClearMemory:
	LDY #$07		; Start from 07XX...
	STY TempAddrHi	; This clears $100 to $7FF.
	LDY #$00
	STY TempAddrLo
	TYA

-	STA (TempAddrLo), Y
	DEY
	BNE -				; Clear XX00-XXFF

	DEC TempAddrHi
	LDX TempAddrHi
	CPX #$01
	BCS -				; Clear 07XX-01XX

-	STA TempAddrLo, Y	; Clear zero page as well...
	INY
	BNE -
	; Memory cleared, start time


Start:
	LDA #PPUMask_None
	STA PPUMASK
	JSR SetUpPPU

	JSR EnableNMI

	LDA #<Palette_Main
	STA PPUBufferLo
	LDA #>Palette_Main
	STA PPUBufferHi

	LDX #60
	JSR WaitXFrames

	LDA #<Text_HelloWorld
	STA PPUBufferLo
	LDA #>Text_HelloWorld
	STA PPUBufferHi

	LDX #240
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
	;   PPU Addr  Len  Data
	.db $3F, $00, $04, $0F, $01, $11, $31
	.db $3F, $08, $04, $0F, $15, $25, $35
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


SetUpPPU:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIDisabled
	STA PPUCTRL
	STA PPUCtrlMirror
	RTS

DisableNMI:
	LDA PPUCtrlMirror
	AND #(#$FF ^ PPUCtrl_NMIEnabled)
	STA PPUCTRL
	STA PPUCtrlMirror
	RTS

EnableNMI:
	LDA PPUCtrlMirror
	ORA #PPUCtrl_NMIEnabled
	STA PPUCtrlMirror
	STA PPUCTRL
	RTS




.include "src/vectors.asm"
