;
; Palettes used, stored here for... some reason.
; Probably. It made sense at the time.
;
Palette_Main:
	;   PPU Addr  Len
	.db $3F, $00, $20
	.db $0F, $00, $10, $30 ; BG 0
	.db $0F, $09, $19, $38 ; BG 1
;	.db $0F, $0F, $0F, $0F ; BG 1
	.db $0F, $05, $15, $35 ; BG 2
	.db $0F, $07, $17, $37 ; BG 3
	.db $0F, $08, $29, $38 ; SP 0
;	.db $0F, $0F, $0F, $0F ; SP 0
	.db $0F, $06, $26, $30 ; SP 1
	.db $0F, $1a, $2a, $30 ; SP 2
	.db $0F, $12, $22, $30 ; SP 3
	.db $00 ; End

Palette_Fade0:
	;   PPU Addr  Len
	.db $3F, $05, $03, $0F, $0F, $0F ; BG 1
	.db $3F, $11, $03, $0F, $0F, $0F ; SP 0
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


Palette_TextFade0:
	;   PPU Addr  Len
	.db $3F, $00, $4
	.db $0F, $0F, $0F, $0F ; BG 0
	.db $00 ; End

Palette_TextFade1:
	;   PPU Addr  Len
	.db $3F, $00, $4
	.db $0F, $0F, $0F, $00 ; BG 0
	.db $00 ; End

Palette_TextFade2:
	;   PPU Addr  Len
	.db $3F, $00, $4
	.db $0F, $0F, $00, $10 ; BG 0
	.db $00 ; End

Palette_TextFade3:
	;   PPU Addr  Len
	.db $3F, $00, $4
	.db $0F, $00, $10, $30 ; BG 0
	.db $00 ; End
