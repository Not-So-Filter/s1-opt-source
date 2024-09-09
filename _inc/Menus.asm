; ===========================================================================
; loc_8BD4:
GM_MenuScreen:
		bsr.w	PaletteFadeOut
		disable_ints
		displayOff
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)		; H-INT disabled
		move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)		; PNT A base: $C000
		move.w	#$8400|(VRAM_Menu_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
		move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)		; PNT A base: $C000
		move.w	#$8700,(a6)		; Background palette/color: 0/0
		move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
		move.w	#$9001,(a6)		; Scroll table size: 64x32

		clearRAM Kos_decomp_stored_registers, Kos_module_end
		clearRAM v_objspace,v_objspace_end

		; load background + graphics of font/LevSelPics
		ResetDMAQueue
		lea	(Nem_FontStuff).l,a1
		move.w	#tiles_to_bytes(ArtTile_ArtNem_FontStuff),d2
		bsr.w	Queue_Kos_Module
		lea	(Nem_MenuBox).l,a1
		move.w	#tiles_to_bytes(ArtTile_ArtNem_MenuBox),d2
		bsr.w	Queue_Kos_Module
		lea	(Nem_LevelSelectPics).l,a1
		move.w	#tiles_to_bytes(ArtTile_ArtNem_LevelSelectPics),d2
		bsr.w	Queue_Kos_Module
		lea	(v_128x128_end).w,a1
		lea	(Eni_MenuBack).l,a0
		move.w	#make_art_tile(ArtTile_VRAM_Start,3,0),d0
		bsr.w	EniDec
		lea	(v_128x128_end).w,a1
		move.l	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
		moveq	#40-1,d1
		moveq	#28-1,d2
		bsr.w	TilemapToVRAM	; fullscreen background

		; Load foreground (sans zone icon)
		lea	(v_128x128_end).w,a1
		lea	(Eni_LevSel).l,a0	; 2 bytes per 8x8 tile, compressed
		moveq	#make_art_tile(ArtTile_VRAM_Start,0,0),d0
		bsr.w	EniDec

		lea	(v_128x128_end).w,a1
		move.l	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
		moveq	#40-1,d1
		moveq	#28-1,d2	; 40x28 = whole screen
		bsr.w	TilemapToVRAM	; display patterns

.waitplc:
		bsr.w	Process_Kos_Queue
		bsr.w	ProcessDMAQueue
		bsr.w	Process_Kos_Module_Queue
		tst.w	(Kos_modules_left).w ; are there any items in the pattern load cue?
		bne.s	.waitplc ; if yes, branch

		; Draw sound test number
		moveq	#palette_line_0,d3
		bsr.w	LevelSelect_DrawSoundNumber

		; Load zone icon
		lea	(v_128x128_end+planeLoc(40,0,28)).w,a1
		lea	(Eni_LevSelIcon).l,a0
		move.w	#make_art_tile(ArtTile_ArtNem_LevelSelectPics,0,0),d0
		bsr.w	EniDec

		bsr.w	LevelSelect_DrawIcon

		moveq	#palid_LevelSel,d0
		bsr.w	PalLoad_Fade

		lea	(Normal_palette_line3).w,a1
		lea	(Target_palette_line3).w,a2

		moveq	#bytesToLcnt(palette_line_size),d1
-		move.l	(a1),(a2)+
		clr.l	(a1)+
		dbf	d1,-

;		moveq	#MusID_Options,d0
;		bsr.w	PlayMusic

		move.w	#(30*60)-1,(v_demolength).w	; 30 seconds
		moveq	#0,d0
		move.l	d0,(v_screenposx).w
		move.l	d0,(v_screenposy).w

		displayOn

		bsr.w	PaletteFadeIn

;loc_93AC:
LevelSelect_Main:	; routine running during level select
		move.w	#VintID_Menu,(v_vbla_routine).w
		bsr.w	WaitForVBla

		disable_ints

		moveq	#palette_line_0,d3
		bsr.w	LevelSelect_MarkFields	; unmark fields
		bsr.w	LevSelControls		; possible change selected fields
		move.w	#palette_line_3,d3
		bsr.w	LevelSelect_MarkFields	; mark fields

		bsr.w	LevelSelect_DrawIcon

		enable_ints

		tst.b	(v_jpadpress).w	; start pressed?
		bmi.s	LevelSelect_PressStart	; yes
		bra.s	LevelSelect_Main	; no
; ===========================================================================

;loc_93F0:
LevelSelect_PressStart:
		move.w	(v_levselitem).w,d0
		add.w	d0,d0
		move.w	LevelSelect_Order(pc,d0.w),d0
		bmi.s	LevelSelect_Return	; sound test

PlayLevel:
		andi.w	#$3FFF,d0
		move.w	d0,(v_zone).w
		move.w	#id_Level,(v_gamemode).w ; => Level (Zone play mode)
		move.b	#3,(v_lives).w
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.l	d0,(v_score).w
		move.l	#5000,(v_scorelife).w
		moveq	#bgm_Fade,d0
		bra.w	PlayMusic
