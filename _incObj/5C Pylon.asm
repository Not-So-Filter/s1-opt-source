; ---------------------------------------------------------------------------
; Object 5C - metal pylons in foreground (SLZ)
; ---------------------------------------------------------------------------

Pylon:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Pyl_Index(pc,d0.w),d1
		jmp	Pyl_Index(pc,d1.w)
; ===========================================================================
Pyl_Index:	dc.w Pyl_Main-Pyl_Index
		dc.w Pyl_Display-Pyl_Index
; ===========================================================================

Pyl_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Pylon,obMap(a0)
		move.w	#make_art_tile(ArtTile_SLZ_Pylon,0,1),obGfx(a0)
		move.b	#$10,obActWid(a0)

Pyl_Display:	; Routine 2
		move.w	(v_screenposx).w,d1
		add.w	d1,d1
		neg.w	d1
		move.w	d1,obX(a0)
		move.w	(v_screenposy).w,d1
		add.w	d1,d1
		andi.w	#$3F,d1
		neg.w	d1
		addi.w	#$100,d1
		move.w	d1,obScreenY(a0)
		lea	(v_spritequeue).w,a1
		tst.w	(a1)	; is this part of the queue full?
		bmi.s	.end		; if yes, branch
		addq.w	#2,(a1)		; increment sprite count
		adda.w	(a1),a1		; jump to empty position
		move.w	a0,(a1)		; insert RAM address for object

.end:
		rts