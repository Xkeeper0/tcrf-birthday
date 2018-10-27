; Various PPU stuff
VMirror = $00
HMirror = $01
NametableMapping = $A000


TextScript_NewAddress   = $FC
TextScript_ChangeSpeed  = $FD
TextScript_DoDelay      = $FE
TextScript_End          = $FF


; Controller input stuff
ControllerInput_Right  = %00000001
ControllerInput_Left   = %00000010
ControllerInput_Down   = %00000100
ControllerInput_Up     = %00001000
ControllerInput_Start  = %00010000
ControllerInput_Select = %00100000
ControllerInput_B      = %01000000
ControllerInput_A      = %10000000

; -----------------------------------------------
; Sprite stuff
SpriteAttrib_Palette0  = %00000000
SpriteAttrib_Palette1  = %00000001
SpriteAttrib_Palette2  = %00000010
SpriteAttrib_Palette3  = %00000011
; Unused bits ...            |||
SpriteAttrib_Priority  = %00100000
SpriteAttrib_FlipX     = %01000000
SpriteAttrib_FlipY     = %10000000

; -----------------------------------------------
; PPU stuff

; PPUStatus flags
PPUStatus_SpriteOverflow    = %00100000
PPUStatus_Sprite0Hit        = %01000000
PPUStatus_VBlankHit         = %10000000

; PPUMask flags
PPUMask_None                = %00000000
PPUMask_Grayscale           = %00000001
PPUMask_ShowLeft8Pixels_BG  = %00000010
PPUMask_ShowLeft8Pixels_SPR = %00000100
PPUMask_ShowBackground      = %00001000
PPUMask_ShowSprites         = %00010000
PPUMask_RedEmphasis         = %00100000
PPUMask_GreenEmphasis       = %01000000
PPUMask_BlueEmphasis        = %10000000

; PPUCtrl flags and such
PPUCtrl_BaseAddress     = $03
PPUCtrl_Base2000        = $00
PPUCtrl_Base2400        = $01
PPUCtrl_Base2800        = $02
PPUCtrl_Base2C00        = $03
PPUCtrl_WriteHorizontal = $00
PPUCtrl_WriteVertical   = $04
PPUCtrl_Sprite0000      = $00
PPUCtrl_Sprite1000      = $08
PPUCtrl_Background0000  = $00
PPUCtrl_Background1000  = $10
PPUCtrl_SpriteSize8x8   = $00
PPUCtrl_SpriteSize8x16  = $20
PPUCtrl_NMIDisabled     = $00
PPUCtrl_NMIEnabled      = $80
