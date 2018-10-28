; tcrf9yrs.nes
; ============
; TCRF 9 year birthday ROM
; Maybe it'll even be done in time!
;
; The Cutting Room Floor wiki turns 9 years old
; on October 25, 2018
; The actual website itself is much older, but
; nobody is quiiiite sure when it started...


; -----------------------------------------
; Add NES header
	.db "NES", $1a ; identification of the iNES header
	.db 2 ; number of 16KB PRG-ROM pages
	.db 2 ; number of 8KB CHR-ROM pages

	.db $40 ; mapper and mirroring
	.dsb 9, $00 ; clear the remaining bytes


; -----------------------------------------
; Add definitions
.enum $0000
.include "src/defs.asm"
.ende

; Add RAM definitions
.enum $0000
.include "src/ram.asm"
.ende

.include "src/macros.asm"

; -----------------------------------------
; Program bank 0
.base $8000
.include "src/prg-0.asm"
.pad $a000, #$F0
; -----------------------------------------
; Program bank 1
.base $a000
.include "src/prg-1.asm"
.pad $c000, #$F1

; -----------------------------------------
; Program bank 2
.base $c000
.include "src/prg-2.asm"
.pad $e000, #$F2

; -----------------------------------------
; Program bank 3
.base $e000
.include "src/prg-3.asm"
.include "src/vectors.asm"



; -----------------------------------------
; include CHR-ROM
.incbin "src/tcrf9yrs.chr"
