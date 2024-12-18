; ----------------------------------------------------------------------------
; Object 03 - Collision plane/layer switcher
; ----------------------------------------------------------------------------
; Sprite_1FCDC:
PathSwapper:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	PSwapper_Index(pc,d0.w),d1
		jsr	PSwapper_Index(pc,d1.w)
	if DebuggingMode
		tst.w	(f_debugcheat).w
		bne.s	.remember
	endif
		; like RememberState, but doesn't display (Sonic 2's MarkObjGone3)
		out_of_range.w	DeleteObject_Respawn
		rts

	if DebuggingMode
.remember:
		out_of_range.w	DeleteObject_Respawn
		bra.w	DisplaySprite
	endif
; ===========================================================================
; off_1FCF0:
PSwapper_Index:
		dc.w PSwapper_Init-PSwapper_Index	; 0
		dc.w PSwapper_MainX-PSwapper_Index	; 2
		dc.w PSwapper_MainY-PSwapper_Index	; 4
; ===========================================================================
; loc_1FCF6:
PSwapper_Init:
		addq.b	#2,obRoutine(a0) ; => PSwapper_MainX
	if DebuggingMode
		move.l	#Map_PathSwapper,obMap(a0)
		move.w	#make_art_tile(ArtTile_Ring,1,0),obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.w	#5*$80,obPriority(a0)
	endif
		move.b	obSubtype(a0),d0
		btst	#2,d0
		beq.s	PSwapper_Init_CheckX
;PSwapper_Init_CheckY:
		addq.b	#2,obRoutine(a0) ; => PSwapper_MainY
		andi.w	#7,d0
		move.b	d0,obFrame(a0)
		andi.w	#3,d0
		add.w	d0,d0
		move.w	word_1FD68(pc,d0.w),objoff_32(a0)
		move.w	obY(a0),d1
		lea	(v_player).w,a1 ; a1=character
		cmp.w	obY(a1),d1
		bhs.w	PSwapper_MainY
		move.b	#1,objoff_34(a0)
		bra.w	PSwapper_MainY
; ===========================================================================
word_1FD68:
		dc.w   $20
		dc.w   $40	; 1
		dc.w   $80	; 2
		dc.w  $100	; 3
; ===========================================================================
; loc_1FD70:
PSwapper_Init_CheckX:
		andi.w	#3,d0
		move.b	d0,obFrame(a0)
		add.w	d0,d0
		move.w	word_1FD68(pc,d0.w),objoff_32(a0)
		move.w	obX(a0),d1
		lea	(v_player).w,a1 ; a1=character
		cmp.w	obX(a1),d1
		bhs.s	.jump
		move.b	#1,objoff_34(a0)
.jump:

; loc_1FDA4:
PSwapper_MainX:
	if DebuggingMode
		tst.w	(v_debuguse).w
		bne.w	.locret
	endif
		move.w	obX(a0),d1
		lea	objoff_34(a0),a2
		lea	(v_player).w,a1 ; a1=character
		tst.b	(a2)+
		bne.w	PSwapper_MainX_Alt
		cmp.w	obX(a1),d1
	if DebuggingMode
		bhi.w	.locret
	else
		bhi.s	.locret
	endif
		move.b	#1,-1(a2)
		move.w	obY(a0),d2
		move.w	d2,d3
		move.w	objoff_32(a0),d4
		sub.w	d4,d2
		add.w	d4,d3
		move.w	obY(a1),d4
		cmp.w	d2,d4
		blt.s	.locret
		cmp.w	d3,d4
		bge.s	.locret
		move.b	obSubtype(a0),d0
		bpl.s	.jump
		btst	#1,obStatus(a1)
		bne.s	.locret
.jump:
		btst	#0,obRender(a0)
		bne.s	.jump2
		move.b	#$C,(v_top_solid_bit).w	; MJ: set collision to 1st
		move.b	#$D,(v_lrb_solid_bit).w	; MJ: set collision to 1st
		btst	#3,d0
		beq.s	.jump2
		move.b	#$E,(v_top_solid_bit).w	; MJ: set collision to 2nd
		move.b	#$F,(v_lrb_solid_bit).w	; MJ: set collision to 2nd
.jump2:
		andi.w	#$7FFF,obGfx(a1)
		btst	#5,d0
		beq.s	.jump3
		ori.w	#(1<<15),obGfx(a1)
.jump3:
	if DebuggingMode
		tst.b	(f_debugcheat).w
		beq.s	.locret
		playsound sfx_Lamppost,sfx
	endif
.locret:
		rts
