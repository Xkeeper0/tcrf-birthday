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


;
; Macro to set the PPU buffer address without having to
; remember all those pesky 8 bit marker referenes and such
;
MACRO SetPPUBuffer addr
	LDA #<addr
	STA PPUBufferLo
	LDA #>addr
	STA PPUBufferHi
	LDA #$1
	STA PPUBufferReady
ENDM

;
; Simple macro to run WaitForNMI a while
;
MACRO DelayFrames f
	LDX f
	;LDX #2
	JSR WaitXFrames
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

MACRO TS_Scroll l
	.db TextScript_Scroll, l
ENDM

MACRO TS_Text s
	.db s
ENDM

MACRO TS_NewLine
	.db TextScript_AdvanceLine
ENDM

MACRO TS_End
	.db TextScript_End
ENDM
