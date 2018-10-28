;
; Init ggsound engine
;

    lda #SOUND_REGION_NTSC ;or #SOUND_REGION_PAL, or #SOUND_REGION_DENDY
    sta sound_param_byte_0
    lda #<song_list
    sta sound_param_word_0
    lda #>song_list
    sta sound_param_word_0+1
    lda #<sfx_list
    sta sound_param_word_1
    lda #>sfx_list
    sta sound_param_word_1+1
    lda #<instrument_list
    sta sound_param_word_2
    lda #>instrument_list
    sta sound_param_word_2+1
IFDEF FEATURE_DPCM
    lda #<dpcm_list
    sta sound_param_word_3
    lda #>dpcm_list
    sta sound_param_word_3+1
ENDIF

	jsr sound_initialize
