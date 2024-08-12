; ---------------------------------------------------------------------------
; Subroutine to	slow Sonic walking up a	slope
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_SlopeResist:
		move.b	obAngle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bhs.s	locret_13508
		move.b	obAngle(a0),d0
		jsr	(CalcSine).w
		ext.l	d0
		asl.l	#5,d0
		asr.l	#8,d0
		tst.w	obInertia(a0)
		beq.s	locret_13508
		bmi.s	loc_13504
		tst.w	d0
		beq.s	locret_13508

loc_13504:
		add.w	d0,obInertia(a0)

locret_13508:
		rts	
; End of function Sonic_SlopeResist