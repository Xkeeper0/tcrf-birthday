song_index_mus_tcrf = 0

sfx_index_sfx_null = 0

song_list:
  .dw _mus_tcrf

sfx_list:
  .dw _sfx_null

instrument_list:
  .dw _Blong_0
  .dw _Vib2d50_1
  .dw _tri_2
  .dw _short_tri_3
  .dw _closed_hat_4
  .dw _crash_cym_5
  .dw _open_hat_6
  .dw _Strum_7
  .dw _Blong_28rel29_8
  .dw _Vib2d50_28229_9
  .dw _fadein_10
  .dw _fadin_arp_11
  .dw _Strum_28rel29_12
  .dw _noisything_13
  .dw _kicknohi_14
  .dw _snarenohi_15
  .dw _kick_tri_16
  .dw _Blong2dup_17
  .dw _Blong2dup_28rel29_18
  .dw silent_19

_Blong_0:
  .db 5,22,24,27,ARP_TYPE_ABSOLUTE
  .db 15,13,13,11,11,9,9,7,7,5,5,3,3,1,1,0,ENV_STOP
  .db 0,ENV_STOP
  .db 128,64,DUTY_ENV_STOP
  .db ENV_STOP

_Vib2d50_1:
  .db 5,12,46,49,ARP_TYPE_ABSOLUTE
  .db 15,15,11,11,7,7,ENV_STOP
  .db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-2,0,0,0,2,0,0,0,ENV_LOOP,36
  .db 64,128,DUTY_ENV_STOP
  .db ENV_STOP

_tri_2:
  .db 5,7,9,11,ARP_TYPE_ABSOLUTE
  .db 15,ENV_STOP
  .db 0,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_short_tri_3:
  .db 5,13,15,17,ARP_TYPE_ABSOLUTE
  .db 15,15,15,15,15,15,0,ENV_STOP
  .db 0,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_closed_hat_4:
  .db 5,11,13,15,ARP_TYPE_ABSOLUTE
  .db 8,6,4,2,0,ENV_STOP
  .db 0,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_crash_cym_5:
  .db 5,37,39,41,ARP_TYPE_ABSOLUTE
  .db 8,8,7,7,7,7,6,6,6,6,5,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,ENV_STOP
  .db 0,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_open_hat_6:
  .db 5,22,24,26,ARP_TYPE_ABSOLUTE
  .db 8,7,7,6,6,5,5,4,4,3,3,2,2,1,1,0,ENV_STOP
  .db 0,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_Strum_7:
  .db 5,22,24,27,ARP_TYPE_ABSOLUTE
  .db 15,13,13,11,11,9,9,7,7,5,5,3,3,1,1,0,ENV_STOP
  .db 0,ENV_STOP
  .db 64,0,DUTY_ENV_STOP
  .db ENV_STOP

_Blong_28rel29_8:
  .db 5,22,24,27,ARP_TYPE_ABSOLUTE
  .db 15,13,13,11,11,9,9,7,7,7,7,5,5,5,5,3,ENV_STOP
  .db 0,ENV_STOP
  .db 128,64,DUTY_ENV_STOP
  .db ENV_STOP

_Vib2d50_28229_9:
  .db 5,22,56,59,ARP_TYPE_ABSOLUTE
  .db 15,13,13,11,11,9,9,7,7,7,7,5,5,5,5,3,ENV_STOP
  .db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-2,0,0,0,2,0,0,0,ENV_LOOP,46
  .db 64,128,DUTY_ENV_STOP
  .db ENV_STOP

_fadein_10:
  .db 5,21,23,25,ARP_TYPE_ABSOLUTE
  .db 0,0,0,0,1,1,3,3,5,5,7,7,9,9,11,ENV_STOP
  .db 0,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_fadin_arp_11:
  .db 5,21,23,25,ARP_TYPE_ABSOLUTE
  .db 0,0,0,0,1,1,3,3,5,5,7,7,9,9,11,ENV_STOP
  .db 0,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db 0,0,4,4,7,7,ENV_LOOP,25

