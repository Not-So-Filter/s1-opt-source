
SpriteQueue struct DOTS
priority0:		ds.b	$80
priority1:		ds.b	$80
priority2:		ds.b	$80
priority3:		ds.b	$80
priority4:		ds.b	$80
priority5:		ds.b	$80
priority6:		ds.b	$80
priority7:		ds.b	$80
	endstruct

; 511 is default
; maximum number possible is 759
Max_Rings = 613
    if Max_Rings > 759
    fatal "Maximum number of rings possible is 759"
    endif

Rings_Space = (Max_Rings+1)*2

; set this to any integer (normally 16)
Max_PLC = 16

; sign-extends a 32-bit integer to 64-bit
; all RAM addresses are run through this function to allow them to work in both 16-bit and 32-bit addressing modes
ramaddr function x,(-(x&$80000000)<<1)|x

; Variables (v) and Flags (f)

	phase ramaddr ( $FFFF0000 )
v_ram_start:

v_128x128:		ds.b	256*128		; 128x128 tile mappings ($FF chunks)
v_128x128_end:

Level_layout_header:	ds.b	8		; first word = chunks per FG row, second word = chunks per BG row, third word = FG rows, fourth word = BG rows
Level_layout_main:	ds.b	$FF8		; $40 word-sized line pointers followed by actual layout data
Level_layout_main_end:
Level_layout_bg:	= Level_layout_main+2

Kos_decomp_buffer:	ds.b	$1000		; each module in a KosM archive is decompressed here and then DMAed to VRAM
Kos_decomp_buffer_end:
Kos_decomp_queue_count:	ds.w	1		; the number of pieces of data on the queue. Sign bit set indicates a decompression is in progress
Kos_decomp_stored_Wregisters:	ds.w	7	; allows decompression to be spread over multiple frames
Kos_decomp_stored_Lregisters:	ds.l	3	; allows decompression to be spread over multiple frames
Kos_decomp_stored_registers:	=	Kos_decomp_stored_Wregisters
Kos_decomp_stored_registers_End:	=	*
Kos_decomp_stored_SR:	ds.w	1
Kos_decomp_bookmark:	ds.l	1		; the address within the Kosinski queue processor at which processing is to be resumed
Kos_description_field:	ds.w	1		; used by the Kosinski queue processor the same way the stack is used by the normal Kosinski decompression routine
Kos_decomp_queue:	ds.l	2*4		; 2 longwords per entry, first is source location and second is decompression location
Kos_decomp_queue_End:
Kos_decomp_source: =	Kos_decomp_queue	; long ; the compressed data location for the first entry in the queue
Kos_decomp_destination: =	Kos_decomp_queue+4	; long ; the decompression location for the first entry in the queue
Kos_modules_left:	ds.w	1		; the number of modules left to decompresses. Sign bit set indicates a module is being decompressed/has been decompressed
Kos_last_module_size:	ds.w	1		; the uncompressed size of the last module in words. All other modules are $800 words
Kos_module_queue:	ds.b	6*Max_PLC	; 6 bytes per entry, first longword is source location and next word is VRAM destination
Kos_module_queue_End:
Kos_module_source: =	Kos_module_queue	; long ; the compressed data location for the first module in the queue
Kos_module_destination: =	Kos_module_queue+4	; word ; the VRAM destination for the first module in the queue

Kos_module_end:

Ring_Positions:		ds.b	Rings_Space
Ring_Positions_End:

Ring_start_addr_ROM:	ds.l	1
Ring_end_addr_ROM:	ds.l	1
Ring_start_addr_RAM:	ds.w	1
Perfect_rings_left:	ds.w	1
Ring_consumption_table:	ds.b	$80
Ring_consumption_table_End:

v_bgscroll_buffer:	ds.b	$200		; background scroll buffer
Object_respawn_table:	ds.b	1024		; 1 byte per object, every object in the level gets an entry (normally 768)
Object_respawn_table_end:

v_spritequeue:		SpriteQueue		; sprite display queue, in order of priority
v_spritequeue_end:
v_16x16:		ds.b	16*384		; 16x16 tile mappings

VDP_Command_Buffer:	ds.w	7*$12		; $FC bytes

VDP_Command_Buffer_Slot:	ds.w	1
			ds.b	$202		; unused
v_tracksonic:		ds.b	$100		; position tracking data for Sonic
v_hscrolltablebuffer:	ds.b	$380		; scrolling table data
v_hscrolltablebuffer_end:
			ds.b	$80		; unused

