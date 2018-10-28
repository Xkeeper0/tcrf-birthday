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

	JMP ClearRAM

AfterClearRAM:
	LDX #$FF ; Reset stack pointer (again, just to be sure)
	TXS

	LDA #PPUMask_None		; Turn off PPU rendering for now
	STA PPUMASK
	JSR SetUpPPU			; Do some PPU init
	JSR ClearNametables		; Clean out nametable/attrib/palette data
	JSR ClearSprites		; Clean out sprites too

	JSR EnableMMC3ExRAM		; Enable ExRAM (6000-7FFF)
	JSR ClearExRAM			; ...and then clear that too

	LDA #$AA				; Init PRNG seed
	STA PRNGSeed+1

	LDA #%10000000
	STA FunfettiMask

	LDA #$01
	STA FunfettiSpeed

	; Init sound engine
	.include "src/music/engine/ggsound-init.asm"

	JMP Start				; Finally! Onto the main thing we're making!

;
; Clear out the NES's work RAM (0000-07FF)
;
ClearRAM:
	LDA #$00
	LDX #$00

-	STA $0000, X	; Wipe all of the NES's work RAM
	STA $0100, X
	STA $0200, X
	STA $0300, X
	STA $0400, X
	STA $0500, X
	STA $0600, X
	STA $0700, X

	INX
	BNE -

	; Memory cleared, continue init
	; Keep in mind that at this point, we've ERASED THE STACK. It's GONE.
	; There is nothing to RTS to.
	JMP AfterClearRAM


;
; Clear out the MMC3's ExRAM (6000-7FFF)
;
ClearExRAM:
	LDA #$00
	LDX #$00

-	STA $6000, X	; Same as ClearRAM, but 6000-7FFF
	STA $6100, X
	STA $6200, X
	STA $6300, X
	STA $6400, X
	STA $6500, X
	STA $6600, X
	STA $6700, X
	STA $6800, X
	STA $6900, X
	STA $6a00, X
	STA $6b00, X
	STA $6c00, X
	STA $6d00, X
	STA $6e00, X
	STA $6f00, X
	STA $7000, X
	STA $7100, X
	STA $7200, X
	STA $7300, X
	STA $7400, X
	STA $7500, X
	STA $7600, X
	STA $7700, X
	STA $7800, X
	STA $7900, X
	STA $7a00, X
	STA $7b00, X
	STA $7c00, X
	STA $7d00, X
	STA $7e00, X
	STA $7f00, X

	INX
	BNE -

	; As this one hasn't annihilated the stack,
	; we can return like a normal subroutine!
	RTS
