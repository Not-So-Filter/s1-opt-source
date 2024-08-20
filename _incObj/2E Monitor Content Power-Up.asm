; ---------------------------------------------------------------------------
; Object 2E - contents of monitors
; ---------------------------------------------------------------------------

PowerUp:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Pow_Index(pc,d0.w),d1
		jmp	Pow_Index(pc,d1.w)
; ===========================================================================
Pow_Index:	dc.w Pow_Main-Pow_Index
		dc.w Pow_Move-Pow_Index
		dc.w Pow_Delete-Pow_Index
; ===========================================================================

Pow_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#make_art_tile(ArtTile_Monitor,0,0),obGfx(a0)
		move.b	#$24,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.w	#-$300,obVelY(a0)
		moveq	#0,d0
		move.b	obAnim(a0),d0	; get subtype
		addq.b	#2,d0
		move.b	d0,obFrame(a0)	; use correct frame
		movea.l	#Map_Monitor,a1
		add.b	d0,d0
		adda.w	(a1,d0.w),a1
		addq.w	#2,a1
		move.l	a1,obMap(a0)

Pow_Move:	; Routine 2
		tst.w	obVelY(a0)	; is object moving?
		bpl.s	Pow_Checks	; if not, branch
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)	; reduce object	speed
		bra.w	DisplaySprite
; ===========================================================================

Pow_Checks:
		addq.b	#2,obRoutine(a0)
		move.w	#29,obTimeFrame(a0) ; display icon for half a second
		moveq	#0,d0
		move.b	obAnim(a0),d0
		add.w	d0,d0
		move.w	Pow_ChkIndex(pc,d0.w),d1
		jmp	Pow_ChkIndex(pc,d1.w)
; ===========================================================================
Pow_ChkIndex:	dc.w Pow_ChkEggman-Pow_ChkIndex
		dc.w Pow_ChkEggman-Pow_ChkIndex
		dc.w Pow_ChkSonic-Pow_ChkIndex
		dc.w Pow_ChkShoes-Pow_ChkIndex
		dc.w Pow_ChkShield-Pow_ChkIndex
		dc.w Pow_ChkInvinc-Pow_ChkIndex
		dc.w Pow_ChkRings-Pow_ChkIndex
		dc.w Pow_ChkS-Pow_ChkIndex
; ===========================================================================
Pow_ChkEggman:
		rts			; Eggman monitor does nothing
; ===========================================================================

Pow_ChkSonic:
ExtraLife:
		addq.b	#1,(v_lives).w	; add 1 to the number of lives you have
		addq.b	#1,(f_lifecount).w ; update the lives counter
		moveq	#bgm_ExtraLife,d0
		jmp	(PlayMusic).w	; play extra life music
; ===========================================================================

Pow_ChkShoes:
		move.b	#1,(v_shoes).w	; speed up the BG music
		move.w	#1200,(v_player+shoetime).w	; time limit for the power-up
		move.w	#$C00,(v_sonspeedmax).w ; change Sonic's top speed
		move.w	#$18,(v_sonspeedacc).w	; change Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w	; change Sonic's deceleration
		moveq	#bgm_Speedup,d0
		jmp	(PlayMusic).w		; Speed	up the music
; ===========================================================================

Pow_ChkShield:
		move.b	#1,(v_shield).w	; give Sonic a shield
		move.b	#id_ShieldItem,(v_shieldobj).w ; load shield object ($38)
		moveq	#sfx_Shield,d0
		jmp	(PlaySound).w	; play shield sound
; ===========================================================================

Pow_ChkInvinc:
		move.b	#1,(v_invinc).w	; make Sonic invincible
		move.w	#1200,(v_player+invtime).w ; time limit for the power-up
		moveq	#id_ShieldItem,d1
		move.b	d1,(v_starsobj1).w ; load stars object ($3801)
		move.b	#1,(v_starsobj1+obAnim).w
		move.b	d1,(v_starsobj2).w ; load stars object ($3802)
		move.b	#2,(v_starsobj2+obAnim).w
		move.b	d1,(v_starsobj3).w ; load stars object ($3803)
		move.b	#3,(v_starsobj3+obAnim).w
		move.b	d1,(v_starsobj4).w ; load stars object ($3804)
		move.b	#4,(v_starsobj4+obAnim).w
		tst.b	(f_lockscreen).w ; is boss mode on?
		bne.s	Pow_NoMusic	; if yes, branch
		cmpi.w	#$C,(v_air).w
		bls.s	Pow_NoMusic
		moveq	#bgm_Invincible,d0
		jmp	(PlayMusic).w ; play invincibility music
; ===========================================================================

Pow_NoMusic:
		rts
; ===========================================================================

Pow_ChkRings:
		addi.w	#10,(v_rings).w	; add 10 rings to the number of rings you have
		st.b	(f_ringcount).w ; update the ring counter
		cmpi.w	#100,(v_rings).w ; check if you have 100 rings
		blo.s	Pow_RingSound
		bset	#1,(v_lifecount).w
		beq.w	ExtraLife
		cmpi.w	#200,(v_rings).w ; check if you have 200 rings
		blo.s	Pow_RingSound
		bset	#2,(v_lifecount).w
		beq.w	ExtraLife

Pow_RingSound:
		moveq	#sfx_Ring,d0
		jmp	(PlaySound).w	; play ring sound
; ===========================================================================

Pow_ChkS:
Pow_ChkEnd:
		rts			; 'S' and goggles monitors do nothing
; ===========================================================================

Pow_Delete:	; Routine 4
		subq.w	#1,obTimeFrame(a0)
		bmi.w	DeleteObject	; delete after half a second
		bra.w	DisplaySprite