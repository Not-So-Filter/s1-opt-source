; ---------------------------------------------------------------------------
; Subroutine to remember whether an object is destroyed/collected
; ---------------------------------------------------------------------------

RememberState:
		out_of_range.s	.offscreen
		bra.w	DisplaySprite

.offscreen:
		move.w	obRespawnNo(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		bra.w	DeleteObject