_Strum_28rel29_12:
  .db 5,22,56,59,ARP_TYPE_ABSOLUTE
  .db 15,13,13,11,11,9,9,7,7,7,7,5,5,5,5,3,ENV_STOP
  .db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-2,0,0,0,2,0,0,0,ENV_LOOP,46
  .db 64,0,DUTY_ENV_STOP
  .db ENV_STOP

_noisything_13:
  .db 5,15,21,23,ARP_TYPE_ABSOLUTE
  .db 8,8,6,6,4,4,2,2,0,ENV_STOP
  .db 0,0,0,0,-2,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_kicknohi_14:
  .db 5,14,16,18,ARP_TYPE_ABSOLUTE
  .db 13,10,7,4,2,1,0,0,ENV_STOP
  .db 0,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_snarenohi_15:
  .db 5,14,16,18,ARP_TYPE_ABSOLUTE
  .db 15,11,7,4,3,2,1,0,ENV_STOP
  .db 0,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_kick_tri_16:
  .db 5,13,19,21,ARP_TYPE_ABSOLUTE
  .db 15,15,15,15,15,15,0,ENV_STOP
  .db 0,24,48,72,96,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_Blong2dup_17:
  .db 5,22,26,29,ARP_TYPE_ABSOLUTE
  .db 15,13,13,11,11,9,9,7,7,5,5,3,3,1,1,0,ENV_STOP
  .db 16,0,-16,ENV_STOP
  .db 128,64,DUTY_ENV_STOP
  .db ENV_STOP

_Blong2dup_28rel29_18:
  .db 5,22,34,37,ARP_TYPE_ABSOLUTE
  .db 15,13,13,11,11,9,9,7,7,7,7,5,5,5,5,3,ENV_STOP
  .db 16,0,0,-4,0,-4,0,-4,0,-4,0,ENV_STOP
  .db 128,64,DUTY_ENV_STOP
  .db ENV_STOP

silent_19:
  .db 5,7,9,11,ARP_TYPE_ABSOLUTE
  .db 0,ENV_STOP
  .db 0,ENV_STOP
  .db 0,DUTY_ENV_STOP
  .db ENV_STOP

_mus_tcrf:
  .db 0
  .db 4
  .db 85
  .db 3
  .dw _mus_tcrf_square1
  .dw 0
  .dw _mus_tcrf_triangle
  .dw _mus_tcrf_noise
  .dw 0

_mus_tcrf_square1:
  .db CAL,<(_mus_tcrf_square1_4),>(_mus_tcrf_square1_4)
  .db CAL,<(_mus_tcrf_square1_5),>(_mus_tcrf_square1_5)
_mus_tcrf_square1_loop:
  .db CAL,<(_mus_tcrf_square1_0),>(_mus_tcrf_square1_0)
  .db CAL,<(_mus_tcrf_square1_1),>(_mus_tcrf_square1_1)
  .db CAL,<(_mus_tcrf_square1_2),>(_mus_tcrf_square1_2)
  .db CAL,<(_mus_tcrf_square1_3),>(_mus_tcrf_square1_3)
  .db GOT
  .dw _mus_tcrf_square1_loop

_mus_tcrf_triangle:
  .db CAL,<(_mus_tcrf_triangle_4),>(_mus_tcrf_triangle_4)
  .db CAL,<(_mus_tcrf_triangle_5),>(_mus_tcrf_triangle_5)
_mus_tcrf_triangle_loop:
  .db CAL,<(_mus_tcrf_triangle_0),>(_mus_tcrf_triangle_0)
  .db CAL,<(_mus_tcrf_triangle_1),>(_mus_tcrf_triangle_1)
  .db CAL,<(_mus_tcrf_triangle_2),>(_mus_tcrf_triangle_2)
  .db CAL,<(_mus_tcrf_triangle_3),>(_mus_tcrf_triangle_3)
  .db GOT
  .dw _mus_tcrf_triangle_loop

