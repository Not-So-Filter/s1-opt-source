; ---------------------------------------------------------------------------
; Subroutine to	generate a pseudo-random number	in d0
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


RandomNumber:
		move.l	(v_random).w,d0
		beq.s	.doEor
		add.l	d0,d0
		bls.s	.noEor
.doEor:		eori.l	#$741B8CD7,d0
.noEor:		move.l	d0,(v_random).w
		rts