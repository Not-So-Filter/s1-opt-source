; ---------------------------------------------------------------------------
; Object 25 - rings
; ---------------------------------------------------------------------------

Rings:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Ring_Index(pc,d0.w),d1
		jmp	Ring_Index(pc,d1.w)
; ===========================================================================
Ring_Index:
ptr_Ring_Main:		dc.w Ring_Main-Ring_Index
ptr_Ring_Animate:	dc.w Ring_Animate-Ring_Index
ptr_Ring_Collect:	dc.w Ring_Collect-Ring_Index
ptr_Ring_Sparkle:	dc.w Ring_Sparkle-Ring_Index
ptr_Ring_Delete:	dc.w Ring_Delete-Ring_Index

id_Ring_Main = ptr_Ring_Main-Ring_Index	; 0
id_Ring_Animate = ptr_Ring_Animate-Ring_Index	; 2
id_Ring_Collect = ptr_Ring_Collect-Ring_Index	; 4
id_Ring_Sparkle = ptr_Ring_Sparkle-Ring_Index	; 6
id_Ring_Delete = ptr_Ring_Delete-Ring_Index	; 8
; ===========================================================================

Ring_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	obX(a0),objoff_32(a0)
		move.l	#Map_Ring,obMap(a0)
		move.w	#make_art_tile(ArtTile_Ring,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$47,obColType(a0)
		move.b	#8,obActWid(a0)

Ring_Animate:	; Routine 2
		move.b	(v_ani1_frame).w,obFrame(a0) ; set frame
		out_of_range.s	Ring_Delete,objoff_32(a0)
		move.w	#2*$80,d0
		bra.w	DisplaySprite2
; ===========================================================================

Ring_Collect:	; Routine 4
		addq.b	#2,obRoutine(a0)
		clr.b	obColType(a0)
		bsr.s	CollectRing

Ring_Sparkle:	; Routine 6
		lea	Ani_Ring(pc),a1
		bsr.w	AnimateSprite
		move.w	#1*$80,d0
		bra.w	DisplaySprite2
; ===========================================================================

Ring_Delete:	; Routine 8
		bra.w	DeleteObject

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


CollectRing:
		addq.w	#1,(v_rings).w	; add 1 to rings
		st.b	(f_ringcount).w ; update the rings counter
		moveq	#sfx_Ring,d0	; play ring sound
		cmpi.w	#100,(v_rings).w ; do you have < 100 rings?
		blo.s	.playsnd	; if yes, branch
		addq.b	#1,(v_lifecount).w ; update lives counter
		bpl.s	.got100
		cmpi.w	#200,(v_rings).w ; do you have < 200 rings?
		blo.s	.playsnd	; if yes, branch
		addq.b	#1,(v_lifecount).w ; update lives counter
;		bne.s	.playsnd

.got100:
		addq.b	#1,(v_lives).w	; add 1 to the number of lives you have
		addq.b	#1,(f_lifecount).w ; update the lives counter
		moveq	#bgm_ExtraLife,d0 ; play extra life music
		jmp	(PlayMusic).w

.playsnd:
		jmp	(PlaySound).w
; End of function CollectRing

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 37 - rings flying out of Sonic	when he's hit
; ---------------------------------------------------------------------------

RingLoss:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	RLoss_Index(pc,d0.w),d1
		jmp	RLoss_Index(pc,d1.w)
; ===========================================================================
RLoss_Index:	dc.w RLoss_Count-RLoss_Index
		dc.w RLoss_Bounce-RLoss_Index
		dc.w Ring_Collect-RLoss_Index
		dc.w Ring_Sparkle-RLoss_Index
		dc.w RLoss_Delete-RLoss_Index
; ===========================================================================

RLoss_Count:	; Routine 0
		movea.l	a0,a1
		moveq	#0,d5
		move.w	(v_rings).w,d5	; check number of rings you have
		moveq	#32,d0
		cmp.w	d0,d5		; do you have 32 or more?
		blo.s	.belowmax	; if not, branch
		move.w	d0,d5		; if yes, set d5 to 32

.belowmax:
		subq.w	#1,d5
		move.w	#$288,d4
		bra.s	.makerings
; ===========================================================================

.loop:
		bsr.w	FindFreeObj
		bne.w	.resetcounter

.makerings:
		move.l	#RingLoss,obID(a1) ; load bouncing ring object
		addq.b	#2,obRoutine(a1)
		move.b	#8,obHeight(a1)
		move.b	#8,obWidth(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l	#Map_Ring,obMap(a1)
		move.w	#make_art_tile(ArtTile_Ring,1,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$47,obColType(a1)
		move.b	#8,obActWid(a1)
		st.b	(v_ani2_time).w
		tst.w	d4
		bmi.s	.loc_9D62
		move.w	d4,d0
		bsr.w	CalcSine
		move.w	d4,d2
		move.w	d2,-(sp)
		clr.w	d2
		move.b	(sp)+,d2
		asl.w	d2,d0
		asl.w	d2,d1
		move.w	d0,d2
		move.w	d1,d3
		addi.b	#$10,d4
		bcc.s	.loc_9D62
		subi.w	#$80,d4
		bcc.s	.loc_9D62
		move.w	#$288,d4

.loc_9D62:
		move.w	d2,obVelX(a1)
		move.w	d3,obVelY(a1)
		neg.w	d2
		neg.w	d4
		dbf	d5,.loop	; repeat for number of rings (max 31)

.resetcounter:
		moveq	#0,d0
		move.w	d0,(v_rings).w	; reset number of rings to zero
		move.b	#$80,(f_ringcount).w ; update ring counter
		move.b	d0,(v_lifecount).w
		moveq	#sfx_RingLoss,d0
		jsr	(PlaySound).w	; play ring loss sound

RLoss_Bounce:	; Routine 2
		move.b	(v_ani2_frame).w,obFrame(a0)
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		bmi.s	.chkdel
		move.b	(v_vbla_byte).w,d0
		add.b	d7,d0
		andi.b	#7,d0
		bne.s	.chkdel
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	.chkdel
		add.w	d1,obY(a0)
		move.w	obVelY(a0),d0
		asr.w	#2,d0
		sub.w	d0,obVelY(a0)
		neg.w	obVelY(a0)

.chkdel:
		tst.b	(v_ani2_time).w
		beq.s	RLoss_Delete
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	obY(a0),d0	; has object moved below level boundary?
		blo.s	RLoss_Delete	; if yes, branch
		move.w	#3*$80,d0
		bra.w	DisplaySprite2
; ===========================================================================

RLoss_Delete:	; Routine 8
		bra.w	DeleteObject