v_objspace:		ds.b	object_size*128	; object variable space ($40 bytes per object)

; Title screen objects
v_sonicteam	= v_objspace+object_size*2	; object variable space for the "SONIC TEAM PRESENTS" text ($40 bytes)
v_titlesonic	= v_objspace+object_size*1	; object variable space for Sonic in the title screen ($40 bytes)
v_pressstart	= v_objspace+object_size*2	; object variable space for the "PRESS START BUTTON" text ($40 bytes)
v_titletm	= v_objspace+object_size*3	; object variable space for the trademark symbol ($40 bytes)
v_ttlsonichide	= v_objspace+object_size*4	; object variable space for hiding part of Sonic ($40 bytes)

; Level objects
v_player	= v_objspace+object_size*0	; object variable space for Sonic ($40 bytes)

v_titlecard	= v_objspace+object_size*1	; object variable space for the title card ($100 bytes)
v_ttlcardname	= v_titlecard+object_size*0	; object variable space for the title card zone name text ($40 bytes)
v_ttlcardzone	= v_titlecard+object_size*1	; object variable space for the title card "ZONE" text ($40 bytes)
v_ttlcardact	= v_titlecard+object_size*2	; object variable space for the title card act text ($40 bytes)
v_ttlcardoval	= v_titlecard+object_size*3	; object variable space for the title card oval ($40 bytes)

v_gameovertext1	= v_objspace+object_size*2	; object variable space for the "GAME"/"TIME" in "GAME OVER"/"TIME OVER" text ($40 bytes)
v_gameovertext2	= v_objspace+object_size*3	; object variable space for the "OVER" in "GAME OVER"/"TIME OVER" text ($40 bytes)

v_shieldobj	= v_objspace+object_size*6	; object variable space for the shield ($40 bytes)
v_starsobj1	= v_objspace+object_size*8	; object variable space for the invincibility stars #1 ($40 bytes)
v_starsobj2	= v_objspace+object_size*9	; object variable space for the invincibility stars #2 ($40 bytes)
v_starsobj3	= v_objspace+object_size*10	; object variable space for the invincibility stars #3 ($40 bytes)
v_starsobj4	= v_objspace+object_size*11	; object variable space for the invincibility stars #4 ($40 bytes)

v_splash	= v_objspace+object_size*12	; object variable space for the water splash ($40 bytes)
v_sonicbubbles	= v_objspace+object_size*13	; object variable space for the bubbles that come out of Sonic's mouth/drown countdown ($40 bytes)
v_watersurface1	= v_objspace+object_size*30	; object variable space for the water surface #1 ($40 bytes)
v_watersurface2	= v_objspace+object_size*31	; object variable space for the water surface #1 ($40 bytes)

v_endcard	= v_objspace+object_size*23	; object variable space for the level results card ($1C0 bytes)
v_endcardsonic	= v_endcard+object_size*0	; object variable space for the level results card "SONIC HAS" text ($40 bytes)
v_endcardpassed	= v_endcard+object_size*1	; object variable space for the level results card "PASSED" text ($40 bytes)
v_endcardact	= v_endcard+object_size*2	; object variable space for the level results card act text ($40 bytes)
v_endcardscore	= v_endcard+object_size*3	; object variable space for the level results card score tally ($40 bytes)
v_endcardtime	= v_endcard+object_size*4	; object variable space for the level results card time bonus tally ($40 bytes)
v_endcardring	= v_endcard+object_size*5	; object variable space for the level results card ring bonus tally ($40 bytes)
v_endcardoval	= v_endcard+object_size*6	; object variable space for the level results card oval ($40 bytes)

v_lvlobjspace	= v_objspace+object_size*32	; level object variable space ($1800 bytes)
v_lvlobjend	= v_lvlobjspace+object_size*96
v_objspace_end	= v_lvlobjend

; Credits objects
v_credits	= v_objspace+object_size*2	; object variable space for the credits text ($40 bytes)

			ds.b	$100		; unused

v_gamemode:		ds.w	1		; game mode (00=Sega; 04=Title; 08=Demo; 0C=Level; 10=SS; 14=Cont; 18=End; 1C=Credit; +8C=PreLevel)
			ds.b	2		; unused
v_jpadhold_stored:	ds.b	1		; joypad input - held (storage)
v_jpadpress_stored:	ds.b	1		; joypad input - pressed (storage)
v_jpadhold:		ds.b	1		; joypad input - held
v_jpadpress:		ds.b	1		; joypad input - pressed
v_gmdemo:		ds.b	1		; demo game mode flag
			ds.b	1		; unused
