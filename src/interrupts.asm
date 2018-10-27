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

	; Update sprites/OAM
	LDA #$02
	STA OAM_DMA

	; Do PPU writes if needed
	LDA PPUBufferHi
	BNE +
	LDA PPUBufferLo
	BEQ ++
+	JSR UpdatePPUFromBuffer

++	LDA PPUScrollX
	STA PPUSCROLL
	LDA PPUScrollY
	STA PPUSCROLL

	; Otherwise, do stuff we can only do during NMI here
	LDA PPUMaskMirror
	STA PPUMASK
	LDA PPUCtrlMirror
	STA PPUCTRL

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


DisableNMI:
	LDA PPUCtrlMirror
	AND #(#$FF ^ PPUCtrl_NMIEnabled)
	STA PPUCTRL
	STA PPUCtrlMirror
	RTS

EnableNMI:
	LDA PPUSTATUS						; Clear possible vblank flag
	LDA PPUCtrlMirror
	ORA #PPUCtrl_NMIEnabled
	STA PPUCtrlMirror
	STA PPUCTRL
	RTS


; Wait for the next NMI to hit
WaitForNMI:
	LDA #0
	STA NMIWaitFlag
-	LDA NMIWaitFlag
	BEQ -
	RTS
