; ---------------------------------------------------------------------------
; Subroutine to	delete an object
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DeleteObject_Respawn:
		move.w	obRespawnNo(a0),d0
		beq.s	DeleteObject
		movea.w	d0,a2
		bclr	#7,(a2)

; ---------------------------------------------------------------------------
; Subroutine to	delete an object
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DeleteObject:
		movea.l	a0,a1		; move object RAM address to (a1)

DeleteChild:				; child objects are already in (a1)
		moveq	#0,d0

DelObj_Loop:
	rept $11
		move.l	d0,(a1)+	; clear	the object RAM
	endr

		move.w	d0,(a1)+
		rts

; End of function DeleteObject