v_prelevel:		ds.b	1		; pre-level flag
			ds.b	1		; unused
v_vdp_buffer1:		ds.w	1		; VDP instruction buffer
			ds.b	6		; unused
v_demolength:		ds.w	1		; the length of a demo in frames
v_scrposy_vdp:		ds.w	1		; screen position y (VDP)
v_bgscrposy_vdp:	ds.w	1		; background screen position y (VDP)
v_scrposx_vdp:		ds.w	1		; screen position x (VDP)
v_bgscrposx_vdp:	ds.w	1		; background screen position x (VDP)
v_bg3scrposy_vdp:	ds.w	1
v_bg3scrposx_vdp:	ds.w	1
			ds.b	2		; unused
v_hbla_hreg:		ds.w	1		; VDP H.interrupt register buffer (8Axx)
v_hbla_line = v_hbla_hreg+1			; screen line where water starts and palette is changed by HBlank
v_pfade_start:		ds.b	1		; palette fading - start position in bytes
v_pfade_size:		ds.b	1		; palette fading - number of colours

v_misc_variables:
v_vbla_routine:		ds.w	1		; VBlank - routine
			ds.b	2		; unused
v_spritecount:		ds.b	1		; number of sprites on-screen
			ds.b	1		; unused
v_vbla_counter:		ds.b	1		; VBlank - counter
			ds.b	3		; unused
v_pcyc_num:		ds.w	1		; palette cycling - current reference number
v_pcyc_time:		ds.w	1		; palette cycling - time until the next change
v_random:		ds.l	1		; pseudo random number buffer
f_pause:		ds.w	1		; flag set to pause the game
			ds.b	4		; unused
v_vdp_buffer2:		ds.w	1		; VDP instruction buffer
			ds.b	2		; unused
f_hbla_pal:		ds.w	1		; flag set to change palette during HBlank (0000 = no; 0001 = change)
v_waterpos1:		ds.w	1		; water height, actual
v_waterpos2:		ds.w	1		; water height, ignoring sway
v_waterpos3:		ds.w	1		; water height, next target
f_water:		ds.b	1		; flag set for water
v_wtr_routine:		ds.b	1		; water event - routine counter
f_wtr_state:		ds.b	1		; water palette state when water is above/below the screen (00 = partly/all dry; 01 = all underwater)
f_doupdatesinhblank:	ds.b	1		; defers performing various tasks to the Horizontal Interrupt (H-Blank)
v_pal_buffer:		ds.b	$30		; palette data buffer (used for palette cycling)
v_misc_variables_end:

v_levelvariables:				; variables that are reset between levels
v_screenposx:		ds.l	1		; screen position x
v_screenposy:		ds.l	1		; screen position y
v_bgscreenposx:		ds.l	1		; background screen position x
v_bgscreenposy:		ds.l	1		; background screen position y
v_bg2screenposx:	ds.l	1
v_bg2screenposy:	ds.l	1
v_bg3screenposx:	ds.l	1
v_bg3screenposy:	ds.l	1
v_limitleft1:		ds.w	1		; left level boundary (unused)
v_limitright1:		ds.w	1		; right level boundary (unused)
v_limittop1:		ds.w	1		; top level boundary (unused)
v_limitbtm1:		ds.w	1		; bottom level boundary
v_limitleft2:		ds.w	1		; left level boundary
v_limitright2:		ds.w	1		; right level boundary
v_limittop2:		ds.w	1		; top level boundary
v_limitbtm2:		ds.w	1		; bottom level boundary
			ds.b	2		; unused
v_limitleft3:		ds.w	1		; left level boundary, at the end of an act
			ds.b	6		; unused
v_scrshiftx:		ds.w	1		; x-screen shift (new - last) * $100
v_scrshifty:		ds.w	1		; y-screen shift (new - last) * $100
v_lookshift:		ds.w	1		; screen shift when Sonic looks up/down
			ds.b	2		; unused
v_dle_routine:		ds.w	1		; dynamic level event - routine counter
f_nobgscroll:		ds.b	1		; flag set to cancel background scrolling
			ds.b	5		; unused
