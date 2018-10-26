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

	JSR EnableMMC3ExRAM		; Enable ExRAM (6000-7FFF)
	JSR ClearExRAM			; ...and then clear that too

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


;
; Clear the nametables of all data for that
; fresh new PPU scent
; You should have already turned off NMIs and PPU rendering before getting here
; If you don't, you will experience a lot of very fun and interesting problems
;
ClearNametables:
	LDA PPUSTATUS			; Reset PPU address latch
	LDA #$20				; PPU address high byte
	STA PPUADDR
	LDA #$00				; PPU address low byte
	STA PPUADDR

	; Write 00 to all nametables
	LDA #$00				; Tile index to write
	LDY #$0F				; Bytes to write x #$100
	LDX #$00				; Counter

-	STA PPUDATA				; Write tile
	DEX
	BNE -					; Loop #$100 times (256 tiles)
	DEY
	BNE -					; Loop 8 x #$100 times

	; Clear attributes
	LDA PPUSTATUS			; Reset address latch again
	LDA #$3F				; Palette RAM (3F00-3F1F)
	STA PPUADDR
	LDA #$00
	STA PPUADDR

	LDA #$0F				; Black color
	LDX #$20				; 4 x 4 x 2 palettes
-	STA PPUDATA
	DEX
	BNE -

	; PPU memory should be all nice and clean now
	RTS


;
; Set the default PPU stuff we'll be using here (but leave NMI off)
;
SetUpPPU:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIDisabled
	STA PPUCTRL
	STA PPUCtrlMirror
	RTS
