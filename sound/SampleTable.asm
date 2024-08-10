
; ---------------------------------------------------------------
SampleTable:
	;			type			pointer		Hz
	dcSample	TYPE_DPCM, 		Kick, 		8000				; $81
	dcSample	TYPE_DPCM,		Snare,		TYPE_DPCM_MAX_RATE		; $82
	dcSample	TYPE_DPCM, 		Timpani, 	9750				; $83
	dcSample	TYPE_DPCM, 		Timpani, 	8750				; $84
	dcSample	TYPE_DPCM, 		Timpani, 	7150				; $85
	dcSample	TYPE_DPCM, 		Timpani, 	7000				; $86
	dcSample	TYPE_PCM,		SegaPCM,	14250				; $87
	dc.w	-1	; end marker

; ---------------------------------------------------------------
	incdac	Kick, "dac/kick.dpcm"
	incdac	Snare, "dac/snare.dpcm"
	incdac	Timpani, "dac/timpani.dpcm"
	incdac	SegaPCM, "dac/sega.pcm"
	even
