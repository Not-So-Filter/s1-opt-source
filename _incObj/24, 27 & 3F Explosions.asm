; ---------------------------------------------------------------------------
; Object 27 - explosion	from a destroyed enemy or monitor
; ---------------------------------------------------------------------------

ExplosionItem:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ExItem_Index(pc,d0.w),d1
		jmp	ExItem_Index(pc,d1.w)
; ===========================================================================
ExItem_Index:	dc.w ExItem_Animal-ExItem_Index
		dc.w ExItem_Main-ExItem_Index
		dc.w ExItem_Animate-ExItem_Index
; ===========================================================================

ExItem_Animal:	; Routine 0
		addq.b	#2,obRoutine(a0)
		bsr.w	FindFreeObj
		bne.s	ExItem_Main
		move.b	#id_Animals,obID(a1) ; load animal object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	objoff_3E(a0),objoff_3E(a1)

ExItem_Main:	; Routine 2
		addq.b	#2,obRoutine(a0)
		move.l	#Map_ExplodeItem,obMap(a0)
		move.w	#make_art_tile(ArtTile_Explosion,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#1*$80,obPriority(a0)
		moveq	#0,d0
		move.b	d0,obColType(a0)
		move.b	#$C,obActWid(a0)
		move.b	#7,obTimeFrame(a0) ; set frame duration to 7 frames
		move.b	d0,obFrame(a0)
		moveq	#sfx_BreakItem,d0
		jsr	(PlaySound).w	; play breaking enemy sound

ExItem_Animate:	; Routine 4 (2 for ExplosionBomb)
		subq.b	#1,obTimeFrame(a0) ; subtract 1 from frame duration
		bpl.s	.display
		move.b	#7,obTimeFrame(a0) ; set frame duration to 7 frames
		addq.b	#1,obFrame(a0)	; next frame
		cmpi.b	#5,obFrame(a0)	; is the final frame (05) displayed?
		beq.w	DeleteObject	; if yes, branch

.display:
		bra.w	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3F - explosion	from a destroyed boss, bomb or cannonball
; ---------------------------------------------------------------------------

ExplosionBomb:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ExBom_Index(pc,d0.w),d1
		jmp	ExBom_Index(pc,d1.w)
; ===========================================================================
ExBom_Index:	dc.w ExBom_Main-ExBom_Index
		dc.w ExItem_Animate-ExBom_Index
; ===========================================================================

ExBom_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_ExplodeBomb,obMap(a0)
		move.w	#make_art_tile(ArtTile_Explosion,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#1*$80,obPriority(a0)
		moveq	#0,d0
		move.b	d0,obColType(a0)
		move.b	#$C,obActWid(a0)
		move.b	#7,obTimeFrame(a0)
		move.b	d0,obFrame(a0)
		moveq	#sfx_Bomb,d0
		jmp	(PlaySound).w	; play exploding bomb sound