; ===========================================================================

;loc_944C:
LevelSelect_Return:
		clr.w	(v_gamemode).w ; => SegaScreen
		rts
; ===========================================================================
; -----------------------------------------------------------------------------
; Level Select Level Order

; One entry per item in the level select menu. Just set the value for the item
; you want to link to the level/act number of the level you want to load when
; the player selects that item.
; -----------------------------------------------------------------------------
;Misc_9454:
LevelSelect_Order:
		dc.b id_GHZ, 0
		dc.b id_GHZ, 1
		dc.b id_GHZ, 2
		dc.b id_MZ, 0
		dc.b id_MZ, 1
		dc.b id_MZ, 2
		dc.b id_SYZ, 0
		dc.b id_SYZ, 1
		dc.b id_SYZ, 2
		dc.b id_LZ, 0
		dc.b id_LZ, 1
		dc.b id_LZ, 2
		dc.b id_SLZ, 0
		dc.b id_SLZ, 1
		dc.b id_SLZ, 2
		dc.b id_SBZ, 0
		dc.b id_SBZ, 1
		dc.b id_LZ, 3
		dc.b id_SBZ, 2
		dc.w $FFFF		; Sound Test
		even
; ===========================================================================
; ---------------------------------------------------------------------------
; Change what you're selecting in the level select
; ---------------------------------------------------------------------------
; loc_94DC:
LevSelControls:
		moveq	#btnUp|btnDn,d1
		and.b	(v_jpadpress).w,d1
		bne.s	+	; up/down pressed
		subq.b	#1,(v_levseldelay).w
		bpl.s	LevSelControls_CheckLR

+
		move.b	#$B,(v_levseldelay).w
		moveq	#btnUp|btnDn,d1
		and.b	(v_jpadhold).w,d1
		beq.s	LevSelControls_CheckLR	; up/down not pressed, check for left & right
		move.w	(v_levselitem).w,d0
		btst	#bitUp,d1
		beq.s	+
		subq.w	#1,d0	; decrease by 1
		bcc.s	+	; >= 0?
		moveq	#$13,d0	; set to $13

+
		btst	#bitDn,d1
		beq.s	+
		addq.w	#1,d0	; yes, add 1
		cmpi.w	#$14,d0
		blo.s	+	; smaller than $14?
		moveq	#0,d0	; if not, set to 0

+
		move.w	d0,(v_levselitem).w
		rts
; ===========================================================================
; loc_9522:
LevSelControls_CheckLR:
		cmpi.w	#$13,(v_levselitem).w	; are we in the sound test?
		bne.s	LevSelControls_SwitchSide	; no
		move.w	(v_levselsound).w,d0
		move.b	(v_jpadpress).w,d1
		btst	#bitL,d1
		beq.s	+
		subq.b	#1,d0

+
		btst	#bitR,d1
		beq.s	+
		addq.b	#1,d0

+
		btst	#bitA,d1
		beq.s	+
		addi.b	#$10,d0
		bhs.s	+
		moveq	#0,d0

+
		move.w	d0,(v_levselsound).w
		andi.w	#btnB|btnC,d1
		beq.s	+	; rts
		move.w	(v_levselsound).w,d0
		bra.w	PlayMusic
+
		rts
; ===========================================================================
; loc_958A:
LevSelControls_SwitchSide:	; not in soundtest, not up/down pressed
		moveq	#btnL|btnR,d1
		and.b	(v_jpadpress).w,d1
		beq.s	+				; no direction key pressed
		move.w	(v_levselitem).w,d0	; left or right pressed
		move.b	LevelSelect_SwitchTable(pc,d0.w),d0 ; set selected zone according to table
		move.w	d0,(v_levselitem).w
+
		rts
; ===========================================================================
;byte_95A2:
LevelSelect_SwitchTable:
		dc.b	$0F, $10, $11, $12, $12, $12, $13, $13, $13, $14, $14, $14, $15, $15, $15
		dc.b	$00, $01, $02, $03, $06, $09, $0C
		even
; ===========================================================================

;loc_95B8:
LevelSelect_MarkFields:
		lea	(v_128x128_end).w,a4
		lea	LevSel_MarkTable(pc),a5
		lea	(vdp_data_port).l,a6
		moveq	#0,d0
		move.w	(v_levselitem).w,d0
		add.w	d0,d0
		add.w	d0,d0
		lea	(a5,d0.w),a3
		moveq	#0,d0
		move.b	(a3),d0
		mulu.w	#$50,d0
		moveq	#0,d1
		move.b	1(a3),d1
		add.w	d1,d0
		lea	(a4,d0.w),a1
		moveq	#0,d1
		move.b	(a3),d1
		lsl.w	#7,d1
		add.b	1(a3),d1
		addi.w	#VRAM_Plane_A_Name_Table,d1
		lsl.l	#2,d1
		lsr.w	#2,d1
		ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d1
		swap	d1
		move.l	d1,4(a6)

		moveq	#$D,d2