; ===========================================================================
; loc_1FE38:
PSwapper_MainX_Alt:
		cmp.w	obX(a1),d1
		bls.s	PSwapper_MainX.locret
		clr.b	-1(a2)
		move.w	obY(a0),d2
		move.w	d2,d3
		move.w	objoff_32(a0),d4
		sub.w	d4,d2
		add.w	d4,d3
		move.w	obY(a1),d4
		cmp.w	d2,d4
		blt.s	.locret
		cmp.w	d3,d4
		bge.s	.locret
		move.b	obSubtype(a0),d0
		bpl.s	.jump
		btst	#1,obStatus(a1)
		bne.s	.locret
.jump:
		btst	#0,obRender(a0)
		bne.s	.jump2
		move.b	#$C,(v_top_solid_bit).w	; MJ: set collision to 1st
		move.b	#$D,(v_lrb_solid_bit).w	; MJ: set collision to 1st
		btst	#4,d0
		beq.s	.jump2
		move.b	#$E,(v_top_solid_bit).w	; MJ: set collision to 2nd
		move.b	#$F,(v_lrb_solid_bit).w	; MJ: set collision to 2nd
.jump2:
		andi.w	#$7FFF,obGfx(a1)
		btst	#6,d0
		beq.s	.jump3
		ori.w	#(1<<15),obGfx(a1)
.jump3:
	if DebuggingMode
		tst.b	(f_debugcheat).w
		beq.s	.locret
		playsound sfx_Lamppost,sfx
	endif
.locret:
		rts
; ===========================================================================

PSwapper_MainY:
	if DebuggingMode
		tst.w	(v_debuguse).w
		bne.s	PSwapper_MainX_Alt.locret
	endif
		move.w	obY(a0),d1
		lea	objoff_34(a0),a2
		lea	(v_player).w,a1 ; a1=character
		tst.b	(a2)+
	if DebuggingMode
		bne.w	PSwapper_MainY_Alt
	else
		bne.s	PSwapper_MainY_Alt
	endif
		cmp.w	obY(a1),d1
		bhi.s	PSwapper_MainX_Alt.locret
		move.b	#1,-1(a2)
		move.w	obX(a0),d2
		move.w	d2,d3
		move.w	objoff_32(a0),d4
		sub.w	d4,d2
		add.w	d4,d3
		move.w	obX(a1),d4
		cmp.w	d2,d4
		blt.s	.locret
		cmp.w	d3,d4
		bge.s	.locret
		move.b	obSubtype(a0),d0
		bpl.s	.jump
		btst	#1,obStatus(a1)
		bne.s	.locret
.jump:
		btst	#0,obRender(a0)
		bne.s	.jump2
		move.b	#$C,(v_top_solid_bit).w	; MJ: set collision to 1st
		move.b	#$D,(v_lrb_solid_bit).w	; MJ: set collision to 1st
		btst	#3,d0
		beq.s	.jump2
		move.b	#$E,(v_top_solid_bit).w	; MJ: set collision to 2nd
		move.b	#$F,(v_lrb_solid_bit).w	; MJ: set collision to 2nd
.jump2:
		andi.w	#$7FFF,obGfx(a1)
		btst	#5,d0
		beq.s	.jump3
		ori.w	#(1<<15),obGfx(a1)
.jump3:
	if DebuggingMode
		tst.b	(f_debugcheat).w
		beq.s	.locret
		playsound sfx_Lamppost,sfx
	endif
.locret:
		rts
; ===========================================================================
; loc_1FF42:
PSwapper_MainY_Alt:
		cmp.w	obY(a1),d1
		bls.s	PSwapper_MainY.locret
		clr.b	-1(a2)
		move.w	obX(a0),d2
		move.w	d2,d3
		move.w	objoff_32(a0),d4
		sub.w	d4,d2
		add.w	d4,d3
		move.w	obX(a1),d4
		cmp.w	d2,d4
		blt.s	.locret
		cmp.w	d3,d4
		bge.s	.locret
		move.b	obSubtype(a0),d0
		bpl.s	.jump
		btst	#1,obStatus(a1)
		bne.s	.locret
.jump:
		btst	#0,obRender(a0)
		bne.s	.jump2
		move.b	#$C,(v_top_solid_bit).w	; MJ: set collision to 1st
		move.b	#$D,(v_lrb_solid_bit).w	; MJ: set collision to 1st
		btst	#4,d0
		beq.s	.jump2
		move.b	#$E,(v_top_solid_bit).w	; MJ: set collision to 2nd
		move.b	#$F,(v_lrb_solid_bit).w	; MJ: set collision to 2nd
.jump2:
		andi.w	#$7FFF,obGfx(a1)
		btst	#6,d0
		beq.s	.jump3
		ori.w	#(1<<15),obGfx(a1)
.jump3:
	if DebuggingMode
		tst.b	(f_debugcheat).w
		beq.s	.locret
		playsound sfx_Lamppost,sfx
	endif
.locret:
		rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
	if DebuggingMode
Map_PathSwapper:	include "_maps\Collision Switcher.asm"
	endif
; ===========================================================================