; ===========================================================================
; ----------------------------------------------------------------------------
; Pseudo-object that manages where rings are placed onscreen
; as you move through the level, and otherwise updates them.
; This is a version ported from Sonic 3 & Knuckles
; ----------------------------------------------------------------------------

; loc_16F88:
RingsManager:
		move.w	(Rings_manager_routine).w,d0
		jmp	RingsManager_States(pc,d0.w)
; ===========================================================================
; off_16F96:
RingsManager_States:
		bra.s	RingsManager_Init
		bra.s	RingsManager_Main
; ===========================================================================
; loc_16F9A:
RingsManager_Init:
		addq.w	#2,(Rings_manager_routine).w ; => RingsManager_Main
		bsr.w	RingsManager_Setup	; perform initial setup
		movea.l	(Ring_start_addr_ROM).w,a1
		lea	(Ring_Positions).w,a2
		move.w	(v_screenposx).w,d4
		subq.w	#8,d4
		bhi.s	+
		moveq	#1,d4	; no negative values allowed
		bra.s	+
-
		addq.w	#4,a1	; load next ring
		addq.w	#2,a2
+
		cmp.w	(a1),d4	; is the X pos of the ring < camera X pos?
		bhi.s	-		; if it is, check next ring
		move.l	a1,(Ring_start_addr_ROM).w	; set start addresses in both ROM and RAM
		move.w	a2,(Ring_start_addr_RAM).w
		addi.w	#320+16,d4	; advance by a screen
		bra.s	+
-
		addq.w	#4,a1	; load next ring
+
		cmp.w	(a1),d4		; is the X pos of the ring < camera X + 336?
		bhi.s	-	; if it is, check next ring
		move.l	a1,(Ring_end_addr_ROM).w	; set end addresses
		rts
; ===========================================================================
; loc_16FDE:
RingsManager_Main:
		lea	(Ring_consumption_table).w,a2
		move.w	(a2)+,d1
		subq.w	#1,d1	; are any rings currently being consumed?
		bcs.s	++	; if not, branch

-		move.w	(a2)+,d0	; is there a ring in this slot?
		beq.s	-	; if not, branch
		movea.w	d0,a1	; load ring address
		subq.b	#1,(a1)	; decrement timer
		bne.s	+	; if it's not 0 yet, branch
		move.b	#6,(a1)	; reset timer
		addq.b	#1,1(a1); increment frame
		cmpi.b	#8,1(a1); is it destruction time yet?
		bne.s	+	; if not, branch
		move.w	#-1,(a1); destroy ring
		clr.w	-2(a2)	; clear ring entry
		subq.w	#1,(Ring_consumption_table).w	; subtract count
+		dbf	d1,-	; repeat for all rings in table
+
		; update ring start addresses
		movea.l	(Ring_start_addr_ROM).w,a1
		movea.w	(Ring_start_addr_RAM).w,a2
		move.w	(v_screenposx).w,d4
		subq.w	#8,d4
		bhi.s	+
		moveq	#1,d4
		bra.s	+
-
		addq.w	#4,a1
		addq.w	#2,a2
+
		cmp.w	(a1),d4
		bhi.s	-
		bra.s	+
-
		subq.w	#4,a1
		subq.w	#2,a2
+
		cmp.w	-4(a1),d4
		bls.s	-
		move.l	a1,(Ring_start_addr_ROM).w	; update start addresses
		move.w	a2,(Ring_start_addr_RAM).w
		movea.l	(Ring_end_addr_ROM).w,a2	; set end address
		addi.w	#320+16,d4	; advance by a screen
		bra.s	+
-
		addq.w	#4,a2
+
		cmp.w	(a2),d4
		bhi.s	-
		bra.s	+
-
		subq.w	#4,a2
+
		cmp.w	-4(a2),d4
		bls.s	-
		move.l	a2,(Ring_end_addr_ROM).w	; update end address
		rts

; ---------------------------------------------------------------------------
; Subroutine to handle ring collision
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_170BA:
Touch_Rings:
		cmpi.b	#$5A,flashtime(a0)
		bhs.w	Touch_Rings_Done
		movea.l	(Ring_start_addr_ROM).w,a1	; load start and end addresses
		movea.l	(Ring_end_addr_ROM).w,a2
		cmpa.l	a1,a2	; are there no rings in this area?
		beq.w	Touch_Rings_Done	; if so, return
		movea.w	(Ring_start_addr_RAM).w,a4	; load start address
		move.w	obX(a0),d2	; get character's position
		move.w	obY(a0),d3
		subq.w	#8,d2	; assume X radius to be 8
		moveq	#0,d5
		move.b	obHeight(a0),d5
		subq.b	#3,d5
		sub.w	d5,d3	; subtract (Y radius - 3) from Y pos
		cmpi.b	#fr_Duck,obAnim(a0)
		bne.s	+	; if you're not ducking, branch
		addi.w	#$C,d3
		moveq	#$A,d5
+
		moveq	#6,d1	; set ring radius
		moveq	#$C,d6	; set ring diameter
		moveq	#$10,d4	; set character's X diameter
		add.w	d5,d5	; set Y diameter
; loc_17112:
Touch_Rings_Loop:
		tst.w	(a4)	; has this ring already been collided with?
		bne.s	Touch_NextRing	; if it has, branch
		move.w	(a1),d0		; get ring X pos
		sub.w	d1,d0		; get ring left edge X pos
		sub.w	d2,d0		; subtract character's left edge X pos
		bcc.s	+		; if character's to the left of the ring, branch
		add.w	d6,d0		; add ring diameter
		bcs.s	++		; if character's colliding, branch
		bra.s	Touch_NextRing	; otherwise, test next ring
