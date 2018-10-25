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
	BEQ +
	JSR UpdatePPUFromBuffer
+

	LDA PPUScrollX
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

	LDA #$00					; Mark the buffer as being done with
	STA PPUBufferLo

+	RTS							; Done!



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
	JSR WaitForNMI

	LDA #<Text_HelloWorld
	STA PPUBufferLo
	LDA #>Text_HelloWorld
	STA PPUBufferHi
	JSR WaitForNMI

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
	.db $22, $28, 19, "Trapped in NES ROM,"
	.db $22, $48, 19, "    send  help!    "
	.db $00 ; End


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
