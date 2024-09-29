; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DynamicLevelEvents:
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	DLE_Index(pc,d0.w),d0
		jsr	DLE_Index(pc,d0.w) ; run level-specific events
		moveq	#2,d1
		move.w	(v_limitbtm1).w,d0
		sub.w	(v_limitbtm2).w,d0 ; has lower level boundary changed recently?
		beq.s	DLE_NoChg	; if not, branch
		bcc.s	loc_6DAC

		neg.w	d1
		move.w	(v_screenposy).w,d0
		cmp.w	(v_limitbtm1).w,d0
		bls.s	loc_6DA0
		move.w	d0,(v_limitbtm2).w
		andi.w	#$FFFE,(v_limitbtm2).w

loc_6DA0:
		add.w	d1,(v_limitbtm2).w
		move.b	#1,(f_bgscrollvert).w

DLE_NoChg:
		rts
; ===========================================================================

loc_6DAC:
		move.w	(v_screenposy).w,d0
		addq.w	#8,d0
		cmp.w	(v_limitbtm2).w,d0
		blo.s	loc_6DC4
		btst	#1,(v_player+obStatus).w
		beq.s	loc_6DC4
		add.w	d1,d1
		add.w	d1,d1

loc_6DC4:
		add.w	d1,(v_limitbtm2).w
		move.b	#1,(f_bgscrollvert).w
		rts
; End of function DynamicLevelEvents

; ===========================================================================
; ---------------------------------------------------------------------------
; Offset index for dynamic level events
; ---------------------------------------------------------------------------
DLE_Index:	dc.w DLE_GHZ1-DLE_Index
		dc.w DLE_GHZ2-DLE_Index
		dc.w DLE_GHZ3-DLE_Index
		dc.w DLE_GHZ1-DLE_Index
		dc.w DLE_LZ12-DLE_Index
		dc.w DLE_LZ12-DLE_Index
		dc.w DLE_LZ3-DLE_Index
		dc.w DLE_SBZ3-DLE_Index
		dc.w DLE_MZ1-DLE_Index
		dc.w DLE_MZ2-DLE_Index
		dc.w DLE_MZ3-DLE_Index
		dc.w DLE_MZ1-DLE_Index
		dc.w DLE_SLZ12-DLE_Index
		dc.w DLE_SLZ12-DLE_Index
		dc.w DLE_SLZ3-DLE_Index
		dc.w DLE_SLZ12-DLE_Index
		dc.w DLE_SYZ1-DLE_Index
		dc.w DLE_SYZ2-DLE_Index
		dc.w DLE_SYZ3-DLE_Index
		dc.w DLE_SYZ1-DLE_Index
		dc.w DLE_SBZ1-DLE_Index
		dc.w DLE_SBZ2-DLE_Index
		dc.w DLE_FZ-DLE_Index
		dc.w DLE_SBZ1-DLE_Index
; ===========================================================================

DLE_GHZ1:
		move.w	#$300,(v_limitbtm1).w ; set lower y-boundary
		cmpi.w	#$1780,(v_screenposx).w ; has the camera reached $1780 on x-axis?
		blo.s	locret_6E08	; if not, branch
		move.w	#$400,(v_limitbtm1).w ; set lower y-boundary

locret_6E08:
DLE_LZ12:
DLE_SLZ12:
DLE_SYZ1:
		rts
; ===========================================================================

DLE_GHZ2:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$ED0,(v_screenposx).w
		blo.s	locret_6E3A
		move.w	#$200,(v_limitbtm1).w
		cmpi.w	#$1600,(v_screenposx).w
		blo.s	locret_6E3A
		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1D60,(v_screenposx).w
		blo.s	locret_6E3A
		move.w	#$300,(v_limitbtm1).w

locret_6E3A:
		rts
; ===========================================================================

DLE_GHZ3:
		move.w	(v_dle_routine).w,d0
		move.w	off_6E4A(pc,d0.w),d0
		jmp	off_6E4A(pc,d0.w)
