; ---------------------------------------------------------------------------
; Subroutine calculate a sine

; input:
;	d0 = angle

; output:
;	d0 = sine
;	d1 = cosine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

sinesubtractionval	= 6

CalcSine:
		andi.w	#$FF,d0
		addq.w	#sinesubtractionval,d0
		add.w	d0,d0
		move.w	Sine_Data+$80-sinesubtractionval*2(pc,d0.w),d1
		move.w	Sine_Data-sinesubtractionval*2(pc,d0.w),d0
		rts	
; End of function CalcSine

; ===========================================================================

Sine_Data:	binclude	"misc/sinewave.bin"	; values for a 360° sine wave
		even
; ===========================================================================
