; ---------------------------------------------------------------------------
; Sonic	graphics loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_LoadGfx:
		moveq	#0,d0
		move.b	obFrame(a0),d0	; load frame number
		cmp.b	(v_sonframenum).w,d0 ; has frame changed?
		beq.s	.nochange	; if not, branch

		move.b	d0,(v_sonframenum).w
		lea	SonicDynPLC(pc),a2 ; load PLC script
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5	; read "number of entries" value
		subq.w	#1,d5
		bmi.s	.nochange	; if zero, branch
		move.w	#(ArtTile_Sonic)*tile_size,d4

.readentry:
		moveq	#0,d1
		move.w	(a2)+,d1
		move.w	d1,-(sp)
		move.b	(sp)+,d3
		andi.w	#$F0,d3
		addi.w	#$10,d3
		andi.w	#$FFF,d1
		lsl.l	#4,d1
		addi.l	#dmaSource(Art_Sonic),d1
		move.w	d4,d2
		add.w	d3,d4
		add.w	d3,d4
		jsr	(QueueDMATransfer).w
		dbf	d5,.readentry	; repeat for number of entries

.nochange:
		rts

; End of function Sonic_LoadGfx