v_fg_xblock:		ds.b	1		; foreground x-block parity (for redraw)
v_fg_yblock:		ds.b	1		; foreground y-block parity (for redraw)
v_bg1_xblock:		ds.b	1		; background x-block parity (for redraw)
v_bg1_yblock:		ds.b	1		; background y-block parity (for redraw)
v_bg2_xblock:		ds.b	1		; secondary background x-block parity (for redraw)
v_bg2_yblock:		ds.b	1		; secondary background y-block parity (unused)
v_bg3_xblock:		ds.b	1		; teritary background x-block parity (for redraw)
v_bg3_yblock:		ds.b	1		; teritary background y-block parity (unused)
			ds.w	1		; unused
v_fg_scroll_flags:	ds.w	1		; screen redraw flags for foreground
v_bg1_scroll_flags:	ds.w	1		; screen redraw flags for background 1
v_bg2_scroll_flags:	ds.w	1		; screen redraw flags for background 2
v_bg3_scroll_flags:	ds.w	1		; screen redraw flags for background 3
f_bgscrollvert:		ds.b	1		; flag for vertical background scrolling
			ds.b	3		; unused
v_sonspeedmax:		ds.w	1		; Sonic's maximum speed
v_sonspeedacc:		ds.w	1		; Sonic's acceleration
v_sonspeeddec:		ds.w	1		; Sonic's deceleration
v_sonframenum:		ds.b	1		; frame to display for Sonic
f_sonframechg:		ds.b	1		; flag set to update Sonic's sprite frame
v_anglebuffer:		ds.b	1		; angle of collision block that Sonic or object is standing on
v_anglebuffer2:		ds.b	1		; other angle of collision block that Sonic or object is standing on
			ds.b	2		; unused
v_opl_routine:		ds.w	1		; ObjPosLoad - routine counter
Camera_X_pos_coarse:	ds.w	1		; rounded down to the nearest chunk boundary (128th pixel)
Camera_Y_pos_coarse:	ds.w	1		; rounded down to the nearest chunk boundary (128th pixel)
Object_load_addr_front:	ds.l	1		; the address inside the object placement data of the first object whose X pos is >= Camera_X_pos_coarse + $280
Object_load_addr_back:	ds.l	1		; the address inside the object placement data of the first object whose X pos is >= Camera_X_pos_coarse - $80
Object_respawn_index_front:	ds.w	1	; the object respawn table index for the object at Obj_load_addr_front
Object_respawn_index_back:	ds.w	1	; the object respawn table index for the object at Obj_load_addr_back
Camera_Y_pos_coarse_back:	ds.w	1	; Camera_Y_pos_coarse - $80
Rings_manager_routine:	ds.w	1
Camera_X_pos_coarse_back:	ds.w	1
Screen_Y_wrap_value:	ds.w	1		; either $7FF or $FFF
			ds.b	$A		; unused
v_btnpushtime1:		ds.w	1		; button push duration - in level
v_btnpushtime2:		ds.w	1		; button push duration - in demo
v_palchgspeed:		ds.w	1		; palette fade/transition speed (0 is fastest)
v_collindex:		ds.l	1		; ROM address for collision index of current level
			ds.b	$A		; unused
v_obj31ypos:		ds.w	1		; y-position of object 31 (MZ stomper)
			ds.b	1		; unused
v_bossstatus:		ds.b	1		; status of boss and prison capsule (01 = boss defeated; 02 = prison opened)
v_trackpos:		ds.w	1		; position tracking reference number
v_trackbyte = v_trackpos+1			; low byte for position tracking
f_lockscreen:		ds.b	1		; flag set to lock screen during bosses
			ds.b	$13		; unused
v_gfxbigring:		ds.w	1		; settings for giant ring graphics loading
f_conveyrev:		ds.b	1		; flag set to reverse conveyor belts in LZ/SBZ
v_obj63:		ds.b	6		; object 63 (LZ/SBZ platforms) variables
f_wtunnelmode:		ds.b	1		; LZ water tunnel mode
f_playerctrl:		ds.b	1		; Player control override flags (object ineraction, control enable)
f_wtunnelallow:		ds.b	1		; LZ water tunnels (00 = enabled; 01 = disabled)
f_slidemode:		ds.b	1		; LZ water slide mode
v_obj6B:		ds.b	1		; object 6B (SBZ stomper) variable
f_lockctrl:		ds.b	1		; flag set to lock controls during ending sequence
f_bigring:		ds.b	1		; flag set when Sonic collects the giant ring
f_obj56:		ds.b	1		; object 56 flag
			ds.b	1		; unused
