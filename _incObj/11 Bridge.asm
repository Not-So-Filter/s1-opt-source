; ---------------------------------------------------------------------------
; Object 11 - GHZ bridge
; ---------------------------------------------------------------------------
; OST Variables:
Obj11_child1		= objoff_30	; pointer to first set of bridge segments
Obj11_child2		= objoff_34	; pointer to second set of bridge segments, if applicable

Bridge:
		btst	#6,obRender(a0)	; is this a child sprite object?
		bne.s	.childDisplay		; if yes, branch
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bri_Index(pc,d0.w),d1
		jmp	Bri_Index(pc,d1.w)
; ===========================================================================
.childDisplay:	; child sprite objects only need to be drawn
		move.w	#3*$80,d0
		bra.w	DisplaySprite2
; ===========================================================================
Bri_Index:	dc.w Bri_Main-Bri_Index, Bri_Action-Bri_Index
		dc.w Bri_Display-Bri_Index
; ===========================================================================

Bri_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Bri,obMap(a0)
		move.w	#make_art_tile(ArtTile_GHZ_Bridge,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$80,obActWid(a0)
		move.w	obY(a0),d2
		move.w	d2,objoff_3C(a0)
		move.w	obX(a0),d3
		lea	obSubtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1		; copy bridge length to d1
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3		; d3 is position of leftmost log
		swap	d1	; store subtype in high word for later
		move.w	#8,d1
		bsr.s	Obj11_MakeBdgSegment
		move.w	sub6_x_pos(a1),d0
		subq.w	#8,d0
		move.w	d0,obX(a1)		; center of first subsprite object
		move.l	a1,Obj11_child1(a0)	; pointer to first subsprite object
		swap	d1	; retrieve subtype
		subq.w	#8,d1
		bls.s	+	; branch, if subtype <= 8 (bridge has no more than 8 logs)
		; else, create a second subsprite object for the rest of the bridge
		move.w	d1,d4
		bsr.s	Obj11_MakeBdgSegment
		move.l	a1,Obj11_child2(a0)	; pointer to second subsprite object
		move.w	d4,d0
		add.w	d0,d0
		add.w	d4,d0	; d0*3
		move.w	sub2_x_pos(a1,d0.w),d0
		subq.w	#8,d0
		move.w	d0,obX(a1)		; center of second subsprite object
+
		bra.s	Bri_Action

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; sub_F728:
Obj11_MakeBdgSegment:
		bsr.w	FindNextFreeObj
		bne.s	+	; rts
		move.b	#id_Bridge,obID(a1) ; load obj11
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l	#Map_Bri,obMap(a1)
		move.w	#make_art_tile(ArtTile_GHZ_Bridge,2,0),obGfx(a1)
		move.b	#4,obRender(a1)
		bset	#6,obRender(a1)
		move.w	#$40,mainspr_width(a1)
		move.b	d1,mainspr_childsprites(a1)
		subq.b	#1,d1
		lea	subspr_data(a1),a2 ; starting address for subsprite data

-		move.w	d3,(a2)+	; sub?_x_pos
		move.w	d2,(a2)+	; sub?_y_pos
		move.w	#0,(a2)+	; sub?_mapframe
		addi.w	#$10,d3		; width of a log, x_pos for next log
		dbf	d1,-	; repeat for d1 logs
+
		rts
; End of function Obj11_MakeBdgSegment

; ===========================================================================
; loc_F77A: Obj11_Action:
Bri_Action:
		moveq	#$18,d0
		and.b	obStatus(a0),d0
		bne.s	+
		tst.b	objoff_3E(a0)
		beq.s	loc_F7BC
		subq.b	#4,objoff_3E(a0)
		bra.s	loc_F7B8
+
		cmpi.b	#$40,objoff_3E(a0)
		beq.s	loc_F7B8
		addq.b	#4,objoff_3E(a0)

loc_F7B8:
		bsr.w	Obj11_Depress

loc_F7BC:
		moveq	#0,d1
		move.b	obSubtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		moveq	#8,d3
		move.w	obX(a0),d4
		bsr.s	sub_F872

