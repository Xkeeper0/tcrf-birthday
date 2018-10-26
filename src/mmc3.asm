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


;
; Disabling the MMC3 IRQ is done by writing any value to any EVEN address
; within the range $E000-$FFFF.
; Enabling it is done by writing to ODD addresses.
; Since it works on just writing anything, we don't have to care
; what's actually stored in A at all!
;
DisableMMC3Interrupts:
	STA $E000
	RTS

;
; Enable extended RAM at 6000-7FFF
;
EnableMMC3ExRAM:
	LDA #$80
	STA $A001
	RTS
