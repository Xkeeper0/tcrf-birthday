;
; Macros
;

; Convert simple X/Y coordinates to PPU addresses
; (assumes 0, 0 scroll position)
MACRO PPUPos y, x
	@temp = #$2000 + (y << 5) + x
	.db #>@temp, #<@temp
ENDM

MACRO PPUDat data
	@temp	= $
	.db @len, data
	@len	= $ - @temp - 1
ENDM




MACRO TextScript addr
	LDA #<addr
	STA TextScriptLo
	LDA #>addr
	STA TextScriptHi
	JSR DoTextScript
ENDM

MACRO TS_NewPos y, x
	.db TextScript_NewAddress
	PPUPos y, x
ENDM

MACRO TS_NewAddress addr
	.db TextScript_NewAddress, #>addr, #<addr
ENDM

MACRO TS_Delay f
 	.db TextScript_DoDelay, f
ENDM

MACRO TS_Speed s
	.db TextScript_ChangeSpeed, s
ENDM
