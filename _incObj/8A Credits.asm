; ---------------------------------------------------------------------------
; Object 8A - "SONIC TEAM PRESENTS" and	credits
; ---------------------------------------------------------------------------

CreditsText:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Cred_Index(pc,d0.w),d1
		jmp	Cred_Index(pc,d1.w)
; ===========================================================================
Cred_Index:	dc.w Cred_Main-Cred_Index
		dc.w Cred_Display-Cred_Index
; ===========================================================================

Cred_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$120,obX(a0)
		move.w	#$F0,obScreenY(a0)
		move.l	#Map_Cred,obMap(a0)
		move.w	#make_art_tile(ArtTile_Sonic_Team_Font,0,0),obGfx(a0)
		move.b	#0,obFrame(a0)	; display "SONIC TEAM PRESENTS"
		move.b	#0,obRender(a0)
		move.w	#0*$80,obPriority(a0)
		tst.b	(f_creditscheat).w ; is hidden credits cheat on?
		beq.s	Cred_Display	; if not, branch
		cmpi.b	#btnABC+btnDn,(v_jpadhold).w ; is A+B+C+Down being pressed? ($72)
		bne.s	Cred_Display	; if not, branch
		move.w	#cWhite,(v_palette_fading+$40).w ; 3rd palette, 1st entry = white
		move.w	#$880,(v_palette_fading+$42).w ; 3rd palette, 2nd entry = cyan
		jmp	(DeleteObject).l
; ===========================================================================

Cred_Display:	; Routine 2
		jmp	(DisplaySprite).l