; ===========================================================================
off_6E4A:	dc.w DLE_GHZ3main-off_6E4A
		dc.w DLE_GHZ3boss-off_6E4A
		dc.w DLE_GHZ3end-off_6E4A
; ===========================================================================

DLE_GHZ3main:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$380,(v_screenposx).w
		blo.s	locret_6E96
		move.w	#$310,(v_limitbtm1).w
		cmpi.w	#$960,(v_screenposx).w
		blo.s	locret_6E96
		cmpi.w	#$280,(v_screenposy).w
		blo.s	loc_6E98
		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1380,(v_screenposx).w
		bhs.s	loc_6E8E
		move.w	#$4C0,(v_limitbtm1).w
		move.w	#$4C0,(v_limitbtm2).w

loc_6E8E:
		cmpi.w	#$1700,(v_screenposx).w
		bhs.s	loc_6E98

locret_6E96:
		rts
; ===========================================================================

loc_6E98:
		move.w	#boss_ghz_y,(v_limitbtm1).w
		addq.w	#2,(v_dle_routine).w
		rts
; ===========================================================================

DLE_GHZ3boss:
		cmpi.w	#$960,(v_screenposx).w
		bhs.s	loc_6EB0
		subq.w	#2,(v_dle_routine).w

loc_6EB0:
		cmpi.w	#boss_ghz_x,(v_screenposx).w
		blo.s	locret_6EE8
		bsr.w	FindFreeObj
		bne.s	loc_6ED0
		move.l	#BossGreenHill,obID(a1) ; load GHZ boss	object
		move.w	#boss_ghz_x+$100,obX(a1)
		move.w	#boss_ghz_y-$80,obY(a1)

loc_6ED0:
		playsound bgm_Boss,music
		move.b	#1,(f_lockscreen).w ; lock screen
		addq.w	#2,(v_dle_routine).w
		moveq	#plcid_Boss,d0
		bra.w	AddPLC		; load boss patterns
; ===========================================================================

DLE_GHZ3end:
		move.w	(v_screenposx).w,(v_limitleft2).w

locret_6EE8:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Labyrinth Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_LZ3:
		tst.b	(f_switch+$F).w	; has switch $F	been pressed?
		beq.s	loc_6F28	; if not, branch
;		cmpi.l	#Level_LZ3NoWall,(v_lvllayoutfg).w	; MJ: is current layout already set to wall version?
;		beq.s	loc_6F28				; MJ: if so, branch to skip
;		move.l	#Level_LZ3NoWall,(v_lvllayoutfg).w	; MJ: Set wall version of act 3's layout to be read
		playsound sfx_Rumbling,sfx

loc_6F28:
		tst.w	(v_dle_routine).w
		bne.s	locret_6F64
		cmpi.w	#boss_lz_x-$140,(v_screenposx).w
		blo.s	locret_6F62
		cmpi.w	#boss_lz_y+$540,(v_screenposy).w
		bhs.s	locret_6F62
		bsr.w	FindFreeObj
		bne.s	loc_6F4A
		move.l	#BossLabyrinth,obID(a1) ; load LZ boss object

loc_6F4A:
		playsound bgm_Boss,music
		move.b	#1,(f_lockscreen).w ; lock screen
		addq.w	#2,(v_dle_routine).w
		moveq	#plcid_Boss,d0
		bra.w	AddPLC		; load boss patterns
; ===========================================================================

DLE_SBZ3:
		cmpi.w	#$D00,(v_screenposx).w
		blo.s	locret_6F8C
		cmpi.w	#$18,(v_player+obY).w ; has Sonic reached the top of the level?
		bhs.s	locret_6F8C	; if not, branch
		clr.b	(v_lastlamp).w
		move.w	#1,(f_restart).w ; restart level
		move.w	#(id_SBZ<<8)+2,(v_zone).w ; set level number to 0502 (FZ)
		move.b	#1,(f_playerctrl).w ; lock controls

