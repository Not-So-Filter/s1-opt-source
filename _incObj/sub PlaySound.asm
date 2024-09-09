; ---------------------------------------------------------------------------
; Subroutine to	play a music track

; input:
;	d0 = track to play
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PlayMusic:
		stopZ80
		move.b	d0,(z80_ram+zAbsVar.Queue0).l
		startZ80
		rts
; End of function PlaySound

; ---------------------------------------------------------------------------
; Subroutine to	play a sound effect
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PlaySound:
		stopZ80
		move.b	d0,(z80_ram+zAbsVar.Queue1).l
		startZ80
		rts
; End of function PlaySound_Special