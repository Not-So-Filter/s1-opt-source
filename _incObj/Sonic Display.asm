; ---------------------------------------------------------------------------
; Subroutine to display Sonic and set music
; ---------------------------------------------------------------------------

Sonic_Display:
		move.b	flashtime(a0),d0
		beq.s	.display
		subq.b	#1,flashtime(a0)
		lsr.b	#3,d0
		bcc.s	.chkinvincible

.display:
		jsr	(DisplaySprite).l

.chkinvincible:
		tst.b	(v_invinc).w	; does Sonic have invincibility?
		beq.s	.chkshoes	; if not, branch
		tst.w	invtime(a0)	; check	time remaining for invinciblity
		beq.s	.chkshoes	; if no	time remains, branch
		subq.w	#1,invtime(a0)	; subtract 1 from time
		bne.s	.chkshoes
		tst.b	(f_lockscreen).w
		bne.s	.removeinvincible
		cmpi.w	#$C,(v_air).w
		blo.s	.removeinvincible
		stopZ80
		move.b	(v_saved_music).w,(z80_ram+zAbsVar.Queue0).l
		startZ80

.removeinvincible:
		clr.b	(v_invinc).w ; cancel invincibility

.chkshoes:
		tst.b	(v_shoes).w	; does Sonic have speed	shoes?
		beq.s	.exit		; if not, branch
		tst.w	shoetime(a0)	; check	time remaining
		beq.s	.exit
		subq.w	#1,shoetime(a0)	; subtract 1 from time
		bne.s	.exit
		move.w	#$600,(v_sonspeedmax).w ; restore Sonic's speed
		move.w	#$C,(v_sonspeedacc).w ; restore Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w ; restore Sonic's deceleration
		clr.b	(v_shoes).w	; cancel speed shoes
		playsound bgm_Slowdown,music

.exit:
		rts