; ---------------------------------------------------------------------------
; Moduled Kosinski decompression queue.
; For format explanation see https://segaretro.org/Kosinski_compression
;
; This version is slightly optimized compared to S3&K version.
; Also, it uses the faster Kosinski compressor internally.
; ---------------------------------------------------------------------------
; Permission to use, copy, modify, and/or distribute this software for any
; purpose with or without fee is hereby granted.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
; OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
; ---------------------------------------------------------------------------
; FUNCTION:
; 	Queue_Kos_Module
;
; DESCRIPTION
; 	Adds a Kosinski Moduled archive to the module queue
;
; INPUT:
; 	a1	Source address
; 	d2	Destination address in VRAM
; ---------------------------------------------------------------------------
; FUNCTION:
;	Process_Kos_Module_Queue
;
; DESCRIPTION:
; 	Processes the first module on the queue
; ---------------------------------------------------------------------------
; FUNCTION:
; 	Queue_Kos
;
; DESCRIPTION
; 	Adds Kosinski-compressed data to the decompression queue
;
; INPUT:
; 	a1	Compressed data address
; 	a2	Decompression destination in RAM
; ---------------------------------------------------------------------------
; FUNCTION:
; 	Set_Kos_Bookmark
;
; DESCRIPTION
; 	Checks if V-int occured in the middle of Kosinski queue processing
; 	and stores the location from which processing is to resume if it did
; ---------------------------------------------------------------------------
; FUNCTION:
; 	Process_Kos_Queue
;
; DESCRIPTION
; 	Processes the first entry in the Kosinski decompression queue
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
Queue_Kos_Module:
	lea	(Kos_module_queue).w,a2
	tst.l	(a2)	; is the first slot free?
	beq.s	Process_Kos_Module_Queue_Init	; if it is, branch

.findFreeSlot:
	addq.w	#6,a2	; otherwise, check next slot
	tst.l	(a2)
	bne.s	.findFreeSlot

	move.l	a1,(a2)+	; store source address
	move.w	d2,(a2)+	; store destination VRAM address
	rts
; End of function Queue_Kos_Module
; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
; Initializes processing of the first module on the queue
; ---------------------------------------------------------------------------
Process_Kos_Module_Queue_Init:
	move.w	(a1)+,d3				; get uncompressed size
	cmpi.w	#$A000,d3
	bne.s	.gotsize
	move.w	#$8000,d3				; $A000 means $8000 for some reason

.gotsize:
	lsr.w	#1,d3
	move.w	d3,d0
	rol.w	#5,d0
	andi.w	#$1F,d0					; get number of complete modules
	move.w	d0,(Kos_modules_left).w
	andi.w	#$7FF,d3				; get size of last module in words
	bne.s	.gotleftover			; branch if it's non-zero
	subq.w	#1,(Kos_modules_left).w	; otherwise decrement the number of modules
	move.w	#$800,d3				; and take the size of the last module to be $800 words

.gotleftover:
	move.w	d3,(Kos_last_module_size).w
	move.w	d2,(Kos_module_destination).w
	move.l	a1,(Kos_module_queue).w
	addq.w	#1,(Kos_modules_left).w	; store total number of modules
	rts
; End of function Process_Kos_Module_Queue_Init
; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
Process_Kos_Module_Queue:
	tst.w	(Kos_modules_left).w
	bne.s	.modulesLeft

.done:
	rts
; ---------------------------------------------------------------------------
.modulesLeft:
	bmi.s	.decompressionStarted
	cmpi.w	#(Kos_decomp_queue_End-Kos_decomp_queue)/8,(Kos_decomp_queue_count).w
	bhs.s	.done					; branch if the Kosinski decompression queue is full
	movea.l	(Kos_module_queue).w,a1
	lea	(Kos_decomp_buffer).w,a2
	move.w	(Kos_decomp_queue_count).w,d0
	lsl.w	#3,d0
	lea	(Kos_decomp_queue).w,a3
	move.l	a1,(a3,d0.w)			; store source
	move.l	a2,4(a3,d0.w)			; store destination
	addq.w	#1,(Kos_decomp_queue_count).w
	ori.w	#$8000,(Kos_modules_left).w	; and set bit to signify decompression in progress
	rts
; ---------------------------------------------------------------------------
.decompressionStarted:
	tst.w	(Kos_decomp_queue_count).w
	bne.s	.done					; branch if the decompression isn't complete

	; otherwise, DMA the decompressed data to VRAM
	andi.w	#$7F,(Kos_modules_left).w
	move.w	#$800,d3
	subq.w	#1,(Kos_modules_left).w
	bne.s	.skip	; branch if it isn't the last module
	move.w	(Kos_last_module_size).w,d3

