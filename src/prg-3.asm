
.include "src/init.asm"
.include "src/interrupts.asm"
.include "src/ppu.asm"
.include "src/mmc3.asm"
.include "src/textscript.asm"


WaitXFrames:
	; This assumes you set X to an amount of frames to wait.
	; If you didn't do that you did something dumb.
	STX FramesToWait
-	JSR WaitForNMI
	DEC FramesToWait
	BNE -
	RTS


Start:
	JSR DisableNMI				; Turn off NMI while we're busy
	JSR DisablePPURendering		; And that pesky PPU too

	JSR DrawCactus
	JSR AddCactusSprites

	SetPPUBuffer Palette_Main			; Update our fancy palettes
	JSR UpdatePPUFromBuffer

	SetPPUBuffer Palette_Fade0			; Then manually blank some colors

	JSR EnableNMI						; Enable NMIs and wait
	JSR WaitForNMI						; (loads initial palette)
	JSR EnablePPURendering				; now turn on the PPU proper
	DelayFrames #30						; then wait a second

	LDA #song_index_mus_tcrf			; Play our cool song
	STA sound_param_byte_0
	JSR play_song
	DelayFrames #140

	SetPPUBuffer Palette_Fade1			; Fade in the cactus
	DelayFrames #10

	SetPPUBuffer Palette_Fade2			; Brighter...
	DelayFrames #10

	SetPPUBuffer Palette_Fade3			; BRIGHTER!
	DelayFrames #10

	SetPPUBuffer Palette_Fade4			; BRIGHTER!!!!
	DelayFrames #90					; (actually fully bright now)

	JMP +

	TextScript TScript_HappyBirthday	; Announce birthday
	INC FunfettiEnable					; Turn on the funfetti
	DelayFrames #240					; Wait a while
	DelayFrames #118					; Wait more (8-bit, bah!)
	TextScript TScript_DateOfBirth		; Show the dates now

	; Let's wait a few seconds...
	DelayFrames #240					; 4 seconds
	DelayFrames #145					; 4 seconds
	;DelayFrames #120					; 2 seconds
	; someone please explain to me why, when debugging,
	; i am intentionally inserting 10 second waits
	; instead of just testing if it works first
	; im coder
+	JSR SlideScreenUpwards

	; Clear out the attribute tiles
	; The text was cleared out by SlideScreenUpwards
	LDX #$00
	LDA #$1E
	JSR ClearOneTileRow
	JSR WaitForNMI
	LDX #$00
	LDA #$1F
	JSR ClearOneTileRow
	JSR WaitForNMI


	; ----------------------------------------------------
	; Clearing the page of all the art and text, because... yeah
	;JSR DisablePPURendering		; And that pesky PPU too
	;JSR WaitForNMI
	;JSR DisableNMI				; Turn off NMI while we're busy

	;JSR ClearNametables			; Clear out the cacti and attribs

	;SetPPUBuffer Palette_Main			; Set up to write our main pal

	LDA #$00
	STA PPUScrollY


	;JSR EnablePPURendering				; now turn on the PPU proper
	;JSR EnableNMI						; Enable NMIs and wait

	JSR PutSpritesBehindBackground

	JSR WaitForNMI						; (loads initial palette)
	; OK, all done -- we have a clean slate again, more or less
	; ----------------------------------------------------

	JMP +
	; Temp draw some text to make sure we haven't fucked it all up again
	TextScript TScript_Milestones

	DelayFrames #180					; Five seconds or so
	DelayFrames #120

	SetPPUBuffer Palette_TextFade3		; Fade out text...
	DelayFrames #10

	SetPPUBuffer Palette_TextFade2		; Fade out text...
	DelayFrames #10

	SetPPUBuffer Palette_TextFade1		; Fade out text...
	DelayFrames #10

	SetPPUBuffer Palette_TextFade0		; Fade out text...
	JSR WaitForNMI

	LDA #$1D
	STA FramesToWait
-	LDA FramesToWait
	JSR ClearOneTileRow
	JSR WaitForNMI
	DEC FramesToWait
	BPL -

	LDA #$8A
	STA FramesToWait
-	LDA FramesToWait
	JSR ClearOneTileRow
	JSR WaitForNMI
	DEC FramesToWait
	BMI -

+	; Temp draw some text to make sure we haven't fucked it all up again
	TextScript TScript_Milestones2


	DelayFrames #240
	; Hey, all done with that now! wowzers

	JMP DoNothing



;
; Do nothing! Somewhat misleading because NMI still does things,
; and the WaitForNMI func does some things too.
; But mostly it doesn't do anything of its own.
;
DoNothing:
	JSR WaitForNMI
	JMP DoNothing





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


;
; Check for input of our Very Secret Cheats.
; B + A + D(own): Sara Parker's Poo(l) Challenge reference
; ??????????????: :-)
;
CheckCheatCodes:

	LDA FunfettiSpeed				; Did we already do this code?
	BEQ +							; If yes, don't bother checking again

	LDA Player1JoypadHeld			; Get our held buttons right now
	CMP #CheatCode_PooChallenge		; Check if we're holding them buttons
	BNE +							; Cheat code not entered, welp

	LDA #%11000000					; Time to do the effects of this cheat...
	STA FunfettiMask				; Yep.
	LDA #$00						; For those of you in our home audience,
	STA FunfettiSpeed				; this is a sort of running gag we have

+	RTS

;
; Animate the confetti every frame, moving it down and changing its tile
; This also "resets" the confetti when it hits the bottom, giving it
; a new tile and X position once it wraps around
; (alternatively, they become pool balls instead)
;
AnimateConfetti:
	LDA FrameCounter			; We update the animation every ~4 frames
	AND #$03
	TAY

	LDX #$7F					; Sprites to animate x 4 bytes per sprite
-	DEX							; We skip the attribute and X bytes,
	DEX							; since we only care about the tile
	DEY							; and the Y position.
	BNE +						; (If ! an anim update frame, skip)
	LDA SpriteDMAArea, X		; Get the current tile index
	PHA							; Make a quick copy...
	AND #%11111000				; ...so we can erase the animation number.
	STA Temp0002				; ...and put it here for a bit.
	PLA							; Now get the copy again...
	CLC							; Then clear carry...
	ADC #$01					; ...so we can add one.
	AND #%00000111				; ...and mask off only the animation number.
	ORA Temp0002				; Mix it back in with the tile index...
	STA SpriteDMAArea, X		; ...and then store the full thing back.
	LDY #$03
+	DEX							; Decrement to edit sprite Y positions...
	LDA FrameCounter
	AND FunfettiSpeed
	BNE +
	INC	SpriteDMAArea, X		; ...and increment it by one.
	BNE +
	LDA PRNGSeed+2				; Get a random byte...
	STA SpriteDMAArea+3, X		; ...store it as the new X position
	LDA PRNGSeed+3				; Get another random byte...
	AND #%00111111				; ...get only the lower 6 bits...
	ORA FunfettiMask			; ...OR it with the funfetti gfx range...
	STA SpriteDMAArea+1, X		; ...and store the new anim frame.
+	DEX
	BPL -
	RTS							; Once we've updated all funfetti, we're done.



;
; Draw the cactus background to the nametable
; You should probably make sure NMI is disabled first.
; It would be smart to just do it in here, but smart is
; not my name. honk
;
DrawCactus:
	LDA PPUSTATUS				; Flush PPU address latch
	LDA #$20					; PPU address, high
	STA PPUADDR
	LDA #$00					; PPU address, low
	STA PPUADDR

	LDA #<CactusNametable		; Low address of cactus nametable data
	STA TempAddrLo
	LDA #>CactusNametable		; High address of cactus nametable data
	STA TempAddrHi

	LDX #$04					; Copying $400 bytes
