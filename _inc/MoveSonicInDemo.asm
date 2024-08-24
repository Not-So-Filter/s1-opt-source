; ---------------------------------------------------------------------------
; Subroutine to	move Sonic in demo mode
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


MoveSonicInDemo:
		tst.w	(f_demo).w	; is demo mode on?
		bne.s	MDemo_On	; if yes, branch
		rts
; ===========================================================================

MDemo_On:
		tst.b	(v_jpadhold1).w	; is start button pressed?
		bpl.s	.dontquit	; if not, branch
		move.w	#id_Title,(v_gamemode).w ; go to title screen

.dontquit:
		lea	DemoDataPtr(pc),a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		movea.w	(a1,d0.w),a1	; fetch address for demo data
		move.w	(v_btnpushtime1).w,d0
		adda.w	d0,a1
		move.b	(a1),d0
		lea	(v_jpadhold1).w,a0
		move.b	d0,d1
		move.b	v_jpadhold2-v_jpadhold1(a0),d2
		eor.b	d2,d0
		move.b	d1,(a0)+
		and.b	d1,d0
		move.b	d0,(a0)+
		subq.b	#1,(v_btnpushtime2).w
		bcc.s	.end
		move.b	3(a1),(v_btnpushtime2).w
		addq.w	#2,(v_btnpushtime1).w

.end:
		rts
; End of function MoveSonicInDemo

; ===========================================================================
; ---------------------------------------------------------------------------
; Demo sequence	pointers
; ---------------------------------------------------------------------------
DemoDataPtr:	dc.w Demo_GHZ		; demos run after the title screen
		dc.w Demo_GHZ
		dc.w Demo_MZ
		dc.w Demo_MZ
		dc.w Demo_SYZ
		dc.w Demo_SYZ