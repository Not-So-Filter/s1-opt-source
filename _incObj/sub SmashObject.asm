; ---------------------------------------------------------------------------
; Subroutine to	smash a	block (GHZ walls and MZ	blocks)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SmashObject:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		add.w	d0,d0
		movea.l	obMap(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#2,a3
		bset	#5,obRender(a0)
		move.l	obID(a0),d4
		move.b	obRender(a0),d5
		move.w	obGfx(a0),d3
		move.w	#4*$80,d6
		moveq	#0,d7
		move.b	obActWid(a0),d7
		movea.l	a0,a1
		bra.s	.loadfrag
; ===========================================================================

.loop:
		lea	(v_lvlobjspace).w,a1 ; start address for object RAM
		moveq	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d0

.loop2:
		lea	object_size(a1),a1
		tst.l	obID(a1)
		dbeq	d0,.loop2
		bne.s	.playsnd
		addq.w	#6,a3

.loadfrag:
		move.b	#4,obRoutine(a1)
		move.l	d4,obID(a1)
		move.l	a3,obMap(a1)
		move.b	d5,obRender(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	d3,obGfx(a1)
		move.w	d6,obPriority(a1)
		move.b	d7,obActWid(a1)
		move.l	(a4)+,obVelX(a1) ; because this is longword, it also covers y velocity
		cmpa.l	a0,a1
		bhs.s	.loc_D268
		move.l	a0,-(sp)
		movea.l	a1,a0
		bsr.w	SpeedToPos
		add.w	d2,obVelY(a0)
		movea.l	(sp)+,a0
		bsr.w	DisplaySprite1

.loc_D268:
		dbf	d1,.loop

.playsnd:
		playsound sfx_WallSmash,sfx
		rts

; End of function SmashObject