; loc_F7D4:
Obj11_Unload:
		; this is essentially MarkObjGone, except we need to delete our subsprite objects as well
		move.w	obX(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1 ; get screen position
		subi.w	#128,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0		; approx distance between object and screen
		cmpi.w	#128+320+192,d0
		bhi.s	+
		rts
; ---------------------------------------------------------------------------
+		; delete first subsprite object
		movea.l	Obj11_child1(a0),a1 ; a1=object
		bsr.w	DeleteChild
		cmpi.b	#8,obSubtype(a0)
		bls.s	+	; if bridge has more than 8 logs, delete second subsprite object
		movea.l	Obj11_child2(a0),a1 ; a1=object
		bsr.w	DeleteChild
+
		bra.w	DeleteObject
; ===========================================================================
; loc_F80C: BranchTo_DisplaySprite:
Bri_Display:
		bra.w	DisplaySprite

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_F872:
		lea	(v_player).w,a1 ; a1=character
		moveq	#$3F,d5
		btst	#3,obStatus(a0)
		beq.s	loc_F8F0
		btst	#1,obStatus(a1)
		bne.s	+
		moveq	#0,d0
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	+
		cmp.w	d2,d0
		blo.s	++
+
		bclr	#3,obStatus(a1)
		bclr	#3,obStatus(a0)
		moveq	#0,d4
		rts
; ===========================================================================
+
		lsr.w	#4,d0
		move.b	d0,(a0,d5.w)
		movea.l	Obj11_child1(a0),a2
		cmpi.w	#8,d0
		blo.s	+
		movea.l	Obj11_child2(a0),a2 ; a2=object
		subq.w	#8,d0
+
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	sub2_y_pos(a2,d0.w),d0
		subq.w	#8,d0
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		moveq	#0,d4
		rts
; ===========================================================================

loc_F8F0:
		move.w	d1,-(sp)
		bsr.s	PlatformObject11_cont
		move.w	(sp)+,d1
		btst	#3,obStatus(a0)
		beq.s	.return
		moveq	#0,d0
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		lsr.w	#4,d0
		move.b	d0,(a0,d5.w)
.return:
		rts
; End of function sub_F872

; ===========================================================================
; Used only by EHZ/HPZ log bridges. Very similar to PlatformObject_cont, but
; d2 already has the full width of the log.
;loc_19D9C:
PlatformObject11_cont:
		tst.w	obVelY(a1)
		bmi.s	loc_F8F0.return
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_F8F0.return
		cmp.w	d2,d0
		bhs.s	loc_F8F0.return
		move.w	obY(a0),d0
		sub.w	d3,d0
;loc_19DDE:
PlatformObject_ChkYRange:
		move.w	obY(a1),d2
		move.b	obHeight(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.s	loc_F8F0.return
		cmpi.w	#-$10,d0
		blo.s	loc_F8F0.return
		cmpi.b	#6,obRoutine(a1)
		bhs.s	loc_F8F0.return
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,obY(a1)
;loc_19E14:
RideObject_SetRide:
		btst	#3,obStatus(a1)
		beq.s	loc_19E30
		moveq	#0,d0
		move.b	standonobject(a1),d0
	if object_size=$40
		lsl.w	#object_size_bits,d0
	else
		mulu.w	#object_size,d0
	endif
		addi.l	#v_objspace,d0
		movea.l	d0,a3	; a3=object
		bclr	#3,obStatus(a3)

loc_19E30:
		move.w	a0,d0
		subi.w	#v_objspace,d0
	if object_size=$40
		lsr.w	#object_size_bits,d0
	else
		divu.w	#object_size,d0
	endif
		andi.w	#$7F,d0
		move.b	d0,standonobject(a1)
		move.b	#0,obAngle(a1)
		move.w	#0,obVelY(a1)
		move.w	obVelX(a1),obInertia(a1)
		btst	#1,obStatus(a1)
		beq.s	loc_19E7E
		move.l	a0,-(sp)
		movea.l	a1,a0
		move.w	a0,d1
		subi.w	#v_objspace,d1
		bne.s	loc_19E7C
		jsr	(Sonic_ResetOnFloor).l

loc_19E7C:
		movea.l	(sp)+,a0 ; a0=character

loc_19E7E:
		bset	#3,obStatus(a1)
		bclr	#1,obStatus(a1)
		bset	#3,obStatus(a0)

return_19E8E:
		rts
; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; subroutine to make the bridge push down where Sonic or Tails walks over
; loc_F9E8:
Obj11_Depress:
		move.b	objoff_3E(a0),d0
		bsr.w	CalcSine
		move.w	d0,d4
		lea	byte_FB28(pc),a4
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.w	#4,d0
		moveq	#0,d3
		move.b	objoff_3F(a0),d3
		move.w	d3,d2
		add.w	d0,d3
		moveq	#0,d5
		lea	Obj11_DepressionOffsets-$80(pc),a5
		move.b	(a5,d3.w),d5
		andi.w	#$F,d3
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		movea.l	Obj11_child1(a0),a1
		lea	sub9_y_pos+next_subspr(a1),a2
		lea	sub2_y_pos(a1),a1

-		moveq	#0,d0
		move.b	(a3)+,d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	objoff_3C(a0),d0
		move.w	d0,(a1)
		addq.w	#6,a1
		cmpa.w	a2,a1
		bne.s	+
		movea.l	Obj11_child2(a0),a1 ; a1=object
		lea	sub2_y_pos(a1),a1
+		dbf	d2,-

		moveq	#0,d0
		move.b	obSubtype(a0),d0
		moveq	#0,d3
		move.b	objoff_3F(a0),d3
		addq.b	#1,d3
		sub.b	d0,d3
		neg.b	d3
		bmi.s	++	; rts
		move.w	d3,d2
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		adda.w	d2,a3
		subq.w	#1,d2
		bcs.s	++	; rts

-		moveq	#0,d0
		move.b	-(a3),d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	objoff_3C(a0),d0
		move.w	d0,(a1)
		addq.w	#6,a1
		cmpa.w	a2,a1
		bne.s	+
		movea.l	Obj11_child2(a0),a1 ; a1=object
		lea	sub2_y_pos(a1),a1
+		dbf	d2,-
+
		rts
; ===========================================================================
; seems to be bridge piece vertical position offset data
Obj11_DepressionOffsets: ; byte_FA98:
		dc.b   2,  4,  6,  8,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0,  0,  0; 16
		dc.b   2,  4,  6,  8, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0,  0; 32
		dc.b   2,  4,  6,  8, $A, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0; 48
		dc.b   2,  4,  6,  8, $A, $C, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0; 64
		dc.b   2,  4,  6,  8, $A, $C, $C, $A,  8,  6,  4,  2,  0,  0,  0,  0; 80
		dc.b   2,  4,  6,  8, $A, $C, $E, $C, $A,  8,  6,  4,  2,  0,  0,  0; 96
		dc.b   2,  4,  6,  8, $A, $C, $E, $E, $C, $A,  8,  6,  4,  2,  0,  0; 112
		dc.b   2,  4,  6,  8, $A, $C, $E,$10, $E, $C, $A,  8,  6,  4,  2,  0; 128
		dc.b   2,  4,  6,  8, $A, $C, $E,$10,$10, $E, $C, $A,  8,  6,  4,  2; 144

; something else important for bridge depression to work (phase? bridge size adjustment?)
byte_FB28:
		dc.b $FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 16
		dc.b $B5,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 32
		dc.b $7E,$DB,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 48
		dc.b $61,$B5,$EC,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 64
		dc.b $4A,$93,$CD,$F3,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 80
		dc.b $3E,$7E,$B0,$DB,$F6,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 96
		dc.b $38,$6D,$9D,$C5,$E4,$F8,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0; 112
		dc.b $31,$61,$8E,$B5,$D4,$EC,$FB,$FF,  0,  0,  0,  0,  0,  0,  0,  0; 128
		dc.b $2B,$56,$7E,$A2,$C1,$DB,$EE,$FB,$FF,  0,  0,  0,  0,  0,  0,  0; 144
		dc.b $25,$4A,$73,$93,$B0,$CD,$E1,$F3,$FC,$FF,  0,  0,  0,  0,  0,  0; 160
		dc.b $1F,$44,$67,$88,$A7,$BD,$D4,$E7,$F4,$FD,$FF,  0,  0,  0,  0,  0; 176
		dc.b $1F,$3E,$5C,$7E,$98,$B0,$C9,$DB,$EA,$F6,$FD,$FF,  0,  0,  0,  0; 192
		dc.b $19,$38,$56,$73,$8E,$A7,$BD,$D1,$E1,$EE,$F8,$FE,$FF,  0,  0,  0; 208
		dc.b $19,$38,$50,$6D,$83,$9D,$B0,$C5,$D8,$E4,$F1,$F8,$FE,$FF,  0,  0; 224
		dc.b $19,$31,$4A,$67,$7E,$93,$A7,$BD,$CD,$DB,$E7,$F3,$F9,$FE,$FF,  0; 240
		dc.b $19,$31,$4A,$61,$78,$8E,$A2,$B5,$C5,$D4,$E1,$EC,$F4,$FB,$FE,$FF; 256

		even