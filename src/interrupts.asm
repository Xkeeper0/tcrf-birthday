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
	LDA PPUCtrlMirror
	ORA #PPUCtrl_NMIEnabled
	STA PPUCtrlMirror
	STA PPUCTRL
	RTS


; Wait for the next NMI to hit
WaitForNMI:
	LDA #PPUMask_ShowLeft8Pixels_BG | PPUMask_ShowLeft8Pixels_SPR | PPUMask_ShowBackground | PPUMask_ShowSprites
	STA PPUMaskMirror

	LDA #0
	STA NMIWaitFlag
-	LDA NMIWaitFlag
	BEQ -
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