locret_6F8C:
locret_6F62:
locret_6F64:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_MZ1:
		move.w	(v_dle_routine).w,d0
		move.w	off_6FB2(pc,d0.w),d0
		jmp	off_6FB2(pc,d0.w)
; ===========================================================================
off_6FB2:	dc.w loc_6FBA-off_6FB2
		dc.w loc_6FEA-off_6FB2
		dc.w loc_702E-off_6FB2
		dc.w loc_7050-off_6FB2
; ===========================================================================

loc_6FBA:
		move.w	#$1D0,(v_limitbtm1).w
		cmpi.w	#$700,(v_screenposx).w
		blo.s	locret_6FE8
		move.w	#$220,(v_limitbtm1).w
		cmpi.w	#$D00,(v_screenposx).w
		blo.s	locret_6FE8
		move.w	#$340,(v_limitbtm1).w
		cmpi.w	#$340,(v_screenposy).w
		blo.s	locret_6FE8
		addq.w	#2,(v_dle_routine).w

locret_6FE8:
		rts
; ===========================================================================

loc_6FEA:
		cmpi.w	#$340,(v_screenposy).w
		bhs.s	loc_6FF8
		subq.w	#2,(v_dle_routine).w
		rts
; ===========================================================================

loc_6FF8:
		move.w	#0,(v_limittop2).w
		cmpi.w	#$E00,(v_screenposx).w
		bhs.s	locret_702C
		move.w	#$340,(v_limittop2).w
		move.w	#$340,(v_limitbtm1).w
		cmpi.w	#$A90,(v_screenposx).w
		bhs.s	locret_702C
		move.w	#$500,(v_limitbtm1).w
		cmpi.w	#$370,(v_screenposy).w
		blo.s	locret_702C
		addq.w	#2,(v_dle_routine).w

locret_702C:
		rts
; ===========================================================================

loc_702E:
		cmpi.w	#$370,(v_screenposy).w
		bhs.s	loc_703C
		subq.w	#2,(v_dle_routine).w
		rts
; ===========================================================================

loc_703C:
		cmpi.w	#$500,(v_screenposy).w
		blo.s	locret_704E
		cmpi.w	#$B80,(v_screenposx).w
		bcs.s	locret_704E
		move.w	#$500,(v_limittop2).w
		addq.w	#2,(v_dle_routine).w

locret_704E:
		rts
; ===========================================================================

loc_7050:
		cmpi.w	#$B80,(v_screenposx).w
		bcc.s	locj_76B8
		cmpi.w	#$340,(v_limittop2).w
		beq.s	locret_7072
		subq.w	#2,(v_limittop2).w
		rts
locj_76B8:
		cmpi.w	#$500,(v_limittop2).w
		beq.s	locj_76CE
		cmpi.w	#$500,(v_screenposy).w
		bcs.s	locret_7072
		move.w	#$500,(v_limittop2).w
locj_76CE:
		cmpi.w	#$E70,(v_screenposx).w
		blo.s	locret_7072
		move.w	#0,(v_limittop2).w
		move.w	#$500,(v_limitbtm1).w
		cmpi.w	#$1430,(v_screenposx).w
		blo.s	locret_7072
		move.w	#$210,(v_limitbtm1).w

locret_7072:
		rts
; ===========================================================================

DLE_MZ2:
		move.w	#$520,(v_limitbtm1).w
		cmpi.w	#$1700,(v_screenposx).w
		blo.s	locret_7088
		move.w	#$200,(v_limitbtm1).w

locret_7088:
		rts
; ===========================================================================

DLE_MZ3:
		move.w	(v_dle_routine).w,d0
		jmp	off_7098(pc,d0.w)
; ===========================================================================
off_7098:	bra.s	DLE_MZ3boss
		bra.s	DLE_MZ3end
; ===========================================================================

