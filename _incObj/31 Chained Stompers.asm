; ---------------------------------------------------------------------------
; Object 31 - stomping metal blocks on chains (MZ)
; ---------------------------------------------------------------------------

ChainStomp:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CStom_Index(pc,d0.w),d1
		jmp	CStom_Index(pc,d1.w)
; ===========================================================================
CStom_Index:	dc.w CStom_Main-CStom_Index
		dc.w loc_B798-CStom_Index
		dc.w loc_B7FE-CStom_Index
		dc.w CStom_Display2-CStom_Index
		dc.w loc_B7E2-CStom_Index

CStom_switch = objoff_3A			; switch number for the current stomper

CStom_SwchNums:	dc.b 0,	0		; switch number, obj number
		dc.b 1,	0

CStom_Var:	dc.b 2,	0, 0		; routine number, y-position, frame number
		dc.b 4,	$1C, 1
		dc.b 8,	$CC, 3
		dc.b 6,	$F0, 2

word_B6A4:	dc.w $7000, $A000
		dc.w $5000, $7800
		dc.w $3800, $5800
		dc.w $B800
; ===========================================================================

CStom_Main:	; Routine 0
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		bpl.s	loc_B6CE
		andi.w	#$7F,d0
		add.w	d0,d0
		lea	CStom_SwchNums(pc,d0.w),a2
		move.b	(a2)+,CStom_switch(a0)
		move.b	(a2)+,d0
		move.b	d0,obSubtype(a0)

loc_B6CE:
		andi.b	#$F,d0
		add.w	d0,d0
		move.w	word_B6A4(pc,d0.w),d2
		tst.w	d0
		bne.s	loc_B6E0
		move.w	d2,objoff_32(a0)

loc_B6E0:
		lea	CStom_Var(pc),a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	CStom_MakeStomper
; ===========================================================================

CStom_Loop:
		bsr.w	FindNextFreeObj
		bne.w	CStom_SetSize

CStom_MakeStomper:
		move.b	(a2)+,obRoutine(a1)
		move.l	#ChainStomp,obID(a1)
		move.w	obX(a0),obX(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obY(a0),d0
		move.w	d0,obY(a1)
		move.l	#Map_CStom,obMap(a1)
		move.w	#make_art_tile(ArtTile_MZ_Spike_Stomper,0,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	obY(a1),objoff_30(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.b	#$10,obActWid(a1)
		move.w	d2,objoff_34(a1)
		move.w	#4*$80,obPriority(a1)
		move.b	(a2)+,obFrame(a1)
		cmpi.b	#1,obFrame(a1)
		bne.s	loc_B76A
		subq.w	#1,d1
		move.b	obSubtype(a0),d0
		andi.w	#$F0,d0
		cmpi.w	#$20,d0
		beq.s	CStom_MakeStomper
		move.b	#$38,obActWid(a1)
		move.b	#$90,obColType(a1)
		addq.w	#1,d1

loc_B76A:
		move.l	a0,objoff_3C(a1)
		dbf	d1,CStom_Loop

		move.w	#3*$80,obPriority(a1)

CStom_SetSize:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#3,d0
		andi.b	#$E,d0
		lea	CStom_Var2(pc,d0.w),a2
		move.b	(a2)+,obActWid(a0)
		move.b	(a2)+,obFrame(a0)
		bra.s	loc_B798
; ===========================================================================
CStom_Var2:	dc.b $38, 0		; width, frame number
		dc.b $30, 9
		dc.b $10, $A
; ===========================================================================

loc_B798:	; Routine 2
		bsr.w	CStom_Types
		move.w	obY(a0),(v_obj31ypos).w
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		moveq	#$C,d2
		moveq	#$D,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		btst	#3,obStatus(a0)
		beq.s	CStom_Display
		cmpi.b	#$10,objoff_32(a0)
		bhs.s	CStom_Display
		movea.l	a0,a2
		lea	(v_player).w,a0
		jsr	(KillSonic).l
		movea.l	a2,a0

CStom_Display:
		out_of_range.w	DeleteObject_Respawn
		bra.w	DisplaySprite
; ===========================================================================

loc_B7E2:	; Routine 8
		move.b	#$80,obHeight(a0)
		bset	#4,obRender(a0)
		movea.l	objoff_3C(a0),a1
		move.b	objoff_32(a1),d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,obFrame(a0)

loc_B7FE:	; Routine 4
		movea.l	objoff_3C(a0),a1
		moveq	#0,d0
		move.b	objoff_32(a1),d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)

