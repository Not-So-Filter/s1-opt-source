; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's angle & position as he walks along the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_AnglePos:
		move.b	(v_top_solid_bit).w,d5			; MJ: load L/R/B soldity bit
		move.l	(v_colladdr1).w,(v_collindex).w		; MJ: load first collision data location
		cmpi.b	#$C,d5					; MJ: is second collision set to be used?
		beq.s	.first					; MJ: if not, branch
		move.l	(v_colladdr2).w,(v_collindex).w		; MJ: load second collision data location
.first:
		btst	#3,obStatus(a0)
		beq.s	loc_14602
		moveq	#0,d0
		move.b	d0,(v_anglebuffer).w
		move.b	d0,(v_anglebuffer2).w
		rts
; ===========================================================================

loc_14602:
		moveq	#3,d0
		move.b	d0,(v_anglebuffer).w
		move.b	d0,(v_anglebuffer2).w
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		bpl.s	loc_14624
		move.b	obAngle(a0),d0
		bpl.s	loc_1461E
		subq.b	#1,d0

loc_1461E:
		addi.b	#$20,d0
		bra.s	loc_14630
; ===========================================================================

loc_14624:
		move.b	obAngle(a0),d0
		bpl.s	loc_1462C
		addq.b	#1,d0

loc_1462C:
		addi.b	#$1F,d0

loc_14630:
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	Sonic_WalkVertL
		cmpi.b	#$80,d0
		beq.w	Sonic_WalkCeiling
		cmpi.b	#$C0,d0
		beq.w	Sonic_WalkVertR
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor	; MJ: check solidity
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor	; MJ: check solidity
		move.w	(sp)+,d0
		bsr.s	Sonic_Angle
		tst.w	d1
		beq.s	locret_146BE
		bpl.s	loc_146C0
		cmpi.w	#-$E,d1
		blt.s	locret_146BE
		add.w	d1,obY(a0)

locret_146BE:
		rts
; ===========================================================================

loc_146C0:
		tst.b	stick_to_convex(a0)
		bne.s	loc_146C6
		move.b	obVelX(a0),d0
		bpl.s	loc_ED22
		neg.b	d0

loc_ED22:
		addq.b	#4,d0
		cmpi.b	#$E,d0
		blo.s	loc_ED2E
		move.b	#$E,d0

loc_ED2E:
		cmp.b	d0,d1
		bgt.s	loc_146CC

loc_146C6:
		add.w	d1,obY(a0)
		rts
; ===========================================================================

loc_146CC:
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0)
		rts
; End of function Sonic_AnglePos

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's angle as he walks along the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Angle:
		move.b	(v_anglebuffer2).w,d2
		cmp.w	d0,d1
		ble.s	loc_1475E
		move.b	(v_anglebuffer).w,d2
		move.w	d0,d1

loc_1475E:
		btst	#0,d2
		bne.s	loc_1476A
		move.b	d2,d0
		sub.b	obAngle(a0),d0
		bpl.s	loc_ED6E
		neg.b	d0

loc_ED6E:
		cmpi.b	#$20,d0
		bhs.s	loc_1476A
		move.b	d2,obAngle(a0)
		rts
; ===========================================================================

loc_1476A:
		move.b	obAngle(a0),d2
		addi.b	#$20,d2
		andi.b	#$C0,d2
		move.b	d2,obAngle(a0)
		rts
; End of function Sonic_Angle

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk up a vertical slope/wall to	his right
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WalkVertR:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall	; MJ: check solidity
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall	; MJ: check solidity
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_147F0
		bpl.s	loc_147F2
		cmpi.w	#-$E,d1
		blt.s	locret_147F0
		add.w	d1,obX(a0)

locret_147F0:
		rts
; ===========================================================================

loc_147F2:
		tst.b	stick_to_convex(a0)
		bne.s	loc_147F8
		move.b	obVelY(a0),d0
		bpl.s	loc_EE30
		neg.b	d0

loc_EE30:
		addq.b	#4,d0
		cmpi.b	#$E,d0
		blo.s	loc_EE3C
		move.b	#$E,d0

loc_EE3C:
		cmp.b	d0,d1
		bgt.s	loc_147FE

loc_147F8:
		add.w	d1,obX(a0)
		rts
; ===========================================================================

loc_147FE:
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0)
		rts
; End of function Sonic_WalkVertR

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk upside-down
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WalkCeiling:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6	; MJ: $1000/2
		bsr.w	FindFloor	; MJ: check solidity
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6	; MJ: $1000/2
		bsr.w	FindFloor	; MJ: check solidity
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_14892
		bpl.s	loc_14894
		cmpi.w	#-$E,d1
		blt.s	locret_14892
		sub.w	d1,obY(a0)

locret_14892:
		rts
; ===========================================================================

loc_14894:
		tst.b	stick_to_convex(a0)
		bne.s	loc_1489A
		move.b	obVelX(a0),d0
		bpl.s	loc_EEDE
		neg.b	d0

loc_EEDE:
		addq.b	#4,d0
		cmpi.b	#$E,d0
		blo.s	loc_EEEA
		move.b	#$E,d0

loc_EEEA:
		cmp.b	d0,d1
		bgt.s	loc_148A0

loc_1489A:
		sub.w	d1,obY(a0)
		rts
; ===========================================================================

loc_148A0:
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0)
		rts
; End of function Sonic_WalkCeiling

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk up a vertical slope/wall to	his left
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WalkVertL:
		move.w	obY(a0),d2		; MJ: Load Y position
		move.w	obX(a0),d3		; MJ: Load X position
		moveq	#0,d0			; MJ: clear d0
		move.b	obWidth(a0),d0		; MJ: load height
		ext.w	d0			; MJ: set left byte pos or neg
		sub.w	d0,d2			; MJ: subtract from Y position
		move.b	obHeight(a0),d0		; MJ: load width
		ext.w	d0			; MJ: set left byte pos or neg
		sub.w	d0,d3			; MJ: subtract from X position
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4	; MJ: load address of the angle value set
		movea.w	#-$10,a3
		move.w	#$400,d6		; MJ: $800/2
		bsr.w	FindWall		; MJ: check solidity
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#-$10,a3
		move.w	#$400,d6	; MJ: $800/2
		bsr.w	FindWall	; MJ: check solidity
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_14934
		bpl.s	loc_14936
		cmpi.w	#-$E,d1
		blt.s	locret_14934
		sub.w	d1,obX(a0)

locret_14934:
		rts
; ===========================================================================

loc_14936:
		tst.b	stick_to_convex(a0)
		bne.s	loc_1493C
		move.b	obVelY(a0),d0
		bpl.s	loc_EF8C
		neg.b	d0

loc_EF8C:
		addq.b	#4,d0
		cmpi.b	#$E,d0
		blo.s	loc_EF98
		move.b	#$E,d0

loc_EF98:
		cmp.b	d0,d1
		bgt.s	loc_14942

loc_1493C:
		sub.w	d1,obX(a0)
		rts
; ===========================================================================

loc_14942:
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0)
		rts
; End of function Sonic_WalkVertL
