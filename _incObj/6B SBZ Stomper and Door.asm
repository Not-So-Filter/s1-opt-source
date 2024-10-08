; ---------------------------------------------------------------------------
; Object 6B - stomper and sliding door (SBZ)
; ---------------------------------------------------------------------------

ScrapStomp:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Sto_Index(pc,d0.w),d1
		jmp	Sto_Index(pc,d1.w)
; ===========================================================================
Sto_Index:	dc.w Sto_Main-Sto_Index
		dc.w Sto_Action-Sto_Index

sto_origX = objoff_34		; original x-axis position
sto_origY = objoff_30		; original y-axis position
sto_active = objoff_38		; flag set when a switch is pressed

Sto_Var:	dc.b  $40,  $C,	$80,   1 ; width, height, ????,	type number
		dc.b  $1C, $20,	$38,   3
		dc.b  $1C, $20,	$40,   4
		dc.b  $1C, $20,	$60,   4
		dc.b  $80, $40,	  0,   5
; ===========================================================================

Sto_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#2,d0
		andi.w	#$1C,d0
		lea	Sto_Var(pc,d0.w),a3
		move.b	(a3)+,obActWid(a0)
		move.b	(a3)+,obHeight(a0)
		lsr.w	#2,d0
		move.b	d0,obFrame(a0)
		move.l	#Map_Stomp,obMap(a0)
		move.w	#make_art_tile(ArtTile_SBZ_Moving_Block_Short,1,0),obGfx(a0)
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ/SBZ3
		bne.s	.isSBZ12	; if not, branch
		bset	#0,(v_obj6B).w
		beq.s	.isSBZ3

