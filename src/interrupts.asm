; -----------------------------------------------------------------------------
; If we end up here something probably went wrong, oops
IRQ:
	JSR DisableNMI
	SEC
-	BCS -
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

	INC FrameCounter

	JSR UpdatePRNG

	; Otherwise, do stuff we can only do during NMI here
	LDA PPUMaskMirror
	STA PPUMASK
	LDA PPUCtrlMirror
	STA PPUCTRL

	; Update sound engine
	soundengine_update

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


;
; Wait for the next NMI to hit
; If you call this and NMIs are disabled, you have done something
; really, really stupid. Don't do that.
;
WaitForNMI:
	LDA FunfettiEnable		; Is the confetti enabled?
	BEQ +					; If so, go ahead and...
	JSR AnimateConfetti		; ...update the confetti.
	JSR UpdateJoypad		; Update joypad this frame, too
	JSR CheckCheatCodes		; What better place to do this than here?
+	LDA #0					; Clear the flag for NMI having run
	STA NMIWaitFlag			; Then wait for NMI to set it again
-	LDA NMIWaitFlag
	BEQ -
	RTS						; NMI ran, all over
