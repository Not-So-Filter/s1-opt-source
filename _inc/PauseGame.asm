; ---------------------------------------------------------------------------
; Subroutine to	pause the game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PauseGame:
		tst.b	(v_lives).w	; do you have any lives	left?
		beq.s	Unpause		; if not, branch
		tst.b	(f_pause).w	; is game already paused?
		bne.s	Pause_StopGame	; if yes, branch
		tst.b	(v_jpadpress).w ; is Start button pressed?
		bpl.s	Pause_DoNothing	; if not, branch

Pause_StopGame:
		st.b	(f_pause).w	; freeze time
		stopZ80
		move.b	#MusID_Pause,(z80_ram+zAbsVar.StopMusic).l ; pause music
		startZ80

Pause_Loop:
		move.w	#VBla_08,(v_vbla_routine).w
		bsr.w	WaitForVBla
		tst.b	(f_slomocheat).w ; is slow-motion cheat on?
		beq.s	Pause_ChkStart	; if not, branch
		btst	#bitA,(v_jpadpress).w ; is button A pressed?
		beq.s	Pause_ChkBC	; if not, branch
		move.w	#GM_Title,(v_gamemode).w ; set game mode to 4 (title screen)
		stopZ80
		move.b	#MusID_Unpause,(z80_ram+zAbsVar.StopMusic).l	; unpause the music
		startZ80

Unpause:
		clr.b	(f_pause).w	; unpause the game

Pause_DoNothing:
		rts
; ===========================================================================

Pause_ChkBC:
		btst	#bitB,(v_jpadhold).w ; is button B pressed?
		bne.s	Pause_SlowMo	; if yes, branch
		btst	#bitC,(v_jpadpress).w ; is button C pressed?
		bne.s	Pause_SlowMo	; if yes, branch

Pause_ChkStart:
		tst.b	(v_jpadpress).w ; is Start button pressed?
		bpl.s	Pause_Loop	; if not, branch

Pause_EndMusic:
		stopZ80
		move.b	#MusID_Unpause,(z80_ram+zAbsVar.StopMusic).l	; unpause the music
		startZ80
		clr.b	(f_pause).w	; unpause the game
		rts
; ===========================================================================

Pause_SlowMo:
		st.b	(f_pause).w
		stopZ80
		move.b	#MusID_Unpause,(z80_ram+zAbsVar.StopMusic).l	; unpause the music
		startZ80
		rts
; End of function PauseGame
