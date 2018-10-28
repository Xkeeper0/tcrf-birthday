song_index_mus_totaka = 0

sfx_index_sfx_null = 0

song_list:
  .dw _mus_totaka

sfx_list:
  .dw _sfx_null

instrument_list:
  .dw _Blong_0
  .dw silent_1

_Blong_0:
  .db 5,22,24,27,ARP_TYPE_ABSOLUTE
  .db 8,7,7,6,6,5,5,4,4,3,3,2,2,1,1,0,ENV_STOP
  .db 0,ENV_STOP
  .db 128,64,DUTY_ENV_STOP
  .db ENV_STOP

silent_1:
  .db 5,7,9,11,ARP_TYPE_ABSOLUTE
  .db 0,ENV_STOP
  .db 0,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_mus_totaka:
  .db 0
  .db 5
  .db 42
  .db 4
  .dw _mus_totaka_square1
  .dw 0
  .dw 0
  .dw 0
  .dw 0

_mus_totaka_square1:
_mus_totaka_square1_loop:
  .db CAL,<(_mus_totaka_square1_0),>(_mus_totaka_square1_0)
  .db CAL,<(_mus_totaka_square1_1),>(_mus_totaka_square1_1)
  .db GOT
  .dw _mus_totaka_square1_loop

_mus_totaka_square1_0:
  .db STI,0,SL6,C3,SL1,C3,D3,SL5,E3,SL3,D3,SL8,C3,G3,E3,C4,SL0
  .db G3
  .db RET

_mus_totaka_square1_1:
  .db STI,0,SL6,G3,SL1,G3,GS3,SL5,G3,SL3,FS3,SL0,DS3,SLC,D3,G3
  .db SL8,C3
  .db RET

_sfx_null:
  .db 0, 1
  .db 0, 1
  .dw 0
  .dw 0
  .dw 0
  .dw 0
  .dw 0