v_itembonus:		ds.w	1		; item bonus from broken enemies, blocks etc.
v_timebonus:		ds.w	1		; time bonus at the end of an act
v_ringbonus:		ds.w	1		; ring bonus at the end of an act
f_endactbonus:		ds.b	1		; time/ring bonus update flag at the end of an act
			ds.b	1		; unused
v_lz_deform:		ds.w	1		; LZ deformation offset, in units of $80
			ds.b	4		; unused
f_switch:		ds.b	$10		; flags set when Sonic stands on a switch
v_scroll_block_1_size:	ds.w	1
Anim_Counters:		ds.b	$10
v_levelvariables_end:

v_spritetablebuffer:	ds.b	$280		; sprite table
v_spritetablebuffer_end:
v_palette_water_fading:	ds.b	$80		; duplicate underwater palette, used for transitions
v_palette_water_fading_end:
v_palette_water:	ds.b	$80		; main underwater palette
v_palette_water_end:
v_palette:		ds.b	$80		; main palette
v_palette_end:
Normal_palette_line3: = v_palette+$40
v_palette_fading:	ds.b	$80		; duplicate palette, used for transitions
v_palette_fading_end:
Target_palette_line3: = v_palette_fading+$40
			ds.b	$C0		; unused

			ds.b	$140		; stack
v_systemstack:
v_crossresetram:				; RAM beyond this point is only cleared on a cold-boot
			ds.b	2		; unused
f_restart:		ds.w	1		; restart level flag
v_framecount:		ds.w	1		; frame counter (adds 1 every frame)
v_framebyte = v_framecount+1			; low byte for frame counter
v_debugitem:		ds.b	1		; debug item currently selected (NOT the object number of the item)
			ds.b	1		; unused
v_debuguse:		ds.w	1		; debug mode use & routine counter (when Sonic is a ring/item)
v_debugxspeed:		ds.b	1		; debug mode - horizontal speed
v_debugyspeed:		ds.b	1		; debug mode - vertical speed
v_saved_music:		ds.b	1		; saved music
			ds.b	3		; unused
v_zone:			ds.b	1		; current zone number
v_act:			ds.b	1		; current act number
v_lives:		ds.b	1		; number of lives
			ds.b	1		; unused
v_air:			ds.w	1		; air remaining while underwater
			ds.b	4		; unused
f_timeover:		ds.b	1		; time over flag
v_lifecount:		ds.b	1		; lives counter value (for actual number, see "v_lives")
f_lifecount:		ds.b	1		; lives counter update flag
f_ringcount:		ds.b	1		; ring counter update flag
f_timecount:		ds.b	1		; time counter update flag
f_scorecount:		ds.b	1		; score counter update flag
v_rings:		ds.w	1		; rings
v_ringbyte = v_rings+1				; low byte for rings
v_time:			ds.l	1		; time
v_timemin = v_time+1				; time - minutes
v_timesec = v_time+2				; time - seconds
v_timecent = v_time+3				; time - centiseconds
v_score:		ds.l	1		; score
			ds.b	2		; unused
v_shield:		ds.b	1		; shield status (00 = no; 01 = yes)
v_invinc:		ds.b	1		; invinciblity status (00 = no; 01 = yes)
v_shoes:		ds.b	1		; speed shoes status (00 = no; 01 = yes)
			ds.b	1		; unused

v_lastlamp:		ds.b	2		; number of the last lamppost you hit
v_lamp_xpos:		ds.w	1		; x-axis for Sonic to respawn at lamppost
v_lamp_ypos:		ds.w	1		; y-axis for Sonic to respawn at lamppost
v_lamp_rings:		ds.w	1		; rings stored at lamppost
v_lamp_time:		ds.l	1		; time stored at lamppost
v_lamp_dle:		ds.b	1		; dynamic level event routine counter at lamppost
			ds.b	1		; unused
v_lamp_limitbtm:	ds.w	1		; level bottom boundary at lamppost
v_lamp_scrx:		ds.w	1		; x-axis screen at lamppost
v_lamp_scry:		ds.w	1		; y-axis screen at lamppost
v_lamp_bgscrx:		ds.w	1		; x-axis BG screen at lamppost
v_lamp_bgscry:		ds.w	1		; y-axis BG screen at lamppost
v_lamp_bg2scrx:		ds.w	1		; x-axis BG2 screen at lamppost
v_lamp_bg2scry:		ds.w	1		; y-axis BG2 screen at lamppost
v_lamp_bg3scrx:		ds.w	1		; x-axis BG3 screen at lamppost
v_lamp_bg3scry:		ds.w	1		; y-axis BG3 screen at lamppost
v_lamp_wtrpos:		ds.w	1		; water position at lamppost
v_lamp_wtrrout:		ds.b	1		; water routine at lamppost
v_lamp_wtrstat:		ds.b	1		; water state at lamppost
v_lamp_lives:		ds.b	1		; lives counter at lamppost
			ds.b	9		; unused
