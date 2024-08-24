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
	if object_size=$40
		subq.w	#1,d0
		bcs.s	NFree_Found
        else
		move.b	+(pc,d0.w),d0		; load the right number of objects from table
		bmi.s	NFree_Found		; if negative, we have failed!
        endif

NFree_Loop:
		lea	object_size(a1),a1
		tst.b	obID(a1)
		dbeq	d0,NFree_Loop

NFree_Found:
		rts	

; End of function FindNextFreeObj

	if object_size<>$40
+
.a		set	v_lvlobjspace
.b		set	v_lvlobjend
.c		set	.b			; begin from bottom of array and decrease backwards
		rept	(.b-.a+$40-1)/$40	; repeat for all slots, minus exception
.c		set	.c-$40			; address for previous $40 (also skip last part)
		dc.b	(.b-.c-1)/object_size-1	; write possible slots according to object_size division + hack + dbf hack
		endm
		even
	endif