; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Water:
		tst.b	(f_water).w	; is level LZ?
		beq.s	.exit	; if not, branch
		move.w	(v_waterpos1).w,d0
		cmp.w	obY(a0),d0	; is Sonic above the water?
		bge.s	.abovewater	; if yes, branch
		bset	#6,obStatus(a0)
		bne.s	.exit
		bsr.w	ResumeMusic
		move.l	#DrownCount,(v_sonicbubbles).w ; load bubbles object from Sonic's mouth
		move.b	#$81,(v_sonicbubbles+obSubtype).w
		move.w	#$300,(v_sonspeedmax).w ; change Sonic's top speed
		move.w	#6,(v_sonspeedacc).w ; change Sonic's acceleration
		move.w	#$40,(v_sonspeeddec).w ; change Sonic's deceleration
		asr	obVelX(a0)
		asr	obVelY(a0)
		asr	obVelY(a0)	; slow Sonic
		beq.s	.exit		; branch if Sonic stops moving
		move.l	#Splash,(v_splash).w ; load splash object

.exit:
		rts
; ===========================================================================

.abovewater:
		bclr	#6,obStatus(a0)
		beq.s	.exit
		bsr.w	ResumeMusic
		move.w	#$600,(v_sonspeedmax).w ; restore Sonic's speed
		move.w	#$C,(v_sonspeedacc).w ; restore Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w ; restore Sonic's deceleration
		asl	obVelY(a0)
		beq.s	.belowmaxspeed
		move.l	#Splash,(v_splash).w ; load splash object
		cmpi.w	#-$1000,obVelY(a0)
		bgt.s	.belowmaxspeed
		move.w	#-$1000,obVelY(a0) ; set maximum speed on leaving water

.belowmaxspeed:
		rts
; End of function Sonic_Water