v_oscillate:		ds.w	1		; oscillation bitfield
v_timingandscreenvariables:
v_timingvariables:
			ds.b	$40		; values which oscillate - for swinging platforms, et al
			ds.b	$20		; unused
v_ani0_time:		ds.b	1		; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:		ds.b	1		; synchronised sprite animation 0 - current frame
v_ani1_time:		ds.b	1		; synchronised sprite animation 1 - time until next frame
v_ani1_frame:		ds.b	1		; synchronised sprite animation 1 - current frame
v_ani2_time:		ds.b	1		; synchronised sprite animation 2 - time until next frame
v_ani2_frame:		ds.b	1		; synchronised sprite animation 2 - current frame
v_ani2_buf:		ds.w	1		; synchronised sprite animation 3 - info buffer
			ds.b	$28		; unused
v_limittopdb:		ds.w	1		; level upper boundary, buffered for debug mode
v_limitbtmdb:		ds.w	1		; level bottom boundary, buffered for debug mode
HUD_scroll_flag:	ds.b	1		; enable/disable hud via scrolling (1 byte)
			ds.b	1		; unused
HUD_scroll_vertical:	ds.w	1		; vertical movement buffer for hud (2 bytes)
			ds.b	8		; unused
v_timingvariables_end:

			ds.b	$10		; unused
v_screenposx_dup:	ds.l	1		; screen position x (duplicate)
v_screenposy_dup:	ds.l	1		; screen position y (duplicate)
v_bgscreenposx_dup:	ds.l	1		; background screen position x (duplicate)
v_bgscreenposy_dup:	ds.l	1		; background screen position y (duplicate)
v_bg2screenposx_dup:	ds.l	1
v_bg2screenposy_dup:	ds.l	1
v_bg3screenposx_dup:	ds.l	1
v_bg3screenposy_dup:	ds.l	1
v_fg_scroll_flags_dup:	ds.w	1
v_bg1_scroll_flags_dup:	ds.w	1
v_bg2_scroll_flags_dup:	ds.w	1
v_bg3_scroll_flags_dup:	ds.w	1
			ds.b	$48		; unused
v_timingandscreenvariables_end:

v_levseldelay:		ds.b	1		; level select - time until change when up/down is held
			ds.b	1		; unused
v_levselitem:		ds.w	1		; level select - item selected
v_levselsound:		ds.w	1		; level select - sound selected
			ds.b	$3A		; unused
v_scorelife:		ds.l	1		; points required for an extra life (JP1 only)
v_colladdr1:		ds.l	1		; (4 bytes)
v_colladdr2:		ds.l	1		; (4 bytes)
v_top_solid_bit:	ds.b	1		; (1 byte)
v_lrb_solid_bit:	ds.b	1		; (1 byte)
			ds.b	$12		; unused
f_levselcheat:		ds.b	1		; level select cheat flag
f_slomocheat:		ds.b	1		; slow motion & frame advance cheat flag
f_debugcheat:		ds.b	1		; debug mode cheat flag
f_creditscheat:		ds.b	1		; hidden credits & press start cheat flag
v_title_dcount:		ds.w	1		; number of times the d-pad is pressed on title screen
v_title_ccount:		ds.w	1		; number of times C is pressed on title screen
			ds.b	7		; unused
f_hud:			ds.b	1		; flag to enable/disable HUD
f_demo:			ds.w	1		; demo mode flag (0 = no; 1 = yes; $8001 = ending)
v_demonum:		ds.w	1		; demo level number (not the same as the level number)
			ds.b	4		; unused
v_megadrive:		ds.b	1		; Megadrive machine type
			ds.b	1		; unused
f_debugmode:		ds.w	1		; debug mode flag
v_init:			ds.b	1		; 'init' text string
			ds.b	2		; unused
f_palmode:		ds.b	1		; pal flag
v_ram_end:
    if * > 0	; Don't declare more space than the RAM can contain!
	fatal "The RAM variable declarations are too large by $\{*} bytes."
    endif
	dephase

	!org 0
