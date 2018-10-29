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
+	LDA #0					; Clear the flag for NMI having run
	STA NMIWaitFlag			; Then wait for NMI to set it again
-	LDA NMIWaitFlag
	BEQ -
	RTS						; NMI ran, all over


;
; Read joypad (just player one, we don't care about P2 or whatever)
; Normally if you're using DPCM samples you have to use multiple reads,
; since DPCM reads will "helpfully" corrupt input sometimes
; Thankfully we're not using DPCM samples so we don't have to caaaareeeeeee
; At the same time that we strobe bit 0, we initialize the ring counter
; so we're hitting two birds with one stone here
; Code unabashedly stolen from nesdev's controller reading page
;
UpdateJoypad:
	; While the strobe bit is set, buttons will be continuously reloaded.
	; This means that reading from JOY1 will only return the state of the
	; first button: button A.
	LDA #$01
	STA JOY1
	STA Player1JoypadPress
	LSR A        ; now A is 0
	; By storing 0 into JOY1, the strobe bit is cleared and the reloading stops.
	; This allows all 8 buttons (newly reloaded) to be read from JOY1.
	STA JOY1
-	LDA JOY1
	LSR A					; bit0 -> Carry
	ROL Player1JoypadPress	; Carry -> bit0; bit 7 -> Carry
	BCC -
	; At this point, Temp0002 has the full P1 joypad read in it ...

	LDA Player1JoypadPress			; Load current buttons...
	TAY								; ...save them to Y for later`
	EOR Player1JoypadHeld			; XOR previous held buttons
	AND Player1JoypadPress			; I may not need to use Temp0002 at all
	STA Player1JoypadPress			; Store only new buttons
	STY Player1JoypadHeld			; Everything down is held, too

	RTS
