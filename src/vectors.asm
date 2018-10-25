; Ensure our vectors are always here
	.pad $FFFA, $FF

; Vectors for the NES CPU. These should ALWAYS be at $FFFA!
; NMI = VBlank
; RESET = ...well, reset.
; IRQ is where the CPU goes when it has problems.
NESVectorTables:
	.dw NMI
	.dw RESET
	.dw IRQ
