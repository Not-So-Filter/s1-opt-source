; ---------------------------------------------------------------------------
; Object 29 - points that appear when you destroy something
; ---------------------------------------------------------------------------

Points:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Poi_Index(pc,d0.w),d1
		jmp	Poi_Index(pc,d1.w)
; ===========================================================================
Poi_Index:	dc.w Poi_Main-Poi_Index
		dc.w Poi_Slower-Poi_Index
; ===========================================================================

Poi_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Poi,obMap(a0)
		move.w	#make_art_tile(ArtTile_Points,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#1*$80,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.w	#-$300,obVelY(a0) ; move object upwards

Poi_Slower:	; Routine 2
		tst.w	obVelY(a0)	; is object moving?
		bpl.w	DeleteObject	; if not, delete
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)	; reduce object	speed
		bra.w	DisplaySprite