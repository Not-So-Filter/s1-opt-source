; ---------------------------------------------------------------------------
; Subroutine to	pause the game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PauseGame:
		tst.b	(v_lives).w	; do you have any lives	left?
		beq.s	Unpause		; if not, branch
		tst.b	(f_pause).w	; is game already paused?
		bne.s	Pause_StopGame	; if yes, branch
		tst.b	(v_jpadpress1).w ; is Start button pressed?
		bpl.s	Pause_DoNothing	; if not, branch

Pause_StopGame:
		moveq	#1,d0
		move.b	d0,(f_pause).w	; freeze time
		move.b	d0,(v_snddriver_ram.f_pausemusic).w ; pause music

Pause_Loop:
		move.w	#id_VB_0C,(v_vbla_routine).w
		bsr.w	WaitForVBla
		tst.b	(f_slomocheat).w ; is slow-motion cheat on?
		beq.s	Pause_ChkStart	; if not, branch
		btst	#bitA,(v_jpadpress1).w ; is button A pressed?
		beq.s	Pause_ChkBC	; if not, branch
		move.w	#id_Title,(v_gamemode).w ; set game mode to 4 (title screen)
		bra.s	Pause_EndMusic
; ===========================================================================

Pause_ChkBC:
		btst	#bitB,(v_jpadhold1).w ; is button B pressed?
		bne.s	Pause_SlowMo	; if yes, branch
		btst	#bitC,(v_jpadpress1).w ; is button C pressed?
		bne.s	Pause_SlowMo	; if yes, branch

Pause_ChkStart:
		tst.b	(v_jpadpress1).w ; is Start button pressed?
		bpl.s	Pause_Loop	; if not, branch

Pause_EndMusic:
		move.b	#$80,(v_snddriver_ram.f_pausemusic).w	; unpause the music

Unpause:
		clr.b	(f_pause).w	; unpause the game

Pause_DoNothing:
		rts
; ===========================================================================

Pause_SlowMo:
		st.b	(f_pause).w
		move.b	#$80,(v_snddriver_ram.f_pausemusic).w	; Unpause the music
		rts	
; End of function PauseGame