.chkdel:
		move.w	obRespawnNo(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		jmp	(DeleteObject).l
; ===========================================================================

.isSBZ3:
		move.w	#make_art_tile(ArtTile_Level+$1F0,2,0),obGfx(a0)
		cmpi.w	#$A80,obX(a0)
		bne.s	.isSBZ12
		move.w	obRespawnNo(a0),d0
		beq.s	.isSBZ12
		movea.w	d0,a2
		btst	#0,(a2)
		beq.s	.isSBZ12
		clr.b	(v_obj6B).w
		bra.s	.chkdel
; ===========================================================================

.isSBZ12:
		ori.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.w	obX(a0),sto_origX(a0)
		move.w	obY(a0),sto_origY(a0)
		moveq	#0,d0
		move.b	(a3)+,d0
		move.w	d0,objoff_3C(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		bpl.s	Sto_Action
		andi.b	#$F,d0
		move.b	d0,objoff_3E(a0)
		move.b	(a3),obSubtype(a0)
		cmpi.b	#5,(a3)
		bne.s	.chkgone
		bset	#4,obRender(a0)

.chkgone:
		move.w	obRespawnNo(a0),d0
		beq.s	Sto_Action
		movea.w	d0,a2
		bclr	#7,(a2)

Sto_Action:	; Routine 2
		move.w	obX(a0),-(sp)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	.index(pc,d0.w),d1
		jsr	.index(pc,d1.w)
		move.w	(sp)+,d4
		tst.b	obRender(a0)
		bpl.s	.chkdel
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	obHeight(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject

.chkdel:
		out_of_range.s	.chkgone,sto_origX(a0)
		jmp	(DisplaySprite).l

.chkgone:
		cmpi.b	#id_LZ,(v_zone).w
		bne.s	.delete
		clr.b	(v_obj6B).w
		move.w	obRespawnNo(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		jmp	(DeleteObject).l
; ===========================================================================
.index:		dc.w .type00-.index, .type01-.index
		dc.w .type02-.index, .type03-.index
		dc.w .type04-.index, .type05-.index
; ===========================================================================

.type00:
		rts
; ===========================================================================

.type01:
		tst.b	sto_active(a0)
		bne.s	.isactive01
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	objoff_3E(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	.loc_15DC2
		move.b	#1,sto_active(a0)

.isactive01:
		move.w	objoff_3C(a0),d0
		cmp.w	objoff_3A(a0),d0
		beq.s	.loc_15DE0
		addq.w	#2,objoff_3A(a0)

.loc_15DC2:
		move.w	objoff_3A(a0),d0
		btst	#0,obStatus(a0)
		beq.s	.noflip01
		neg.w	d0
		addi.w	#$80,d0

.noflip01:
		move.w	sto_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,obX(a0)
		rts
; ===========================================================================

.loc_15DE0:
		addq.b	#1,obSubtype(a0)
		move.w	#$B4,objoff_36(a0)
		clr.b	sto_active(a0)
		move.w	obRespawnNo(a0),d0
		beq.s	.loc_15DC2
		movea.w	d0,a2
		bset	#0,(a2)
		bra.s	.loc_15DC2
; ===========================================================================

.type02:
		tst.b	sto_active(a0)
		bne.s	.isactive02
		subq.w	#1,objoff_36(a0)
		bne.s	.loc_15E1E
		move.b	#1,sto_active(a0)

.isactive02:
		tst.w	objoff_3A(a0)
		beq.s	.loc_15E3C
		subq.w	#2,objoff_3A(a0)

.loc_15E1E:
		move.w	objoff_3A(a0),d0
		btst	#0,obStatus(a0)
		beq.s	.noflip02
		neg.w	d0
		addi.w	#$80,d0

.noflip02:
		move.w	sto_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,obX(a0)
		rts
; ===========================================================================

.loc_15E3C:
		subq.b	#1,obSubtype(a0)
		clr.b	sto_active(a0)
		move.w	obRespawnNo(a0),d0
		beq.s	.loc_15E1E
		movea.w	d0,a2
		bclr	#0,(a2)
		bra.s	.loc_15E1E
; ===========================================================================

.type03:
		tst.b	sto_active(a0)
		bne.s	.isactive03
		tst.w	objoff_3A(a0)
		beq.s	.loc_15E6A
		subq.w	#1,objoff_3A(a0)
		bra.s	.loc_15E8E
; ===========================================================================

.loc_15E6A:
		subq.w	#1,objoff_36(a0)
		bpl.s	.loc_15E8E
		move.w	#$3C,objoff_36(a0)
		move.b	#1,sto_active(a0)

.isactive03:
		addq.w	#8,objoff_3A(a0)
		move.w	objoff_3A(a0),d0
		cmp.w	objoff_3C(a0),d0
		bne.s	.loc_15E8E
		clr.b	sto_active(a0)

.loc_15E8E:
		move.w	objoff_3A(a0),d0
		btst	#0,obStatus(a0)
		beq.s	.noflip03
		neg.w	d0
		addi.w	#$38,d0

.noflip03:
		move.w	sto_origY(a0),d1
		add.w	d0,d1
		move.w	d1,obY(a0)
		rts
; ===========================================================================

.type04:
		tst.b	sto_active(a0)
		bne.s	.isactive04
		tst.w	objoff_3A(a0)
		beq.s	.loc_15EBE
		subq.w	#8,objoff_3A(a0)
		bra.s	.loc_15EF0
; ===========================================================================

.loc_15EBE:
		subq.w	#1,objoff_36(a0)
		bpl.s	.loc_15EF0
		move.w	#$3C,objoff_36(a0)
		move.b	#1,sto_active(a0)

.isactive04:
		move.w	objoff_3A(a0),d0
		cmp.w	objoff_3C(a0),d0
		beq.s	.loc_15EE0
		addq.w	#8,objoff_3A(a0)
		bra.s	.loc_15EF0
; ===========================================================================

.loc_15EE0:
		subq.w	#1,objoff_36(a0)
		bpl.s	.loc_15EF0
		move.w	#$3C,objoff_36(a0)
		clr.b	sto_active(a0)

.loc_15EF0:
		move.w	objoff_3A(a0),d0
		btst	#0,obStatus(a0)
		beq.s	.noflip04
		neg.w	d0
		addi.w	#$38,d0

.noflip04:
		move.w	sto_origY(a0),d1
		add.w	d0,d1
		move.w	d1,obY(a0)
		rts
; ===========================================================================

.type05:
		tst.b	sto_active(a0)
		bne.s	.loc_15F3E
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	objoff_3E(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	.locret_15F5C
		move.b	#1,sto_active(a0)
		move.w	obRespawnNo(a0),d0
		beq.s	.loc_15F3E
		movea.w	d0,a2
		bset	#0,(a2)

.loc_15F3E:
		subi.l	#$10000,obX(a0)
		addi.l	#$8000,obY(a0)
		move.w	obX(a0),sto_origX(a0)
		cmpi.w	#$980,obX(a0)
		beq.s	.loc_15F5E

.locret_15F5C:
		rts
; ===========================================================================

.loc_15F5E:
		clr.b	obSubtype(a0)
		clr.b	sto_active(a0)
		rts
