surf_origX = objoff_30		; original x-axis position
surf_freeze = objoff_32		; flag to freeze animation
; ===========================================================================

WaterSurface:	; Routine 0
		lea	(Map_Surf).l,a1
		move.w	#make_art_tile(ArtTile_LZ_Water_Surface,2,1),d5
		move.w	d0,surf_origX(a0)

Surf_Action:	; Routine 2
		move.w	(v_screenposx).w,d1
		andi.w	#$FFE0,d1
		add.w	surf_origX(a0),d1
		btst	#0,(v_framebyte).w
		beq.s	.even		; branch on even frames
		addi.w	#$20,d1

.even:
		move.w	d1,d0	; match	obj x-position to screen position
		move.w	(v_waterpos1).w,d1	; match	obj y-position to water	height
		tst.b	surf_freeze(a0)
		bne.s	.stopped
		btst	#bitStart,(v_jpadpress1).w ; is Start button pressed?
		beq.s	.animate	; if not, branch
		addq.b	#3,obFrame(a0)	; use different	frames
		move.b	#1,surf_freeze(a0) ; stop animation
		bra.s	.display
; ===========================================================================

.stopped:
		tst.w	(f_pause).w	; is the game paused?
		bne.s	.display	; if yes, branch
		clr.b	surf_freeze(a0) ; resume animation
		subq.b	#3,obFrame(a0)	; use normal frames

.animate:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	.display
		move.b	#7,obTimeFrame(a0)
		addq.b	#1,obFrame(a0)
		cmpi.b	#3,obFrame(a0)
		blo.s	.display
		clr.b	obFrame(a0)

.display: