; ---------------------------------------------------------------------------
; Subroutine to	load a level's objects
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjPosLoad:
		move.w	(v_opl_routine).w,d0
		jmp	OPL_Index(pc,d0.w)
; End of function ObjPosLoad

; ===========================================================================
OPL_Index:	bra.w	OPL_Main
		bra.w	OPL_Next
; ===========================================================================

OPL_Main:
		move.l	#Obj_Index,(Object_index_addr).w
		addq.w	#4,(v_opl_routine).w
		lea	(Object_respawn_table).w,a0
		moveq	#0,d0
		move.w	#bytesToLcnt(Object_respawn_table_End-Object_respawn_table),d1

loc_1B6E2:
		move.l	d0,(a0)+
		dbf	d1,loc_1B6E2

loc_1B6E8:
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(ObjPos_Index).l,a0
		movea.l	(a0,d0.w),a0
		move.l	a0,(Object_load_addr_front).w
		move.l	a0,(Object_load_addr_back).w
		lea	(Object_respawn_table).w,a3
		move.w	(v_screenposx).w,d6
		subi.w	#$80,d6
		bcc.s	loc_1B79A
		moveq	#0,d6

loc_1B79A:
		andi.w	#$FF80,d6
		movea.l	(Object_load_addr_front).w,a0

loc_1B7A2:
		cmp.w	(a0),d6
		bls.s	loc_1B7AC
		addq.w	#6,a0
		addq.w	#1,a3
		bra.s	loc_1B7A2
; ---------------------------------------------------------------------------

loc_1B7AC:
		move.l	a0,(Object_load_addr_front).w
		move.w	a3,(Object_respawn_index_front).w
		lea	(Object_respawn_table).w,a3
		movea.l	(Object_load_addr_back).w,a0
		subi.w	#$80,d6
		bcs.s	loc_1B7D8

loc_1B7CE:
		cmp.w	(a0),d6
		bls.s	loc_1B7D8
		addq.w	#6,a0
		addq.w	#1,a3
		bra.s	loc_1B7CE
; ---------------------------------------------------------------------------

loc_1B7D8:
		move.l	a0,(Object_load_addr_back).w
		move.w	a3,(Object_respawn_index_back).w
		move.w	#-1,(Camera_X_pos_coarse).w
		move.w	(v_screenposy).w,d0
		andi.w	#$FF80,d0
		move.w	d0,(Camera_Y_pos_coarse).w

OPL_Next:
		move.w	(v_screenposy).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		move.w	d1,(Camera_Y_pos_coarse_back).w
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		move.w	d1,(Camera_X_pos_coarse_back).w
		movea.l	(Object_index_addr).w,a4
		tst.w	(v_limittop2).w
		bpl.s	loc_1B84A
		lea	loc_1BA40(pc),a6
		move.w	(v_screenposy).w,d3
		andi.w	#$FF80,d3
		move.w	d3,d4
		addi.w	#$200,d4
		subi.w	#$80,d3
		bpl.s	loc_1B860
		and.w	(Screen_Y_wrap_value).w,d3
		bra.s	loc_1B864
; ---------------------------------------------------------------------------

loc_1B83A:
		move.w	(Screen_Y_wrap_value).w,d0
		addq.w	#1,d0
		cmp.w	d0,d4
		bls.s	loc_1B860
		and.w	(Screen_Y_wrap_value).w,d4
		bra.s	loc_1B864
; ---------------------------------------------------------------------------

loc_1B84A:
		move.w	(v_screenposy).w,d3
		andi.w	#$FF80,d3
		move.w	d3,d4
		addi.w	#$200,d4
		subi.w	#$80,d3
		bpl.s	loc_1B860
		moveq	#0,d3

loc_1B860:
		lea	loc_1BA92(pc),a6

loc_1B864:
		move.w	#$FFF,d5
		move.w	(v_screenposx).w,d6
		andi.w	#$FF80,d6
		cmp.w	(Camera_X_pos_coarse).w,d6
		beq.w	loc_1B91A
		bge.s	loc_1B8D2
		move.w	d6,(Camera_X_pos_coarse).w
		movea.l	(Object_load_addr_back).w,a0
		movea.w	(Object_respawn_index_back).w,a3
		subi.w	#$80,d6
		bcs.s	loc_1B8A8
		bsr.w	FindFreeObj
		bne.s	loc_1B8A8

loc_1B892:
		cmp.w	-6(a0),d6
		bge.s	loc_1B8A8
		subq.w	#6,a0
		subq.w	#1,a3
		jsr	(a6)
		bne.s	loc_1B8A4
		subq.w	#6,a0
		bra.s	loc_1B892
; ---------------------------------------------------------------------------

loc_1B8A4:
		addq.w	#6,a0
		addq.w	#1,a3

loc_1B8A8:
		move.l	a0,(Object_load_addr_back).w
		move.w	a3,(Object_respawn_index_back).w
		movea.l	(Object_load_addr_front).w,a0
		movea.w	(Object_respawn_index_front).w,a3
		addi.w	#$300,d6

loc_1B8BC:
		cmp.w	-6(a0),d6
		bgt.s	loc_1B8C8
		subq.w	#6,a0
		subq.w	#1,a3
		bra.s	loc_1B8BC
; ---------------------------------------------------------------------------

loc_1B8C8:
		move.l	a0,(Object_load_addr_front).w
		move.w	a3,(Object_respawn_index_front).w
		bra.s	loc_1B91A
; ---------------------------------------------------------------------------

loc_1B8D2:
		move.w	d6,(Camera_X_pos_coarse).w
		movea.l	(Object_load_addr_front).w,a0
		movea.w	(Object_respawn_index_front).w,a3
		addi.w	#$280,d6
		bsr.w	FindFreeObj
		bne.s	loc_1B8F2

loc_1B8E8:
		cmp.w	(a0),d6
		bls.s	loc_1B8F2
		jsr	(a6)
		addq.w	#1,a3
		beq.s	loc_1B8E8

loc_1B8F2:
		move.l	a0,(Object_load_addr_front).w
		move.w	a3,(Object_respawn_index_front).w
		movea.l	(Object_load_addr_back).w,a0
		movea.w	(Object_respawn_index_back).w,a3
		subi.w	#$300,d6
		bcs.s	loc_1B912

loc_1B908:
		cmp.w	(a0),d6
		bls.s	loc_1B912
		addq.w	#6,a0
		addq.w	#1,a3
		bra.s	loc_1B908
; ---------------------------------------------------------------------------

loc_1B912:
		move.l	a0,(Object_load_addr_back).w
		move.w	a3,(Object_respawn_index_back).w

loc_1B91A:
		move.w	(v_screenposy).w,d6
		andi.w	#$FF80,d6
		move.w	d6,d3
		cmp.w	(Camera_Y_pos_coarse).w,d6
		beq.w	loc_1B9FA
		bge.s	loc_1B956
		tst.w	(v_limittop2).w
		bpl.s	loc_1B94C
		tst.w	d6
		bne.s	loc_1B940
		cmpi.w	#$80,(Camera_Y_pos_coarse).w
		bne.s	loc_1B968

loc_1B940:
		subi.w	#$80,d3
		bpl.s	loc_1B982
		and.w	(Screen_Y_wrap_value).w,d3
		bra.s	loc_1B982
; ---------------------------------------------------------------------------

loc_1B94C:
		subi.w	#$80,d3
		bmi.w	loc_1B9FA
		bra.s	loc_1B982
; ---------------------------------------------------------------------------

loc_1B956:
		tst.w	(v_limittop2).w
		bpl.s	loc_1B978
		tst.w	(Camera_Y_pos_coarse).w
		bne.s	loc_1B968
		cmpi.w	#$80,d6
		bne.s	loc_1B940

loc_1B968:
		addi.w	#$180,d3
		cmp.w	(Screen_Y_wrap_value).w,d3
		blo.s	loc_1B982
		and.w	(Screen_Y_wrap_value).w,d3
		bra.s	loc_1B982
; ---------------------------------------------------------------------------

loc_1B978:
		addi.w	#$180,d3
		cmp.w	(Screen_Y_wrap_value).w,d3
		bhi.s	loc_1B9FA

loc_1B982:
		bsr.w	FindFreeObj
		bne.s	loc_1B9FA
		move.w	d3,d4
		addi.w	#$80,d4
		move.w	#$FFF,d5
		movea.l	(Object_load_addr_back).w,a0
		movea.w	(Object_respawn_index_back).w,a3
		move.l	(Object_load_addr_front).w,d7
		sub.l	a0,d7
		beq.s	loc_1B9FA
		addq.w	#2,a0

loc_1B9A4:
		tst.b	(a3)
		bmi.s	loc_1B9F2
		move.w	(a0),d1
		and.w	d5,d1
		cmp.w	d3,d1
		blo.s	loc_1B9F2
		cmp.w	d4,d1
		bhi.s	loc_1B9F2
		bset	#7,(a3)
		move.w	-2(a0),obX(a1)
		move.w	(a0),d1
		move.w	d1,d2
		and.w	d5,d1
		move.w	d1,obY(a1)
		rol.w	#3,d2
		andi.w	#3,d2
		move.b	d2,obRender(a1)
		move.b	d2,obStatus(a1)
		move.b	2(a0),d2
		add.w	d2,d2
		add.w	d2,d2
		move.l	(a4,d2.w),obID(a1)
		move.b	3(a0),obSubtype(a1)
		move.w	a3,obRespawnNo(a1)
		bsr.w	CreateNewSprite4
		bne.s	loc_1B9FA

