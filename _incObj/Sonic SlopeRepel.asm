; ---------------------------------------------------------------------------
; Subroutine to	push Sonic down	a slope
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_SlopeRepel:
		nop	
		tst.b	stick_to_convex(a0)
		bne.s	locret_13580
		tst.b	objoff_3E(a0)
		bne.s	loc_13582
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	locret_13580
		move.w	obInertia(a0),d0
		bpl.s	loc_1356A
		neg.w	d0

loc_1356A:
		cmpi.w	#$280,d0
		bhs.s	locret_13580
		clr.w	obInertia(a0)
		bset	#1,obStatus(a0)
		move.b	#$1E,objoff_3E(a0)

locret_13580:
		rts
; ===========================================================================

loc_13582:
		subq.b	#1,objoff_3E(a0)
		rts	
; End of function Sonic_SlopeRepel