.skip:
	move.w	(Kos_module_destination).w,d2
	move.w	d2,d0
	add.w	d3,d0
	add.w	d3,d0
	move.w	d0,(Kos_module_destination).w	; set new destination
	move.l	(Kos_module_queue).w,d0
	move.l	(Kos_decomp_source).w,(Kos_module_queue).w
	move.l	#dmaSource(Kos_decomp_buffer),d1
	move.w	sr,-(sp)						; Save current interrupt mask
	disableInts								; Mask off interrupts
	bsr.w	QueueDMATransfer
	move.w	(sp)+,sr						; Restore interrupts to previous state
	tst.w	(Kos_modules_left).w
	bne.s	.exit					; return if this wasn't the last module
	; otherwise, shift all entries up
	lea	(Kos_module_queue).w,a0
	lea	(Kos_module_queue+6).w,a1
	rept (Kos_module_queue_End-(Kos_module_queue+6))/6
		move.l	(a1)+,(a0)+
		move.w	(a1)+,(a0)+
	endm
	moveq	#0,d0
	move.l	d0,(a0)+				; and mark the last slot as free
	move.w	d0,(a0)+
	move.l	(Kos_module_queue).w,d0
	beq.s	.exit					; return if the queue is now empty
	movea.l	d0,a1
	move.w	(Kos_module_destination).w,d2
	bra.w	Process_Kos_Module_Queue_Init
; ---------------------------------------------------------------------------
.exit:
	rts
; End of function Process_Kos_Module_Queue
; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
Queue_Kos:
	move.w	(Kos_decomp_queue_count).w,d0
	lsl.w	#3,d0
	lea	(Kos_decomp_queue).w,a3
	move.l	a1,(a3,d0.w)			; store source
	move.l	a2,4(a3,d0.w)			; store destination
	addq.w	#1,(Kos_decomp_queue_count).w
	rts
; End of function Queue_Kos
; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
Set_Kos_Bookmark:
	tst.w	(Kos_decomp_queue_count).w
	bpl.s	.done					; branch if a decompression wasn't in progress
	move.l	$42(sp),d0				; check address V-int is supposed to rte to
	cmpi.l	#Process_Kos_Queue.Main,d0
	blo.s	.done
	cmpi.l	#Process_Kos_Queue.Done,d0
	bhs.s	.done
	move.l	d0,(Kos_decomp_bookmark).w
	move.l	#Backup_Kos_Registers,$42(sp)	; force V-int to rte here instead if needed

.done:
	rts
; End of function Set_Kos_Bookmark
; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
Process_Kos_Queue:
	tst.w	(Kos_decomp_queue_count).w
	beq.s	Set_Kos_Bookmark.done
	bpl.s	.Main	; branch if a decompression wasn't interrupted by V-int
	movem.w	(Kos_decomp_stored_Wregisters).w,d0/d2/d4-d7
	movem.l	(Kos_decomp_stored_Lregisters).w,a0-a1/a5
	move.l	(Kos_decomp_bookmark).w,-(sp)
	move.w	(Kos_decomp_stored_SR).w,-(sp)
	rte

.Main:
	ori.w	#$8000,(Kos_decomp_queue_count).w	; set sign bit to signify decompression in progress
	movem.l	(Kos_decomp_source).w,a0-a1

	include "KosinskiPlus Internal.asm"
	movem.l	a0-a1,(Kos_decomp_source).w
	andi.w	#$7FFF,(Kos_decomp_queue_count).w	; clear decompression in progress bit
	subq.w	#1,(Kos_decomp_queue_count).w
	beq.s	.Done								; branch if there aren't any entries remaining in the queue
	lea	(Kos_decomp_queue).w,a0
	lea	(Kos_decomp_queue+8).w,a1				; otherwise, shift all entries up
	rept (Kos_decomp_queue_End-(Kos_decomp_queue+8))/4
		move.l	(a1)+,(a0)+
	endm

.Done:
	rts
; End of function Process_Kos_Queue
; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
; Backs up current state for later restoration.
; ---------------------------------------------------------------------------
Backup_Kos_Registers:
	move	sr,(Kos_decomp_stored_SR).w
	movem.w	d0/d2/d4-d7,(Kos_decomp_stored_Wregisters).w
	movem.l	a0-a1/a5,(Kos_decomp_stored_Lregisters).w
	rts
; ===========================================================================