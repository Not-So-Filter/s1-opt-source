; ---------------------------------------------------------------------------
; Object 69 - spinning platforms and trapdoors (SBZ)
; ---------------------------------------------------------------------------

SpinPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Spin_Index(pc,d0.w),d1
		jmp	Spin_Index(pc,d1.w)
; ===========================================================================
Spin_Index:	dc.w Spin_Main-Spin_Index
		dc.w Spin_Trapdoor-Spin_Index
		dc.w Spin_Spinner-Spin_Index

spin_timer = objoff_30		; time counter until change
spin_timelen = objoff_32	; time between changes (general)
; ===========================================================================

Spin_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Trap,obMap(a0)
		move.w	#make_art_tile(ArtTile_SBZ_Trap_Door,2,0),obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#$80,obActWid(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		mulu.w	#$3C,d0
		move.w	d0,spin_timelen(a0)
		tst.b	obSubtype(a0)	; is subtype $8x?
		bpl.s	Spin_Trapdoor	; if not, branch

		addq.b	#2,obRoutine(a0) ; goto Spin_Spinner next
		move.l	#Map_Spin,obMap(a0)
		move.w	#make_art_tile(ArtTile_SBZ_Spinning_Platform,0,0),obGfx(a0)
		move.b	#$10,obActWid(a0)
		move.b	#2,obAnim(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; get object type
		move.w	d0,d1
		andi.w	#$F,d0		; read only the	2nd digit
		mulu.w	#6,d0		; multiply by 6
		move.w	d0,spin_timer(a0)
		move.w	d0,spin_timelen(a0) ; set time delay
		andi.w	#$70,d1
		addi.w	#$10,d1
		add.w	d1,d1
		add.w	d1,d1
		subq.w	#1,d1
		move.w	d1,objoff_36(a0)
		bra.w	Spin_Spinner
; ===========================================================================

Spin_Trapdoor:	; Routine 2
		subq.w	#1,spin_timer(a0) ; decrement timer
		bpl.s	.animate	; if time remains, branch

		move.w	spin_timelen(a0),spin_timer(a0)
		bchg	#0,obAnim(a0)
		tst.b	obRender(a0)
		bpl.s	.animate
		playsound sfx_Door,sfx

.animate:
		lea	Ani_Spin(pc),a1
		jsr	(AnimateSprite).l
		tst.b	obFrame(a0)	; is frame number 0 displayed?
		bne.s	.notsolid	; if not, branch
		moveq	#$4B,d1
		moveq	#$C,d2
		moveq	#$D,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		out_of_range.s	.delete
		jmp	(DisplaySprite).l

.delete:
		jmp	(DeleteObject_Respawn).l
; ===========================================================================

.notsolid:
		btst	#3,obStatus(a0) ; is Sonic standing on the trapdoor?
		beq.s	.display	; if not, branch
		lea	(v_player).w,a1
		bclr	#3,obStatus(a1)
		bclr	#3,obStatus(a0)
		clr.b	obSolid(a0)

.display:
		out_of_range.s	.delete
		jmp	(DisplaySprite).l
; ===========================================================================

Spin_Spinner:	; Routine 4
		move.w	(v_framecount).w,d0
		and.w	objoff_36(a0),d0
		bne.s	.delay
		move.b	#1,objoff_34(a0)

.delay:
		tst.b	objoff_34(a0)
		beq.s	.animate
		subq.w	#1,spin_timer(a0)
		bpl.s	.animate
		move.w	spin_timelen(a0),spin_timer(a0)
		clr.b	objoff_34(a0)
		bchg	#0,obAnim(a0)

.animate:
		lea	Ani_Spin(pc),a1
		jsr	(AnimateSprite).l
		tst.b	obFrame(a0)	; check	if frame number	0 is displayed
		bne.s	.notsolid2	; if not, branch
		moveq	#$1B,d1
		moveq	#7,d2
		moveq	#8,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		out_of_range.s	.delete
		jmp	(DisplaySprite).l
		
.delete:
		jmp	(DeleteObject_Respawn).l
; ===========================================================================

.notsolid2:
		btst	#3,obStatus(a0)
		beq.s	.display
		lea	(v_player).w,a1
		bclr	#3,obStatus(a1)
		bclr	#3,obStatus(a0)
		clr.b	obSolid(a0)

.display:
		out_of_range.s	.delete
		jmp	(DisplaySprite).l
