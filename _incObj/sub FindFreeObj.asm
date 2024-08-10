; ---------------------------------------------------------------------------
; Subroutine to find a free object space

; output:
;	a1 = free position in object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindFreeObj:
		lea	(v_lvlobjspace).w,a1 ; start address for object RAM
		moveq	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d0
		bra.s	NFree_Loop

; End of function FindFreeObj


; ---------------------------------------------------------------------------
; Subroutine to find a free object space AFTER the current one

; output:
;	a1 = free position in object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindNextFreeObj:
		movea.l	a0,a1
		move.w	#v_lvlobjend,d0
		sub.w	a0,d0
		lsr.w	#object_size_bits,d0
		subq.w	#1,d0
		bcs.s	NFree_Found

NFree_Loop:
		lea	object_size(a1),a1
		tst.b	obID(a1)
		dbeq	d0,NFree_Loop

NFree_Found:
		rts	

; End of function FindNextFreeObj