DLE_MZ3boss:
		move.w	#$720,(v_limitbtm1).w
		cmpi.w	#boss_mz_x-$2A0,(v_screenposx).w
		blo.s	locret_70E8
		move.w	#boss_mz_y,(v_limitbtm1).w
		cmpi.w	#boss_mz_x-$10,(v_screenposx).w
		blo.s	locret_70E8
		bsr.w	FindFreeObj
		bne.s	loc_70D0
		move.l	#BossMarble,obID(a1) ; load MZ boss object
		move.w	#boss_mz_x+$1F0,obX(a1)
		move.w	#boss_mz_y+$1C,obY(a1)

loc_70D0:
		playsound bgm_Boss,music
		move.b	#1,(f_lockscreen).w ; lock screen
		addq.w	#2,(v_dle_routine).w
		moveq	#plcid_Boss,d0
		bra.w	AddPLC		; load boss patterns
; ===========================================================================

DLE_MZ3end:
		move.w	(v_screenposx).w,(v_limitleft2).w

locret_70E8:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Star Light Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SLZ3:
		move.w	(v_dle_routine).w,d0
		jmp	off_7118(pc,d0.w)
; ===========================================================================
off_7118:	bra.s	DLE_SLZ3main
		bra.s	DLE_SLZ3boss
		bra.s	DLE_SLZ3end
; ===========================================================================

DLE_SLZ3main:
		cmpi.w	#boss_slz_x-$190,(v_screenposx).w
		blo.s	locret_7130
		move.w	#boss_slz_y,(v_limitbtm1).w
		addq.w	#2,(v_dle_routine).w

locret_7130:
		rts
; ===========================================================================

DLE_SLZ3boss:
		cmpi.w	#boss_slz_x,(v_screenposx).w
		blo.s	locret_715C
		bsr.w	FindFreeObj
		bne.s	loc_7144
		move.l	#BossStarLight,obID(a1) ; load SLZ boss object

loc_7144:
		playsound bgm_Boss,music
		move.b	#1,(f_lockscreen).w ; lock screen
		addq.w	#2,(v_dle_routine).w
		moveq	#plcid_Boss,d0
		bra.w	AddPLC		; load boss patterns
; ===========================================================================

DLE_SLZ3end:
		move.w	(v_screenposx).w,(v_limitleft2).w

locret_715C:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Spring Yard Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SYZ2:
		move.w	#$520,(v_limitbtm1).w
		cmpi.w	#$25A0,(v_screenposx).w
		blo.s	locret_71A2
		move.w	#$420,(v_limitbtm1).w
		cmpi.w	#$4D0,(v_player+obY).w
		blo.s	locret_71A2
		move.w	#$520,(v_limitbtm1).w

locret_71A2:
		rts
; ===========================================================================

DLE_SYZ3:
		move.w	(v_dle_routine).w,d0
		jmp	off_71B2(pc,d0.w)
; ===========================================================================
off_71B2:	bra.s	DLE_SYZ3main
		bra.s	DLE_SYZ3boss
		bra.s	DLE_SYZ3end
; ===========================================================================

DLE_SYZ3main:
		cmpi.w	#boss_syz_x-$140,(v_screenposx).w
		blo.s	locret_71CE
		bsr.w	FindFreeObj
		bne.s	locret_71CE
		move.l	#BossBlock,obID(a1) ; load blocks that boss picks up
		addq.w	#2,(v_dle_routine).w

locret_71CE:
		rts
; ===========================================================================

DLE_SYZ3boss:
		cmpi.w	#boss_syz_x,(v_screenposx).w
		blo.s	locret_7200
		move.w	#boss_syz_y,(v_limitbtm1).w
		bsr.w	FindFreeObj
		bne.s	loc_71EC
		move.l	#BossSpringYard,obID(a1) ; load SYZ boss object
		addq.w	#2,(v_dle_routine).w

loc_71EC:
		playsound bgm_Boss,music
		move.b	#1,(f_lockscreen).w ; lock screen
		moveq	#plcid_Boss,d0
		bra.w	AddPLC		; load boss patterns
; ===========================================================================

DLE_SYZ3end:
		move.w	(v_screenposx).w,(v_limitleft2).w

