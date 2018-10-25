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
	LDA #VMirror
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

	JMP DoNothing


DoNothing:
	JSR WaitForNMI
	JMP DoNothing





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
