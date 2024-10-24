; ---------------------------------------------------------------------------
; Object 44 - edge walls (GHZ)
; ---------------------------------------------------------------------------

EdgeWalls:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Edge_Index(pc,d0.w),d1
		jmp	Edge_Index(pc,d1.w)
; ===========================================================================
Edge_Index:	dc.w Edge_Main-Edge_Index
		dc.w Edge_Solid-Edge_Index
		dc.w Edge_Display-Edge_Index
; ===========================================================================

Edge_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Edge,obMap(a0)
		move.w	#make_art_tile(ArtTile_GHZ_Edge_Wall,2,0),obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#8,obActWid(a0)
		move.w	#6*$80,obPriority(a0)
		move.b	obSubtype(a0),obFrame(a0) ; copy object type number to frame number
		bclr	#4,obFrame(a0)	; clear	4th bit	(deduct	$10)
		beq.s	Edge_Solid	; make object solid if 4th bit = 0
		addq.b	#2,obRoutine(a0)
		out_of_range.w	DeleteObject_Respawn
		bra.w	DisplaySprite
; ===========================================================================

Edge_Solid:	; Routine 2
		moveq	#$13,d1
		moveq	#$28,d2
		moveq	#$29,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject

Edge_Display:	; Routine 4
		out_of_range.w	DeleteObject_Respawn
		bra.w	DisplaySprite