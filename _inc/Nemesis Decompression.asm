; ---------------------------------------------------------------------------
; Nemesis decompression	subroutine, decompresses art directly to VRAM
; Inputs:
; a0 = art address

; For format explanation see http://info.sonicretro.org/Nemesis_compression
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Nemesis decompression to VRAM
NemDec:
		lea	NemPCD_WriteRowToVDP(pc),a3	; write all data to the same location
		lea	(vdp_data_port).l,a4	; specifically, to the VDP data port
		lea	(v_ngfx_buffer).w,a1
		move.w	(a0)+,d2	; get number of patterns
		bpl.s	loc_146A	; branch if the sign bit isn't set
		lea	NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP(a3),a3	; otherwise the file uses XOR mode

loc_146A:
		lsl.w	#3,d2	; get number of 8-pixel rows in the uncompressed data
		movea.w	d2,a5	; and store it in a5 because there aren't any spare data registers
		moveq	#8-1,d3	; 8 pixels in a pattern row
		moveq	#0,d2
		moveq	#0,d4
		bsr.w	NemDec_BuildCodeTable
		move.b	(a0)+,-(sp)	; get first byte of compressed data
		move.w	(sp)+,d5
		move.b	(a0)+,d5	; get second byte of compressed data
		moveq	#$10,d6	; set initial shift value
; End of function NemDec

; ---------------------------------------------------------------------------
; Part of the Nemesis decompressor, processes the actual compressed data
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


NemDec_ProcessCompressedData:
		move.b	d6,d7
		subq.b	#8,d7	; get shift value
		move.w	d5,d1
		lsr.w	d7,d1	; shift so that high bit of the code is in bit position 7
		cmpi.b	#%11111100,d1	; are the high 6 bits set?
		bhs.s	NemPCD_InlineData	; if they are, it signifies inline data
		andi.w	#$FF,d1
		add.w	d1,d1
		sub.b	(a1,d1.w),d6	; get the length of the code in bits and subtract from shift value so that the next code is read next time around
		moveq	#0,d0
		move.b	1(a1,d1.w),d0

loc_74978:
		cmpi.b	#9,d6	; does a new byte need to be read?
		bhs.s	NemPCD_ProcessCompressedData	; if not, branch
		addq.b	#8,d6
;		asl.w	#8,d5
		move.b	d5,-(sp)
		move.w	(sp)+,d5
		clr.b	d5
		move.b	(a0)+,d5	; read next byte

NemPCD_ProcessCompressedData:
		moveq   #$F,d1
		and.w   d0,d1
		lsr.w   #4,d0

NemPCD_WritePixel:
		lsl.l	#4,d4	; shift up by a nybble
		or.b	d1,d4	; write pixel
		dbf	d3,NemPCD_WritePixel_Loop	; if not, loop
		jmp	(a3)	; otherwise, write the row to its destination, by doing a dynamic jump to NemPCD_WriteRowToVDP, NemDec_WriteAndAdvance, NemPCD_WriteRowToVDP_XOR, or NemDec_WriteAndAdvance_XOR
; End of function NemDec_ProcessCompressedData


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


NemPCD_NewRow:
		moveq	#0,d4	; reset row
		moveq	#8-1,d3	; reset nybble counter

NemPCD_WritePixel_Loop:
		dbf	d0,NemPCD_WritePixel
		bra.s	NemDec_ProcessCompressedData
; ===========================================================================

NemPCD_InlineData:
		cmpi.b	#9+6,d6
		bhs.s	loc_14E4
		addq.b	#8,d6
;		asl.w	#8,d5
		move.b	d5,-(sp)
		move.w	(sp)+,d5
		clr.b	d5
		move.b	(a0)+,d5

loc_14E4:
		subi.b	#7+6,d6	; and 7 bits needed for the inline data itself
		move.w	d5,d1
		lsr.w	d6,d1	; shift so that low bit of the code is in bit position 0
		moveq   #$7F,d0
		and.w   d1,d0
		bra.s   loc_74978
; End of function NemPCD_NewRow

; ===========================================================================

NemPCD_WriteRowToVDP:
		move.l	d4,(a4)	; write 8-pixel row
		subq.w	#1,a5
		move.w	a5,d4	; have all the 8-pixel rows been written?
		bne.s	NemPCD_NewRow	; if not, branch
		rts		; otherwise the decompression is finished
; ===========================================================================
NemPCD_WriteRowToVDP_XOR:
		eor.l	d4,d2	; XOR the previous row by the current row
		move.l	d2,(a4)	; and write the result
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	NemPCD_NewRow
		rts

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
; Part of the Nemesis decompressor, builds the code table (in RAM)
; ---------------------------------------------------------------------------


NemDec_BuildCodeTable:
		move.b	(a0)+,d0	; read first byte

NemBCT_ChkEnd:
		addq.b	#1,d0	; has the end of the code table description been reached?
		bne.s	NemBCT_NewPALIndex	; if not, branch
		rts	; otherwise, this subroutine's work is done
; ===========================================================================

NemBCT_NewPALIndex:
		subq.b	#1,d0
		move.b	d0,d7

NemBCT_Loop:
		move.b	(a0)+,d0	; read next byte
		bmi.s	NemBCT_ChkEnd

		moveq	#$F,d1
		and.w	d1,d7
		and.w	d0,d1
		ext.w	d0
		add.w	d0,d0
		or.w	word_74A1E(pc,d0.w),d7
		subq.w	#8,d1
		neg.w	d1
		move.b	(a0)+,d0
		lsl.w	d1,d0
		add.w	d0,d0
		moveq	#1,d5
		lsl.w	d1,d5
		subq.w	#1,d5

NemBCT_ShortCode_Loop:
		move.w	d7,(a1,d0.w)	; store entry
		addq.w	#2,d0	; increment index
		dbf	d5,NemBCT_ShortCode_Loop	; repeat for required number of entries
		bra.s	NemBCT_Loop
; End of function NemDec_BuildCodeTable

word_74A1E:	dc.w 0
		dc.w $100
		dc.w $200
		dc.w $300
		dc.w $400
		dc.w $500
		dc.w $600
		dc.w $700
		dc.w $800
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $10
		dc.w $110
		dc.w $210
		dc.w $310
		dc.w $410
		dc.w $510
		dc.w $610
		dc.w $710
		dc.w $810
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $20
		dc.w $120
		dc.w $220
		dc.w $320
		dc.w $420
		dc.w $520
		dc.w $620
		dc.w $720
		dc.w $820
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $30
		dc.w $130
		dc.w $230
		dc.w $330
		dc.w $430
		dc.w $530
		dc.w $630
		dc.w $730
		dc.w $830
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $40
		dc.w $140
		dc.w $240
		dc.w $340
		dc.w $440
		dc.w $540
		dc.w $640
		dc.w $740
		dc.w $840
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $50
		dc.w $150
		dc.w $250
		dc.w $350
		dc.w $450
		dc.w $550
		dc.w $650
		dc.w $750
		dc.w $850
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $60
		dc.w $160
		dc.w $260
		dc.w $360
		dc.w $460
		dc.w $560
		dc.w $660
		dc.w $760
		dc.w $860
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w $70
		dc.w $170
		dc.w $270
		dc.w $370
		dc.w $470
		dc.w $570
		dc.w $670
		dc.w $770
		dc.w $870
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		dc.w 0
		even