CStom_Display2:	; Routine 6
CStom_ChkDel:
		out_of_range.w	DeleteObject_Respawn
		bra.w	DisplaySprite
; ===========================================================================

CStom_Types:
		moveq	#$F,d0
		and.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	CStom_TypeIndex(pc,d0.w),d1
		jmp	CStom_TypeIndex(pc,d1.w)
; ===========================================================================
CStom_TypeIndex:dc.w CStom_Type00-CStom_TypeIndex
		dc.w CStom_Type01-CStom_TypeIndex
		dc.w CStom_Type01-CStom_TypeIndex
		dc.w CStom_Type03-CStom_TypeIndex
		dc.w CStom_Type01-CStom_TypeIndex
		dc.w CStom_Type03-CStom_TypeIndex
		dc.w CStom_Type01-CStom_TypeIndex
; ===========================================================================

CStom_Type00:
		lea	(f_switch).w,a2	; load switch statuses
		moveq	#0,d0
		move.b	CStom_switch(a0),d0 ; move number 0 or 1 to d0
		tst.b	(a2,d0.w)	; has switch (d0) been pressed?
		beq.s	loc_B8A8	; if not, branch
		tst.w	(v_obj31ypos).w
		bpl.s	loc_B872
		cmpi.b	#$10,objoff_32(a0)
		beq.s	loc_B8A0

loc_B872:
		tst.w	objoff_32(a0)
		beq.s	loc_B8A0
		moveq	#$F,d0
		and.b	(v_framebyte).w,d0
		bne.s	loc_B892
		tst.b	obRender(a0)
		bpl.s	loc_B892
		playsound sfx_ChainRise,sfx

loc_B892:
		subi.w	#$80,objoff_32(a0)
		bcc.s	CStom_Restart
		move.w	#0,objoff_32(a0)

loc_B8A0:
		move.w	#0,obVelY(a0)
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)
		rts
; ===========================================================================

loc_B8A8:
		move.w	objoff_34(a0),d1
		cmp.w	objoff_32(a0),d1
		beq.s	CStom_Restart
		move.w	obVelY(a0),d0
		addi.w	#$70,obVelY(a0)	; make object fall
		add.w	d0,objoff_32(a0)
		cmp.w	objoff_32(a0),d1
		bhi.s	CStom_Restart
		move.w	d1,objoff_32(a0)
		move.w	#0,obVelY(a0)	; stop object falling
		tst.b	obRender(a0)
		bpl.s	CStom_Restart
		playsound sfx_ChainStomp,sfx

CStom_Restart:
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)
		rts
; ===========================================================================

CStom_Type01:
		tst.w	objoff_36(a0)
		beq.s	loc_B938
		tst.w	objoff_38(a0)
		beq.s	loc_B902
		subq.w	#1,objoff_38(a0)
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)
		rts
; ===========================================================================

loc_B902:
		moveq	#$F,d0
		and.b	(v_framebyte).w,d0
		bne.s	loc_B91C
		tst.b	obRender(a0)
		bpl.s	loc_B91C
		playsound sfx_ChainRise,sfx

loc_B91C:
		subi.w	#$80,objoff_32(a0)
		bcc.s	.restart
		move.w	#0,objoff_32(a0)
		move.w	#0,obVelY(a0)
		move.w	#0,objoff_36(a0)
		
.restart:
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)
		rts
; ===========================================================================

loc_B938:
		move.w	objoff_34(a0),d1
		cmp.w	objoff_32(a0),d1
		beq.s	.restart
		move.w	obVelY(a0),d0
		addi.w	#$70,obVelY(a0)	; make object fall
		add.w	d0,objoff_32(a0)
		cmp.w	objoff_32(a0),d1
		bhi.s	.restart
		move.w	d1,objoff_32(a0)
		move.w	#0,obVelY(a0)	; stop object falling
		move.w	#1,objoff_36(a0)
		move.w	#$3C,objoff_38(a0)
		tst.b	obRender(a0)
		bpl.s	.restart
		playsound sfx_ChainStomp,sfx
		
.restart:
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)
		rts
; ===========================================================================

CStom_Type03:
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	loc_B98C
		neg.w	d0

loc_B98C:
		cmpi.w	#$90,d0
		bhs.s	.restart
		addq.b	#1,obSubtype(a0)
		
.restart:
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)
		rts