; ---------------------------------------------------------------------------
; Subroutine to draw the HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_40804:
BuildHUD:
		tst.w	(v_rings).w
		beq.s	+	; blink ring count if it's 0
		moveq	#0,d4
		btst	#3,(v_framebyte).w
		bne.s	++	; only blink on certain frames
		cmpi.b	#9,(v_timemin).w	; should the minutes counter blink?
		bne.s	++	; if not, branch
		addq.w	#2,d4	; set mapping frame time counter blink
		bra.s	++
+
		moveq	#0,d4
		btst	#3,(v_framebyte).w
		bne.s	+	; only blink on certain frames
		addq.w	#1,d4	; set mapping frame for ring count blink
		cmpi.b	#9,(v_timemin).w
		bne.s	+
		addq.w	#2,d4	; set mapping frame for double blink
+
		tst.b	(HUD_scroll_flag).w
		beq.s	.scrollaway
		cmpi.w	#$90,(HUD_scroll_vertical).w
		beq.s	.skip
		addq.w	#8,(HUD_scroll_vertical).w
		move.w	(HUD_scroll_vertical).w,d0
		move.w	#$108,d1	; set Y pos
		lea	Map_HUD(pc),a1
		move.w	#make_art_tile(ArtTile_HUD,0,0),d5	; set art tile and flags
		add.w	d4,d4
		adda.w	(a1,d4.w),a1
		move.w	(a1)+,d4
		subq.w	#1,d4
		bmi.s	+
		bra.w	BuildSpr_Normal	; draw frame

.scrollaway:
		tst.w	(HUD_scroll_vertical).w
		beq.s	+
		subq.w	#8,(HUD_scroll_vertical).w

.skip:
		move.w	(HUD_scroll_vertical).w,d0
		move.w	#$108,d1	; set Y pos
		lea	Map_HUD(pc),a1
		move.w	#make_art_tile(ArtTile_HUD,0,0),d5	; set art tile and flags
		add.w	d4,d4
		adda.w	(a1,d4.w),a1
		move.w	(a1)+,d4
		subq.w	#1,d4
		bmi.s	+
		bra.w	BuildSpr_Normal	; draw frame
+
		rts
; End of function BuildHUD