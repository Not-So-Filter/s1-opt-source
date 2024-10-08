; ---------------------------------------------------------------------------
; Object 6E - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------

Electro:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Elec_Index(pc,d0.w),d1
		jmp	Elec_Index(pc,d1.w)
; ===========================================================================
Elec_Index:	dc.w Elec_Main-Elec_Index
		dc.w Elec_Shock-Elec_Index

elec_freq = objoff_34		; frequency
; ===========================================================================

Elec_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Elec,obMap(a0)
		move.w	#make_art_tile(ArtTile_SBZ_Electric_Orb,0,0),obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#$28,obActWid(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; read object type
		lsl.w	#4,d0		; multiply by $10
		subq.w	#1,d0
		move.w	d0,elec_freq(a0)

Elec_Shock:	; Routine 2
		move.w	(v_framecount).w,d0
		and.w	elec_freq(a0),d0 ; is it time to zap?
		bne.s	.animate	; if not, branch

		move.b	#1,obAnim(a0)	; run "zap" animation
		tst.b	obRender(a0)
		bpl.s	.animate
		playsound sfx_Electric,sfx

.animate:
		lea	Ani_Elec(pc),a1
		jsr	(AnimateSprite).l
		move.b	#0,obColType(a0)
		cmpi.b	#4,obFrame(a0)	; is 4th frame displayed?
		bne.s	.display	; if not, branch
		move.b	#$A4,obColType(a0) ; if yes, make object hurt Sonic

.display:
		out_of_range.s	.delete
		jmp	(DisplaySprite).l

.delete:
		jmp	(DeleteObject_Respawn).l