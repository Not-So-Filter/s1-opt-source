; ---------------------------------------------------------------------------
; Object 49 - waterfall	sound effect (GHZ)
; ---------------------------------------------------------------------------

WaterSound:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	WSnd_Index(pc,d0.w),d1
		jmp	WSnd_Index(pc,d1.w)
; ===========================================================================
WSnd_Index:	dc.w WSnd_Main-WSnd_Index
		dc.w WSnd_PlaySnd-WSnd_Index
; ===========================================================================

WSnd_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#4,obRender(a0)

WSnd_PlaySnd:	; Routine 2
		moveq	#$3F,d0
		and.b	(v_framebyte).w,d0 ; get low byte of VBlank counter
		bne.s	WSnd_ChkDel
		playsound sfx_Waterfall,sfx

WSnd_ChkDel:
		out_of_range.w	DeleteObject_Respawn
		rts