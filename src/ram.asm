
; RAM addresses for stuff
TempAddrLo:		.dsb 1
TempAddrHi:		.dsb 1
Temp0002:		.dsb 1
Temp0003:		.dsb 1
NMIWaitFlag:	.dsb 1
PPUCtrlMirror:	.dsb 1
PPUMaskMirror:	.dsb 1
MMC3Bank8000:	.dsb 1
MMC3BankA000:	.dsb 1


; PPU registers
; $2000-$2007

PPUCTRL    = $2000
PPUMASK    = $2001
PPUSTATUS  = $2002
OAMADDR    = $2003
OAMDATA    = $2004
PPUSCROLL  = $2005
PPUADDR    = $2006
PPUDATA    = $2007

; APU registers and joypad registers
;  $4000-$4015         $4016-$4017

SQ1_VOL    = $4000
SQ1_SWEEP  = $4001
SQ1_LO     = $4002
SQ1_HI     = $4003

SQ2_VOL    = $4004
SQ2_SWEEP  = $4005
SQ2_LO     = $4006
SQ2_HI     = $4007

TRI_LINEAR = $4008
_APU_TRI_UNUSED = $4009
TRI_LO     = $400a
TRI_HI     = $400b

NOISE_VOL  = $400c
_APU_NOISE_UNUSED = $400d
NOISE_LO   = $400e
NOISE_HI   = $400f

DMC_FREQ   = $4010
DMC_RAW    = $4011
DMC_START  = $4012
DMC_LEN    = $4013

OAM_DMA    = $4014

SND_CHN    = $4015

JOY1       = $4016
JOY2       = $4017
