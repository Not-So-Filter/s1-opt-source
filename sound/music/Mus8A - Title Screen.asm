Mus8A_Title_Screen_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Mus8B_Ending_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $05

	smpsHeaderDAC       Mus8A_Title_Screen_DAC
	smpsHeaderFM        Mus8A_Title_Screen_FM1,	$F4, $0C
	smpsHeaderFM        Mus8A_Title_Screen_FM2,	$F4, $09
	smpsHeaderFM        Mus8A_Title_Screen_FM3,	$F4, $0D
	smpsHeaderFM        Mus8A_Title_Screen_FM4,	$F4, $0C
	smpsHeaderFM        Mus8A_Title_Screen_FM5,	$F4, $0E
	smpsHeaderPSG       Mus8A_Title_Screen_PSG1,	$D0, $03, $00, fTone_05
	smpsHeaderPSG       Mus8A_Title_Screen_PSG2,	$DC, $06, $00, fTone_05
	smpsHeaderPSG       Mus8A_Title_Screen_PSG3,	$00, $04, $00, fTone_04

; FM5 Data
Mus8A_Title_Screen_FM5:
	smpsAlterNote       $03

; FM1 Data
Mus8A_Title_Screen_FM1:
	smpsSetvoice        $03
	dc.b	nRst, $3C, nCs6, $15, nRst, $03, nCs6, $06, nRst, nD6, $0F, nRst
	dc.b	$03, nB5, $18, nRst, $06, nCs6, nRst, nCs6, nRst, nCs6, nRst, nA5
	dc.b	nRst, nG5, $0F, nRst, $03, nB5, $0C, nRst, $12, nA5, $06, nRst
	dc.b	nCs6, nRst, nA6, nRst, nE6, $0C, nRst, $06, nAb6, $12, nA6, $06
	dc.b	nRst, $72
	smpsStop

; FM2 Data
Mus8A_Title_Screen_FM2:
	smpsSetvoice        $01
	dc.b	nRst, $30, nA3, $06, nRst, nA3, nRst, nE3, nRst, nE3, nRst, nG3
	dc.b	$12, nFs3, $0C, nG3, $06, nFs3, $0C, nA3, $06, nRst, nA3, nRst
	dc.b	nE3, nRst, nE3, nRst, nD4, $12, nCs4, $0C, nD4, $06, nCs4, $0C
	dc.b	nRst, nA2, nRst, nA2, nRst, $06, nAb3, $12, nA3, $06, nRst, nA2
	dc.b	$6C
	smpsStop

; FM3 Data
Mus8A_Title_Screen_FM3:
	smpsSetvoice        $02
	dc.b	nRst, $30, nE6, $06, nRst, nE6, nRst, nCs6, nRst, nCs6, nRst, nD6
	dc.b	$0F, nRst, $03, nD6, $18, nRst, $06, nE6, nRst, nE6, nRst, nCs6
	dc.b	nRst, nCs6, nRst, nG6, $0F, nRst, $03, nG6, $18, nRst, $06, nE6
	dc.b	$0C, nRst, nE6, nRst, nRst, $06, nEb6, $12, nE6, $0C
	smpsAlterVol        $FC
	smpsSetvoice        $01
	smpsAlterNote       $03
	dc.b	nA2, $6C
	smpsStop

; FM4 Data
Mus8A_Title_Screen_FM4:
	smpsSetvoice        $02
	dc.b	nRst, $30, nCs6, $06, nRst, nCs6, nRst, nA5, nRst, nA5, nRst, nB5
	dc.b	$0F, nRst, $03, nB5, $18, nRst, $06, nCs6, nRst, nCs6, nRst, nA5
	dc.b	nRst, nA5, nRst, nD6, $0F, nRst, $03, nD6, $18, nRst, $06, nCs6
	dc.b	$0C, nRst, nCs6, nRst, nRst, $06, nC6, $12, nCs6, $0C
	smpsAlterVol        $FD
	smpsSetvoice        $01
	smpsModSet          $00, $01, $06, $04
	dc.b	nA2, $6C
	smpsStop

; PSG3 Data
Mus8A_Title_Screen_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $30

Mus8A_Title_Screen_Loop00:
	smpsNoteFill        $03
	dc.b	nMaxPSG, $0C
	smpsNoteFill        $0C
	dc.b	$0C
	smpsNoteFill        $03
	dc.b	$0C
	smpsNoteFill        $0C
	dc.b	$0C
	smpsLoop            $00, $05, Mus8A_Title_Screen_Loop00
	smpsNoteFill        $03
	dc.b	$06
	smpsNoteFill        $0E
	dc.b	$12
	smpsNoteFill        $03
	dc.b	$0C
	smpsNoteFill        $0F
	dc.b	$0C
	smpsStop

; DAC Data
Mus8A_Title_Screen_DAC:
	dc.b	nRst, $0C, dSnare, dSnare, dSnare, dKick, dSnare, dKick, dSnare, dKick, dSnare, dKick
	dc.b	dSnare, dKick, dSnare, dKick, dSnare, dKick, dSnare, dKick, $06, nRst, $02, dSnare
	dc.b	dSnare, dSnare, $09, dSnare, $03, dKick, $0C, dSnare, dKick, dSnare, dKick, $06
	dc.b	dSnare, $12, dSnare, $0C, dKick

; PSG1 Data
Mus8A_Title_Screen_PSG1:
; PSG2 Data
Mus8A_Title_Screen_PSG2:
	smpsStop