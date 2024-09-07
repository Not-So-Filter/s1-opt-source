; ===========================================================================
; ---------------------------------------------------------------------------
; Sample 68k PCM list
; ---------------------------------------------------------------------------

SampleList:

	; --- Sonic 1 Samples ---

		dc.l	Sonic1Kick			; 00
		dc.l	Sonic1Snare			; 01
		dc.l	Sonic1Timpani			; 02
		dc.l	StopSample	; Free slot	; 03
		dc.l	StopSample	; Free slot	; 04
		dc.l	StopSample	; Free slot	; 05
		dc.l	StopSample	; Free slot	; 06
		dc.l	StopSample	; Free slot	; 07

; ---------------------------------------------------------------------------
; Sample z80 pointers
; ---------------------------------------------------------------------------
Sec	=	14000	; Hz per second
Mil	=	1000	; centi-seconds per second

	; --- Stop Sample (used by note 80) ---

StopSample:		dcz80	SWF_StopSample,		SWF_StopSample_Rev,	SWF_StopSample,		SWF_StopSample_Rev

	; --- Sonic 1 Samples ---

Sonic1Kick:		dcz80	SWF_S1_Kick,		SWF_S1_Kick_Rev,	SWF_StopSample,		SWF_StopSample_Rev
Sonic1Snare:		dcz80	SWF_S1_Snare,		SWF_S1_Snare_Rev,	SWF_StopSample,		SWF_StopSample_Rev
Sonic1Timpani:		dcz80	SWF_S1_Timpani,		SWF_S1_Timpani,		SWF_StopSample,		SWF_StopSample_Rev

; ---------------------------------------------------------------------------
; Sample file includes
; ---------------------------------------------------------------------------
			align	$8000
; ---------------------------------------------------------------------------

	; --- Volume tables ---

PCM_Volumes:		binclude	"Volume Maker/Volumes.bin"

	; --- Stop Sample (used by note 80) ---

			EndMarker
SWF_StopSample:		dcb.b	$8000-((Z80E_Read*(($1000+$100)/$100))*2),$80
SWF_StopSample_Rev:	EndMarker

	; --- Sonic 1 Samples ---

SWF_S1_Kick:		binclude	"Samples/Sonic 1 Kick.swf"
SWF_S1_Kick_Rev:	EndMarker
SWF_S1_Snare:		binclude	"Samples/Sonic 1 Snare.swf"
SWF_S1_Snare_Rev:	EndMarker
SWF_S1_Timpani:		binclude	"Samples/Sonic 1 Timpani.swf"
SWF_S1_Timpani_Rev:	EndMarker

; ===========================================================================