locret_7200:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Scrap	Brain Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SBZ1:
		move.w	#$720,(v_limitbtm1).w
		cmpi.w	#$1880,(v_screenposx).w
		blo.s	locret_7242
		move.w	#$620,(v_limitbtm1).w
		cmpi.w	#$2000,(v_screenposx).w
		blo.s	locret_7242
		move.w	#$2A0,(v_limitbtm1).w

locret_7242:
		rts
; ===========================================================================

DLE_SBZ2:
		move.w	(v_dle_routine).w,d0
		move.w	off_7252(pc,d0.w),d0
		jmp	off_7252(pc,d0.w)
; ===========================================================================
off_7252:	dc.w DLE_SBZ2main-off_7252
		dc.w DLE_SBZ2boss-off_7252
		dc.w DLE_SBZ2boss2-off_7252
		dc.w DLE_SBZ2end-off_7252
; ===========================================================================

DLE_SBZ2main:
		move.w	#$800,(v_limitbtm1).w
		cmpi.w	#$1800,(v_screenposx).w
		blo.s	locret_727A
		move.w	#boss_sbz2_y,(v_limitbtm1).w
		cmpi.w	#$1E00,(v_screenposx).w
		blo.s	locret_727A
		addq.w	#2,(v_dle_routine).w

locret_727A:
locret_7298:
		rts
; ===========================================================================

DLE_SBZ2boss:
		cmpi.w	#boss_sbz2_x-$1A0,(v_screenposx).w
		blo.s	locret_7298
		bsr.w	FindFreeObj
		bne.s	locret_7298
		move.l	#FalseFloor,obID(a1) ; load collapsing block object
		addq.w	#2,(v_dle_routine).w
		moveq	#plcid_EggmanSBZ2,d0
		bra.w	AddPLC		; load SBZ2 Eggman patterns
; ===========================================================================

DLE_SBZ2boss2:
		cmpi.w	#boss_sbz2_x-$F0,(v_screenposx).w
		blo.s	loc_72C2
		bsr.w	FindFreeObj
		bne.s	loc_72B0
		move.l	#ScrapEggman,obID(a1) ; load SBZ2 Eggman object
		addq.w	#2,(v_dle_routine).w

loc_72B0:
		move.b	#1,(f_lockscreen).w ; lock screen
		bra.s	loc_72C2
; ===========================================================================

DLE_SBZ2end:
		cmpi.w	#boss_sbz2_x,(v_screenposx).w
		blo.s	loc_72C2
		rts
; ===========================================================================

loc_72C2:
		move.w	(v_screenposx).w,(v_limitleft2).w

locret_7322:
		rts
; ===========================================================================

DLE_FZ:
		move.w	(v_dle_routine).w,d0
		move.w	off_72D8(pc,d0.w),d0
		jmp	off_72D8(pc,d0.w)
; ===========================================================================
off_72D8:	dc.w DLE_FZmain-off_72D8, DLE_FZboss-off_72D8
		dc.w DLE_FZend-off_72D8, locret_7322-off_72D8
		dc.w loc_72C2-off_72D8
; ===========================================================================

DLE_FZmain:
		cmpi.w	#boss_fz_x-$308,(v_screenposx).w
		blo.s	loc_72C2
		addq.w	#2,(v_dle_routine).w
		moveq	#plcid_FZBoss,d0
		bsr.w	AddPLC		; load FZ boss patterns
		bra.s	loc_72C2
; ===========================================================================

DLE_FZboss:
		cmpi.w	#boss_fz_x-$150,(v_screenposx).w
		blo.s	loc_72C2
		bsr.w	FindFreeObj
		bne.s	loc_72C2
		move.b	#id_BossFinal,obID(a1) ; load FZ boss object
		addq.w	#2,(v_dle_routine).w
		move.b	#1,(f_lockscreen).w ; lock screen
		bra.s	loc_72C2
; ===========================================================================

DLE_FZend:
		cmpi.w	#boss_fz_x,(v_screenposx).w
		blo.s	loc_72C2
		addq.w	#2,(v_dle_routine).w
		bra.s	loc_72C2