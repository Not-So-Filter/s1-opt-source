; ---------------------------------------------------------------------------
; Palette cycling routine loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteCycle:
		move.w	(v_zone).w,d0
		ror.b	#2,d0
		lsr.w	#5,d0
		movea.w	PalCycle_Index(pc,d0.w),a0
		jmp	(a0) ; jump to relevant palette routine
; End of function PaletteCycle

; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routines
; ---------------------------------------------------------------------------
PalCycle_Index:
		dc.w PalCycle_GHZ	; Green Hill Zone Act 1
		dc.w PalCycle_GHZ	; Green Hill Zone Act 2
		dc.w PalCycle_GHZ	; Green Hill Zone Act 3
		dc.w PalCycle_GHZ	; Green Hill Zone Act 4
		dc.w PalCycle_LZ	; Labyrinth Zone Act 1
		dc.w PalCycle_LZ	; Labyrinth Zone Act 2
		dc.w PalCycle_LZ	; Labyrinth Zone Act 3
		dc.w PalCycle_LZ	; Scrap Brain Zone Act 3
		dc.w PalCycle_MZ	; Marble Zone Act 1
		dc.w PalCycle_MZ	; Marble Zone Act 2
		dc.w PalCycle_MZ	; Marble Zone Act 3
		dc.w PalCycle_MZ	; Marble Zone Act 4
		dc.w PalCycle_SLZ	; Star Light Zone Act 1
		dc.w PalCycle_SLZ	; Star Light Zone Act 2
		dc.w PalCycle_SLZ	; Star Light Zone Act 3
		dc.w PalCycle_SLZ	; Star Light Zone Act 4
		dc.w PalCycle_SYZ	; Spring Yard Zone Act 1
		dc.w PalCycle_SYZ	; Spring Yard Zone Act 2
		dc.w PalCycle_SYZ	; Spring Yard Zone Act 3
		dc.w PalCycle_SYZ	; Spring Yard Zone Act 4
		dc.w PalCycle_SBZ	; Scrap Brain Zone Act 1
		dc.w PalCycle_SBZ	; Scrap Brain Zone Act 2
		dc.w PalCycle_SBZ	; Final Zone
		dc.w PalCycle_SBZ	; Scrap Brain Zone Act 4


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_Title:
		lea	Pal_TitleCyc(pc),a0
		bra.s	PCycGHZ_Go
; ===========================================================================

PalCycle_GHZ:
		lea	Pal_GHZCyc(pc),a0

PCycGHZ_Go:
		subq.w	#1,(v_pcyc_time).w ; decrement timer
		bpl.s	PCycGHZ_Skip	; if time remains, branch

		move.w	#5,(v_pcyc_time).w ; reset timer to 5 frames
		move.w	(v_pcyc_num).w,d0 ; get cycle number
		addq.w	#1,(v_pcyc_num).w ; increment cycle number
		andi.w	#3,d0		; if cycle > 3, reset to 0
		lsl.w	#3,d0
		lea	(v_palette+$50).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)	; copy palette data to RAM

PCycGHZ_Skip:
		rts
; End of function PalCycle_GHZ


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_LZ:
; Waterfalls
		subq.w	#1,(v_pcyc_time).w ; decrement timer
		bpl.s	PCycLZ_Skip1	; if time remains, branch

		move.w	#2,(v_pcyc_time).w ; reset timer to 2 frames
		move.w	(v_pcyc_num).w,d0
		addq.w	#1,(v_pcyc_num).w ; increment cycle number
		andi.w	#3,d0		; if cycle > 3, reset to 0
		lsl.w	#3,d0
		lea	Pal_LZCyc1(pc),a0
		cmpi.b	#3,(v_act).w	; check if level is SBZ3
		bne.s	PCycLZ_NotSBZ3
		lea	Pal_SBZ3Cyc(pc),a0 ; load SBZ3	palette instead

PCycLZ_NotSBZ3:
		lea	(v_palette+$56).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)
		lea	(v_palette_water+$56).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)

PCycLZ_Skip1:
; Conveyor belts
		move.w	(v_framecount).w,d0
		andi.w	#7,d0
		move.b	PCycLZ_Seq(pc,d0.w),d0 ; get byte from palette sequence
		beq.s	PCycLZ_Skip2	; if byte is 0, branch
		moveq	#1,d1
		tst.b	(f_conveyrev).w	; have conveyor belts been reversed?
		beq.s	PCycLZ_NoRev	; if not, branch
		neg.w	d1

