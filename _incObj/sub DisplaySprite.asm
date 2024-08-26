; ---------------------------------------------------------------------------
; Subroutine to	display	a sprite/object, when a0 is the	object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DisplaySprite:
		lea	(v_spritequeue).w,a1
		adda.w	obPriority(a0),a1 ; add sprite priority to queue
		tst.w	(a1)		; is the priority negative ($80)?
		bmi.s	DSpr_Full	; if yes, branch
		addq.w	#2,(a1)		; increment sprite count
		adda.w	(a1),a1		; jump to empty position
		move.w	a0,(a1)		; insert RAM address for object

DSpr_Full:
		rts

; End of function DisplaySprite


; ---------------------------------------------------------------------------
; Subroutine to	display	a 2nd sprite/object, when a1 is	the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DisplaySprite1:
		lea	(v_spritequeue).w,a2
		adda.w	obPriority(a1),a2
		tst.w	(a2)
		bmi.s	DSpr1_Full
		addq.w	#2,(a2)
		adda.w	(a2),a2
		move.w	a1,(a2)

DSpr1_Full:
		rts

; End of function DisplaySprite1

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; and d0 is already (priority/2)&$380
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

DisplaySprite2:
		lea	(v_spritequeue).w,a1
		adda.w	d0,a1
		tst.w	(a1)	; is this part of the queue full?
		bmi.s	DSpr2_End	; if yes, branch
		addq.w	#2,(a1)		; increment sprite count
		adda.w	(a1),a1		; jump to empty position
		move.w	a0,(a1)		; insert RAM address for object

DSpr2_End:
		rts

; End of function DisplaySprite2