loc_1B9F2:
		addq.w	#6,a0
		addq.w	#1,a3
		subq.w	#6,d7
		bne.s	loc_1B9A4

loc_1B9FA:
		move.w	d6,(Camera_Y_pos_coarse).w
		rts

; =============== S U B R O U T I N E =======================================


sub_1BA0C:
		move.w	(a0)+,obX(a1)
		move.w	(a0)+,d1
		move.w	d1,d2
		andi.w	#$FFF,d1
		move.w	d1,obY(a1)
		rol.w	#3,d2
		andi.w	#3,d2
		move.b	d2,obRender(a1)
		move.b	d2,obStatus(a1)
		move.b	(a0)+,d2
		add.w	d2,d2
		add.w	d2,d2
		move.l	(a4,d2.w),obID(a1)
		move.b	(a0)+,obSubtype(a1)
		move.w	a3,obRespawnNo(a1)
;CreateNewSprite4:
		subq.w	#1,d0
		bmi.s	.found

.loop:
		lea	object_size(a1),a1
		tst.l	obID(a1)
		dbeq	d0,.loop

.found:
		rts
; ---------------------------------------------------------------------------

loc_1BA40:
		tst.b	(a3)
		bpl.s	loc_1BA4A
		addq.w	#6,a0
		moveq	#0,d1
		rts
; ---------------------------------------------------------------------------

loc_1BA4A:
		move.w	(a0)+,d7
		move.w	(a0)+,d1
		move.w	d1,d2
		bmi.s	loc_1BA62
		and.w	d5,d1
		cmp.w	d3,d1
		bhs.s	loc_1BA64
		cmp.w	d4,d1
		bls.s	loc_1BA64
		addq.w	#2,a0
		moveq	#0,d1
		rts
; ---------------------------------------------------------------------------

loc_1BA62:
		and.w	d5,d1

loc_1BA64:
		bset	#7,(a3)
		move.w	d7,obX(a1)
		move.w	d1,obY(a1)
		rol.w	#3,d2
		andi.w	#3,d2
		move.b	d2,obRender(a1)
		move.b	d2,obStatus(a1)
		move.b	(a0)+,d2
		add.w	d2,d2
		add.w	d2,d2
		move.l	(a4,d2.w),obID(a1)
		move.b	(a0)+,obSubtype(a1)
		move.w	a3,obRespawnNo(a1)
;CreateNewSprite4:
		subq.w	#1,d0
		bmi.s	.found

.loop:
		lea	object_size(a1),a1
		tst.l	obID(a1)
		dbeq	d0,.loop

.found:
		rts
; ---------------------------------------------------------------------------

loc_1BA92:
		tst.b	(a3)
		bpl.s	loc_1BA9C
		addq.w	#6,a0
		moveq	#0,d1
		rts
; ---------------------------------------------------------------------------

loc_1BA9C:
		move.w	(a0)+,d7
		move.w	(a0)+,d1
		move.w	d1,d2
		bmi.s	loc_1BAB4
		and.w	d5,d1
		cmp.w	d3,d1
		blo.s	loc_1BAAE
		cmp.w	d4,d1
		bls.s	loc_1BAB6

loc_1BAAE:
		addq.w	#2,a0
		moveq	#0,d1
		rts
; ---------------------------------------------------------------------------

loc_1BAB4:
		and.w	d5,d1

loc_1BAB6:
		bset	#7,(a3)
		move.w	d7,obX(a1)
		move.w	d1,obY(a1)
		rol.w	#3,d2
		andi.w	#3,d2
		move.b	d2,obRender(a1)
		move.b	d2,obStatus(a1)
		move.b	(a0)+,d2
		add.w	d2,d2
		add.w	d2,d2
		move.l	(a4,d2.w),obID(a1)
		move.b	(a0)+,obSubtype(a1)
		move.w	a3,obRespawnNo(a1)

CreateNewSprite4:
		subq.w	#1,d0
		bmi.s	locret_1BAF0

loc_1BAE6:
		lea	object_size(a1),a1
		tst.l	obID(a1)
		dbeq	d0,loc_1BAE6

locret_1BAF0:
		rts
; End of function sub_1BA0C