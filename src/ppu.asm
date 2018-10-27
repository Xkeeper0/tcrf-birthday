;
; PPU control functions and helpers and whatnot
;

; Turn PPU rendering on or off, in the event we're
; doing some stupid stuff
EnablePPURendering:
	LDA #PPUMask_ShowLeft8Pixels_BG | PPUMask_ShowLeft8Pixels_SPR | PPUMask_ShowBackground | PPUMask_ShowSprites
	BNE +

DisablePPURendering:
	LDA #PPUMask_None
+	STA PPUMaskMirror
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
; Shove all sprites offscreen so they aren't visible
;
ClearSprites:
	LDA #$F8				; New Y position for sprites (offscreen)
	LDY #$00				; Sprite hiding index
-	STA SpriteY, Y			; Write to our sprite Y positions
	DEY
	DEY
	DEY
	DEY
	BNE -					; Loop until we set all sprites offscreen
	RTS


;
; Set the default PPU stuff we'll be using here (but leave NMI off)
;
SetUpPPU:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x8 | PPUCtrl_NMIDisabled
	STA PPUCTRL
	STA PPUCtrlMirror
	RTS
