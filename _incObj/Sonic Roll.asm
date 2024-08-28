; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to roll when he's moving
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Roll:
		tst.b	(f_slidemode).w
		bne.s	Sonic_ChkRoll.ismoving
		move.w	obInertia(a0),d0
		bpl.s	.ispositive
		neg.w	d0

.ispositive:
		cmpi.w	#$80,d0		; is Sonic moving at $80 speed or faster?
		blo.s	Sonic_ChkRoll.ismoving	; if not, branch
		moveq	#btnL+btnR,d0	; is left/right	being pressed?
		and.b	(v_jpadhold_stored).w,d0
		bne.s	Sonic_ChkRoll.ismoving	; if yes, branch
		btst	#bitDn,(v_jpadhold_stored).w ; is down being pressed?
		beq.s	Sonic_ChkRoll.ismoving	; if not, branch

Sonic_ChkRoll:
		btst	#2,obStatus(a0)	; is Sonic already rolling?
		bne.s	.ismoving	; if yes, branch
		bset	#2,obStatus(a0)
		move.b	#$E,obHeight(a0)
		move.b	#7,obWidth(a0)
		move.b	#id_Roll,obAnim(a0) ; use "rolling" animation
		addq.w	#5,obY(a0)
		moveq	#sfx_Roll,d0
		jsr	(PlaySound).w	; play rolling sound
		tst.w	obInertia(a0)
		bne.s	.ismoving
		move.w	#$200,obInertia(a0) ; set inertia if 0

.ismoving:
		rts	
; End of function Sonic_Roll