PCycLZ_NoRev:
		move.w	(v_pal_buffer).w,d0
		andi.w	#3,d0
		add.w	d1,d0
		cmpi.w	#3,d0
		blo.s	loc_1A0A
		move.w	d0,d1
		moveq	#0,d0
		tst.w	d1
		bpl.s	loc_1A0A
		moveq	#2,d0

loc_1A0A:
		move.w	d0,(v_pal_buffer).w
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	Pal_LZCyc2(pc),a0
		lea	(v_palette+$76).w,a1
		move.l	(a0,d0.w),(a1)+
		move.w	4(a0,d0.w),(a1)
		lea	Pal_LZCyc3(pc),a0
		lea	(v_palette_water+$76).w,a1
		move.l	(a0,d0.w),(a1)+
		move.w	4(a0,d0.w),(a1)

PCycLZ_Skip2:
PalCycle_MZ:
		rts
; End of function PalCycle_LZ

; ===========================================================================
PCycLZ_Seq:	dc.b 1,	0, 0, 1, 0, 0, 1, 0
; ===========================================================================

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_SLZ:
		subq.w	#1,(v_pcyc_time).w
		bpl.s	locret_1A80
		move.w	#7,(v_pcyc_time).w
		move.w	(v_pcyc_num).w,d0
		addq.w	#1,d0
		cmpi.w	#6,d0
		blo.s	loc_1A60
		moveq	#0,d0

loc_1A60:
		move.w	d0,(v_pcyc_num).w
		move.w	d0,d1
		add.w	d1,d1
		add.w	d1,d0
		add.w	d0,d0
		lea	Pal_SLZCyc(pc),a0
		lea	(v_palette+$56).w,a1
		move.w	(a0,d0.w),(a1)
		move.l	2(a0,d0.w),4(a1)

locret_1A80:
		rts
; End of function PalCycle_SLZ


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_SYZ:
		subq.w	#1,(v_pcyc_time).w
		bpl.s	locret_1AC6
		move.w	#5,(v_pcyc_time).w
		move.w	(v_pcyc_num).w,d0
		addq.w	#1,(v_pcyc_num).w
		andi.w	#3,d0
		add.w	d0,d0
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		lea	Pal_SYZCyc1(pc),a0
		lea	(v_palette+$6E).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)
		lea	Pal_SYZCyc2(pc),a0
		lea	(v_palette+$76).w,a1
		move.w	(a0,d1.w),(a1)
		move.w	2(a0,d1.w),4(a1)

locret_1AC6:
		rts
; End of function PalCycle_SYZ


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_SBZ:
		lea	Pal_SBZCycList1(pc),a2
		tst.b	(v_act).w
		beq.s	loc_1ADA
		lea	Pal_SBZCycList2(pc),a2

loc_1ADA:
		lea	(v_pal_buffer).w,a1
		move.w	(a2)+,d1

loc_1AE0:
		subq.b	#1,(a1)
		bmi.s	loc_1AEA
		addq.l	#2,a1
		addq.l	#6,a2
		bra.s	loc_1B06
; ===========================================================================

loc_1AEA:
		move.b	(a2)+,(a1)+
		move.b	(a1),d0
		addq.b	#1,d0
		cmp.b	(a2)+,d0
		blo.s	loc_1AF6
		moveq	#0,d0

loc_1AF6:
		move.b	d0,(a1)+
		andi.w	#$F,d0
		add.w	d0,d0
		movea.w	(a2)+,a0
		movea.w	(a2)+,a3
		move.w	(a0,d0.w),(a3)

loc_1B06:
		dbf	d1,loc_1AE0
		subq.w	#1,(v_pcyc_time).w
		bpl.s	locret_1B64
		lea	Pal_SBZCyc4(pc),a0
		move.w	#1,(v_pcyc_time).w
		tst.b	(v_act).w
		beq.s	loc_1B2E
		lea	Pal_SBZCyc10(pc),a0
		move.w	#0,(v_pcyc_time).w

loc_1B2E:
		moveq	#-1,d1
		tst.b	(f_conveyrev).w
		beq.s	loc_1B38
		neg.w	d1

loc_1B38:
		move.w	(v_pcyc_num).w,d0
		andi.w	#3,d0
		add.w	d1,d0
		cmpi.w	#3,d0
		blo.s	loc_1B52
		move.w	d0,d1
		moveq	#0,d0
		tst.w	d1
		bpl.s	loc_1B52
		moveq	#2,d0

loc_1B52:
		move.w	d0,(v_pcyc_num).w
		add.w	d0,d0
		lea	(v_palette+$58).w,a1
		move.l	(a0,d0.w),(a1)+
		move.w	4(a0,d0.w),(a1)

locret_1B64:
		rts
; End of function PalCycle_SBZ