-		move.w	(a1)+,d0
		add.w	d3,d0
		move.w	d0,(a6)
		dbf	d2,-

		addq.w	#2,a3
		moveq	#0,d0
		move.b	(a3),d0
		beq.s	+
		mulu.w	#$50,d0
		moveq	#0,d1
		move.b	1(a3),d1
		add.w	d1,d0
		lea	(a4,d0.w),a1
		moveq	#0,d1
		move.b	(a3),d1
		lsl.w	#7,d1
		add.b	1(a3),d1
		addi.w	#VRAM_Plane_A_Name_Table,d1
		lsl.l	#2,d1
		lsr.w	#2,d1
		ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d1
		swap	d1
		move.l	d1,4(a6)
		move.w	(a1)+,d0
		add.w	d3,d0
		move.w	d0,(a6)

+
		cmpi.w	#$15,(v_levselitem).w
		bne.s	+	; rts
		bra.s	LevelSelect_DrawSoundNumber
+
		rts
; ===========================================================================
;loc_965A:
LevelSelect_DrawSoundNumber:
		move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLoc(64,34,18),VRAM,WRITE),(vdp_control_port).l
		move.w	(v_levselsound).w,d0
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.s	+
		move.b	d2,d0

+
		andi.w	#$F,d0
		cmpi.b	#$A,d0
		blo.s	+
		addq.b	#4,d0

+
		addi.b	#$10,d0
		add.w	d3,d0
		move.w	d0,(a6)
		rts
; ===========================================================================

;loc_9688:
LevelSelect_DrawIcon:
		move.w	(v_levselitem).w,d0
		lea	LevSel_IconTable(pc,d0.w),a3
		lea	(v_128x128_end+planeLoc(40,0,28)).w,a1
		moveq	#0,d0
		move.b	(a3),d0
		lsl.w	#3,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	(a1,d0.w),a1
		move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLoc(64,27,22),VRAM,WRITE),d0
		moveq	#4-1,d1
		moveq	#3-1,d2
		bsr.w	TilemapToVRAM
		lea	Pal_LevelIcons(pc),a1
		moveq	#0,d0
		move.b	(a3),d0
		lsl.w	#5,d0
		lea	(a1,d0.w),a1
		lea	(Normal_palette_line3).w,a2

		move.l  #vdpComm(2*16*2,CRAM,WRITE),vdp_control_port-vdp_data_port(a6)

		moveq	#bytesToLcnt(palette_line_size),d1
-
		move.l	(a1),(a6)
		move.l	(a1)+,(a2)+
		dbf	d1,-

		rts
; ===========================================================================
;byte_96D8
LevSel_IconTable:
		dc.b $00, $00, $00 ; GHZ
                dc.b $01, $01, $01 ; MZ
                dc.b $02, $02, $02 ; SYZ
                dc.b $03, $03, $03 ; LZ
                dc.b $04, $04, $04 ; SLZ
                dc.b $05, $05, $05 ; SBZ
                dc.b $06 ; FZ
                dc.b $07 ; Sound Test
		even
;byte_96EE:
LevSel_MarkTable:	; 4 bytes per level select entry
; line primary, 2*column ($E fields), line secondary, 2*column secondary (1 field)
		dc.b   3,  6,  3,$24	; GHZ1
		dc.b   3,  6,  4,$24	; GHZ2
		dc.b   3,  6,  5,$24	; GHZ3
		dc.b   7,  6,  6,$24	; MZ1
		dc.b   7,  6,  7,$24	; MZ2
		dc.b   7,  6,  8,$24	; MZ3
		dc.b  $A,  6,  9,$24	; SYZ1
		dc.b  $A,  6, $A,$24	; SYZ2
		dc.b  $A,  6, $B,$24	; SYZ3
		dc.b  $D,  6, $C,$24	; LZ1
		dc.b  $D,  6, $D,$24	; LZ2
		dc.b  $D,  6, $E,$24	; LZ3
		dc.b  $10,  6, $F,$24	; SLZ1
		dc.b  $10,  6, $10,$24	; SLZ2
		dc.b  $10,  6, $11,$24	; SLZ3
		dc.b  $13, 6, $12,$24	; SBZ1
		dc.b  $13, 6, $13,$24	; SBZ2
		dc.b  $13, 6, $14,$24	; SBZ3
; --- second column ---
		dc.b   3,$2C,  3,$48	; FZ
		dc.b $12,$2C,$12,$48	; Sound Test

; level select picture palettes
; byte_9880:
Pal_LevelIcons:	binclude "palette/Level Select Icons.bin"
		even
Eni_LevSel2P:	binclude "tilemaps/Level Select 2P.eni"
		even
Eni_LevSel:	binclude "tilemaps/Level Select.eni"
		even
Eni_LevSelIcon:	binclude "tilemaps/Level Select Icons.eni"
		even