--	LDY #$00

-	LDA (TempAddrLo), Y			; Get a byte of data...
	STA PPUDATA					; ...stuff it into PPU
	INY
	BNE -						; Continue until we wrap Y...

	INC TempAddrHi				; Increase the read address...
	DEX							; Decrement the read count...
	BNE --						; If still more, keep going.

	RTS							; All done


;
; Add the cacti additional color overlay sprites to the screen
;
AddCactusSprites:
	LDA #<ConfettiSprites
	STA TempAddrLo
	LDA #>ConfettiSprites
	STA TempAddrHi
	LDY #$00					; Copying another 100 bytes here

-	LDA (TempAddrLo), Y			; Copy our sprites in
	STA SpriteDMAArea, Y
	INY
	BNE -						; Repeat until all copied
	RTS


;
; Updates the PRNG we stole off of Nesdev
; Unlike the original one, this stores some old values in
; PRNGSeed+2 and +3 so that we can use them later, instead
; of generating new ones every time
; (of course, we could end up *re*using them, but right now
; this isn't a concern because they're for confetti only.)
;
UpdatePRNG:
	LDA PRNGSeed+2	; Keep the last two generated bytes for use later
	STA PRNGSeed+3
	LDA PRNGSeed+0
	STA PRNGSeed+2

	LDX #8     ; iteration count (generates 8 bits)
	LDA PRNGSeed
-
	ASL        ; shift the register
	ROL PRNGSeed+1
	BCC +
	EOR #$2D   ; apply XOR feedback whenever a 1 bit is shifted out
+
	DEX
	BNE -
	STA PRNGSeed
	CMP #0     ; reload flags
	RTS




;
; Slides the screen (and the cactus overlay sprites) up and off the
; visible screen area. Could probably be cleaned up as it scrolls up too
; but that's too much effort for right now
;
SlideScreenUpwards:
	; Get current Y scroll position
	; AND low 3 bytes (8 pixels)
	; if != 0, do nothing
	; otherwise, calc what ppu row to erase
	LDA PPUScrollY				; Check if it's still within range
	AND #%00000111				; Mask off only the low 3 bits (0-7)
	CMP #$00					; Are we at an even pixel row?
	BNE +						; If not, skip this part

	; Erase tiles with stuff
	LDA PPUScrollY				; Reload the scroll buffer
	AND #%11111000				; Now mask off the OTHER bits!
	LSR							; Shift right for our new address
	LSR
	LSR
	LDX #$00
	JSR ClearOneTileRow			; Clear our row of tiles here...

	; Get current Y scroll position
	; Check if we should continue scrolling
+	LDA PPUScrollY				; Check if it's still within range
	CMP #$EF					; Beyond #$EF = rolls over, oops
	BEQ ++						; So if we're at #$EF we're done
	INC PPUScrollY

	; Update all the cactus sprites
+	LDX #$9C					; Offset of first overlay sprite

-	LDA SpriteDMAArea, X		; Load the sprite Y position
	CMP #$F8					; Are we at the bottom already?
	BEQ +						; Yeah, skip this one
	DEC SpriteDMAArea, X		; Otherwise nudge up down by one
+	INX							; Move to next sprite's Y position
	INX
	INX
	INX
	BNE -						; Done updating sprites

	; Done updating sprites and nametable, wait a frame
	JSR WaitForNMI
	JMP SlideScreenUpwards

++	RTS							; Screen should be scrolled now! Bye!!











; -----------------------------------------------
; -----------------------------------------------
; Data in various forms lives down here
; (please keep the lid closed)

.include "src/data/palettes.asm"
.include "src/textscripts.asm"

CactusNametable:
	.incbin "src/data/cactus-nametable.bin"

ConfettiSprites:
	.incbin "src/data/funfetti-blank.bin"