+
		cmp.w	d4,d0		; has character crossed the ring?
		bhi.s	Touch_NextRing	; if they have, branch
+
		move.w	2(a1),d0	; get ring Y pos
		sub.w	d1,d0		; get ring top edge pos
		sub.w	d3,d0		; subtract character's top edge pos
		bcc.s	+		; if character's above the ring, branch
		add.w	d6,d0		; add ring diameter
		bcs.s	++		; if character's colliding, branch
		bra.s	Touch_NextRing	; otherwise, test next ring
+
		cmp.w	d5,d0		; has character crossed the ring?
		bhi.s	Touch_NextRing	; if they have, branch
+
-
		move.w	#$604,(a4)		; set frame and destruction timer
		bsr.s	Touch_ConsumeRing
		lea	(Ring_consumption_table+2).w,a3

-		tst.w	(a3)+		; is this slot free?
		bne.s	-		; if not, repeat until you find one
		move.w	a4,-(a3)	; set ring address
		addq.w	#1,(Ring_consumption_table).w	; increase count
; loc_1715C:
Touch_NextRing:
		addq.w	#4,a1
		addq.w	#2,a4
		cmpa.l	a1,a2		; are we at the last ring for this area?
		bne.s	Touch_Rings_Loop	; if not, branch
; return_17166:
Touch_Rings_Done:
		rts
; ===========================================================================
; loc_17168:
Touch_ConsumeRing:
		subq.w	#1,(Perfect_rings_left).w
		bra.w	CollectRing

; ---------------------------------------------------------------------------
; Subroutine to draw on-screen rings
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_17178:
BuildRings:
		movea.l	(Ring_start_addr_ROM).w,a0
		move.l	(Ring_end_addr_ROM).w,d2
		sub.l	a0,d2		; are there any rings on-screen?
		beq.s	++		; if there aren't, branch
		movea.w	(Ring_start_addr_RAM).w,a4	; load start address
		lea	MapUnc_Rings(pc),a1
		move.w	4(a3),d4
		move.w	#$F0,d5
		move.w	#$7FF,d3

BuildRings_Loop:
		tst.w	(a4)+		; has this ring been consumed?
		bmi.s	BuildRings_NextRing	; if it has, branch
		move.w	2(a0),d1		; get ring X pos
		sub.w	d4,d1		; subtract camera X pos
		addq.w	#8,d1
		and.w	d3,d1
		cmp.w	d5,d1
		bhs.s	BuildRings_NextRing	; if the ring is not on-screen, branch
		addi.w	#128-8,d1
		move.w	(a0),d0
		sub.w	(a3),d0
		addi.w	#$80,d0
		move.b	-1(a4),d6	; get ring frame
		bne.s	+		; if this ring is using a specific frame, branch
		move.b	(v_ani1_frame).w,d6	; use global frame
+
		lsl.w	#3,d6
		lea	(a1,d6.w),a2	; get frame data address
		add.w	(a2)+,d1	; get Y offset
		move.w	d1,(a6)+
		move.w	(a2)+,d6
		move.b	d6,(a6)
		addq.w	#2,a6
		move.w	(a2)+,(a6)+
		add.w	(a2)+,d0
		move.w	d0,(a6)+
		subq.w	#1,d7
; loc_171EC:
BuildRings_NextRing:
		addq.w	#4,a0
		subq.w	#4,d2
		bne.s	BuildRings_Loop
+
		rts

; ---------------------------------------------------------------------------
; Subroutine to perform initial rings manager setup
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_172A4:
RingsManager_Setup:
		clearRAM Ring_Positions,Ring_Positions_End
		; d0 = 0
		lea	(Ring_consumption_table).w,a1
		moveq	#bytesToLcnt(Ring_consumption_table_End-Ring_consumption_table),d1
-		move.l	d0,(a1)+
		dbf	d1,-

		move.w	(v_zone).w,d0	; get the current zone and act
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(RingPos_Index).l,a1	; get the rings for the act
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		move.l	a1,(Ring_start_addr_ROM).w
		addq.w	#4,a1
		moveq	#0,d5
		move.w	#(Max_Rings-1),d0
-
		tst.l	(a1)+	; get the next ring
		bmi.s	+		; if there's no more, carry on
		addq.w	#1,d5	; increment perfect counter
		dbf	d0,-
+
		move.w	d5,(Perfect_rings_left).w	; set the perfect ring amount for the act
		rts
; ===========================================================================

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------

; off_1736A:
MapUnc_Rings: mappingsTable
	mappingsTableEntry.w .frame1
	mappingsTableEntry.w .frame2
	mappingsTableEntry.w .frame3
	mappingsTableEntry.w .frame4
	mappingsTableEntry.w .frame5
	mappingsTableEntry.w .frame6
	mappingsTableEntry.w .frame7
	mappingsTableEntry.w .frame8

.frame1:
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0

.frame2:
	spritePiece	-8, -8, 2, 2, 4, 0, 0, 0, 0

.frame3:
	spritePiece	-4, -8, 1, 2, 8, 0, 0, 0, 0

.frame4:
	spritePiece	-8, -8, 2, 2, 4, 1, 0, 0, 0

.frame5:
	spritePiece	-8, -8, 2, 2, $A, 0, 0, 0, 0

.frame6:
	spritePiece	-8, -8, 2, 2, $A, 1, 1, 0, 0

.frame7:
	spritePiece	-8, -8, 2, 2, $A, 1, 0, 0, 0

.frame8:
	spritePiece	-8, -8, 2, 2, $A, 0, 1, 0, 0