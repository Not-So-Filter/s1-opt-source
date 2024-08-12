; ---------------------------------------------------------------------------
; Subroutine to	animate	level graphics
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


AnimateLevelGfx:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		add.w	d0,d0
		move.w	DynAnimCue_Index(pc,d0.w),d1
		lea	DynCue_Index(pc,d1.w),a2
		move.w	DynCue_Index(pc,d0.w),d0
		jmp	DynCue_Index(pc,d0.w)
; ---------------------------------------------------------------------------
; ZONE ANIMATION PROCEDURES AND SCRIPTS
;
; Each zone gets two entries in this jump table. The first entry points to the
; zone's animation procedure (usually Dynamic_Null, AKA none). The second points
; to the zone's animation script.
;
; Seems like stage IDs were already being shifted, since listings for $07-$0F
; can be found, alongside HPZ's art listed from $08 (its ID in the final).
; ---------------------------------------------------------------------------
DynCue_Index:
		dc.w Dynamic_Normal-DynCue_Index
DynAnimCue_Index:
		dc.w AnimCue_GHZ-DynCue_Index
		dc.w Dynamic_Null-DynCue_Index
		dc.w AnimCue_Null-DynCue_Index
		dc.w Dynamic_Normal-DynCue_Index
		dc.w AnimCue_MZ-DynCue_Index
		dc.w Dynamic_Null-DynCue_Index
		dc.w AnimCue_Null-DynCue_Index
		dc.w Dynamic_Null-DynCue_Index
		dc.w AnimCue_Null-DynCue_Index
		dc.w Dynamic_Null-DynCue_Index
		dc.w AnimCue_Null-DynCue_Index
		dc.w Dynamic_Null-DynCue_Index
		dc.w AnimCue_Null-DynCue_Index
; ===========================================================================

Dynamic_Null:
		rts
; ===========================================================================

Dynamic_Normal:
		lea	(Anim_Counters).w,a3
		move.w	(a2)+,d6			; Get number of scripts in list

loc_1AACA:
		subq.b	#1,(a3)				; Tick down frame duration
		bpl.s	loc_1AB10			; If frame isn't over, move on to next script

		moveq	#0,d0
		move.b	1(a3),d0			; Get current frame
		cmp.b	6(a2),d0			; Have we processed the last frame in the script?
		bcs.s	loc_1AAE0
		moveq	#0,d0				; If so, reset to first frame
		move.b	d0,1(a3)

loc_1AAE0:
		addq.b	#1,1(a3)			; Consider this frame processed; set counter to next frame
		move.b	(a2),(a3)			; Set frame duration to global duration value
		bpl.s	loc_1AAEE
		; If script uses per-frame durations, use those instead
		add.w	d0,d0
		move.b	9(a2,d0.w),(a3)			; Set frame duration to current frame's duration value

loc_1AAEE:
		; Prepare for DMA transfer
		; Get relative address of frame's art
		move.b	8(a2,d0.w),d0			; Get tile ID
		lsl.w	#4,d0				; Turn it into an offset
		; Get VRAM destination address
		move.w	4(a2),d2
		; Get ROM source address
		move.l	(a2),d1				; Get start address of animated tile art
		andi.l	#$FFFFFF,d1
		add.l	d0,d1				; Offset into art, to get the address of new frame
		; Get size of art to be transferred
		moveq	#0,d3
		move.b	7(a2),d3
		lsl.w	#4,d3				; Turn it into actual size (in words)
		; Use d1, d2 and d3 to queue art for transfer
		jsr	(QueueDMATransfer).w

loc_1AB10:
		move.b	6(a2),d0			; Get total size of frame data
		tst.b	(a2)				; Is per-frame duration data present?
		bpl.s	loc_1AB1A			; If not, keep the current size; it's correct
		add.b	d0,d0				; Double size to account for the additional frame duration data

loc_1AB1A:
		addq.b	#1,d0
		andi.w	#$FE,d0				; Round to next even address, if it isn't already
		lea	8(a2,d0.w),a2			; Advance to next script in list
		addq.w	#2,a3				; Advance to next script's slot in a3 (usually Anim_Counters)
		dbf	d6,loc_1AACA
		rts
; ===========================================================================

; macros for defining animated PLC script lists
zoneanimstart macro {INTLABEL}
__LABEL__ label *
zoneanimcount := 0
zoneanimcur := "__LABEL__"
	dc.w zoneanimcount___LABEL__	; Number of scripts for a zone (-1)
    endm

zoneanimend macro
zoneanimcount_{"\{zoneanimcur}"} = zoneanimcount-1
    endm

zoneanimdeclanonid := 0

zoneanimdecl macro duration,artaddr,vramaddr,numentries,numvramtiles
zoneanimdeclanonid := zoneanimdeclanonid + 1
start:
	dc.l (duration&$FF)<<24|dmaSource(artaddr)
	dc.w tiles_to_bytes(vramaddr)
	dc.b numentries, numvramtiles
zoneanimcount := zoneanimcount + 1
    endm

AnimCue_Null:

AnimCue_GHZ:	zoneanimstart
		; Waterfall
		zoneanimdecl 5, Art_GhzWater, ArtTile_GHZ_Waterfall, 2, 8
		dc.b   0
		dc.b   8
		even

		; Flowers
		zoneanimdecl $F, Art_GhzFlower1, ArtTile_GHZ_Big_Flower_1, 2, 16
		dc.b   0
		dc.b   16
		even

		; Flowers
		zoneanimdecl -1, Art_GhzFlower2, ArtTile_GHZ_Small_Flower, 4, 12
		dc.b   0,$7F
		dc.b   12,7
		dc.b   24,$7F
		dc.b   12,7
		even

		zoneanimend
		
AnimCue_MZ:	zoneanimstart
		; Lava surface
		zoneanimdecl $13, Art_MzLava1, ArtTile_MZ_Animated_Lava, 3, 8
		dc.b   0
		dc.b   2
		dc.b   4
		even
		
		; Torch
		zoneanimdecl $13, Art_MzTorch, ArtTile_MZ_Torch, 3, 6
		dc.b   0
		dc.b   2
		dc.b   4
		even

		zoneanimend