_mus_tcrf_noise:
  .db CAL,<(_mus_tcrf_noise_0),>(_mus_tcrf_noise_0)
  .db CAL,<(_mus_tcrf_noise_0),>(_mus_tcrf_noise_0)
_mus_tcrf_noise_loop:
  .db CAL,<(_mus_tcrf_noise_0),>(_mus_tcrf_noise_0)
  .db CAL,<(_mus_tcrf_noise_0),>(_mus_tcrf_noise_0)
  .db CAL,<(_mus_tcrf_noise_0),>(_mus_tcrf_noise_0)
  .db CAL,<(_mus_tcrf_noise_1),>(_mus_tcrf_noise_1)
  .db GOT
  .dw _mus_tcrf_noise_loop

_mus_tcrf_square1_0:
  .db STI,0,SL8,G2,C3,SL6,D3,E3,SL4,G2,SL8,GS2,C3,SL6,D3,E3,SL4
  .db GS2
  .db RET

_mus_tcrf_square1_1:
  .db STI,0,SL8,A2,C3,SL6,D3,E3,SL4,A2,SL8,AS2,D3,SL6,E3,F3,SL4
  .db AS2
  .db RET

_mus_tcrf_square1_2:
  .db STI,0,SL8,A2,C3,SL6,D3,F3,SL4,A2,SL8,GS2,C3,SL6,D3,F3,SL4
  .db GS2
  .db RET

_mus_tcrf_square1_3:
  .db STI,0,SL8,G2,C3,SL6,D3,E3,SL4,G2,SL8,F2,C3,SL6,G3,F3,SL4
  .db E3
  .db RET

_mus_tcrf_square1_4:
  .db STI,19,SLL,64,A0
  .db RET

_mus_tcrf_square1_5:
  .db STI,19,SLL,64,A0
  .db RET

_mus_tcrf_triangle_0:
  .db STI,2,SL3,G2,STI,19,SL1,A0,STI,3,SL8,G2,STI,2,E2,G2,SL4
  .db E2,SL3,GS2,STI,19,SL1,A0,STI,3,SL8,GS2,STI,2,E2,GS2,SL4
  .db E2
  .db RET

_mus_tcrf_triangle_1:
  .db STI,2,SL3,A2,STI,19,SL1,A0,STI,3,SL8,A2,STI,2,E2,A2,SL4
  .db E2,SL3,AS2,STI,19,SL1,A0,STI,3,SL8,AS2,STI,2,F2,AS2,SL4
  .db F2
  .db RET

_mus_tcrf_triangle_2:
  .db STI,2,SL3,A2,STI,19,SL1,A0,STI,3,SL8,A2,STI,2,F2,A2,SL4
  .db F2,SL3,GS2,STI,19,SL1,A0,STI,3,SL8,GS2,STI,2,F2,GS2,SL4
  .db F2
  .db RET

_mus_tcrf_triangle_3:
  .db STI,2,SL3,G2,STI,19,SL1,A0,STI,3,SL8,G2,STI,2,E2,G2,SL4
  .db E2,SL3,D2,STI,19,SL1,A0,STI,3,SL8,D2,STI,2,G2,A2,SL4,B2
  .db RET

_mus_tcrf_triangle_4:
  .db STI,19,SLL,64,A0
  .db RET

_mus_tcrf_triangle_5:
  .db STI,19,SLL,64,A0
  .db RET

_mus_tcrf_noise_0:
  .db STI,4,SL4,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
  .db RET

_mus_tcrf_noise_1:
  .db STI,4,SL4,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
  .db RET

_sfx_null:
  .db 0, 1
  .db 0, 1
  .dw 0
  .dw 0
  .dw 0
  .dw 0
  .dw 0

