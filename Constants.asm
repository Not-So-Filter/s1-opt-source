; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

Size_of_DAC_samples =		$2000
Size_of_SEGA_sound =		$6000
Size_of_Snd_driver_guess =	$A77 ; approximate post-compressed size of the Z80 sound driver

; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004
vdp_counter:		equ $C00008

psg_input:		equ $C00011

; Z80 addresses
z80_ram:		equ $A00000	; start of Z80 RAM
z80_ram_end:		equ $A02000	; end of non-reserved Z80 RAM
z80_version:		equ $A10001
z80_port_1_data:	equ $A10003
z80_port_1_control:	equ $A10009
z80_port_2_control:	equ $A1000A
z80_expansion_control:	equ $A1000C
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200
ym2612_a0:		equ $A04000
ym2612_d0:		equ $A04001
ym2612_a1:		equ $A04002
ym2612_d1:		equ $A04003

sram_port:		equ $A130F1

security_addr:		equ $A14000

; VRAM data
vram_fg:	equ $C000	; foreground namespace
vram_bg:	equ $E000	; background namespace
vram_sprites:	equ $F800	; sprite table
vram_hscroll:	equ $FC00	; horizontal scroll table
tile_size:	equ 8*8/2
plane_size_64x32:	equ 64*32*2

; Game modes
id_Sega:	equ ptr_GM_Sega-GameModeArray	; $00
id_Title:	equ ptr_GM_Title-GameModeArray	; $04
id_Demo:	equ ptr_GM_Demo-GameModeArray	; $08
id_Level:	equ ptr_GM_Level-GameModeArray	; $0C
id_Menu:	equ ptr_GM_Menu-GameModeArray	; $10

; Vertical interrupt modes
id_VB_00:	equ ptr_VB_00-VBla_Index	; $00
id_VB_02:	equ ptr_VB_02-VBla_Index	; $02
id_VB_04:	equ ptr_VB_04-VBla_Index	; $04
id_VB_06:	equ ptr_VB_06-VBla_Index	; $06
id_VB_08:	equ ptr_VB_08-VBla_Index	; $08
id_VB_0A:	equ ptr_VB_0A-VBla_Index	; $0A
id_VB_0C:	equ ptr_VB_0C-VBla_Index	; $0C
VintID_Menu:	equ ptr_VB_0E-VBla_Index	; $0E

; Levels
id_GHZ:		equ 0
id_LZ:		equ 1
id_MZ:		equ 2
id_SLZ:		equ 3
id_SYZ:		equ 4
id_SBZ:		equ 5
id_EndZ:	equ 6
id_SS:		equ 7

; Colours
cBlack:		equ $000		; colour black
cWhite:		equ $EEE		; colour white
cBlue:		equ $E00		; colour blue
cGreen:		equ $0E0		; colour green
cRed:		equ $00E		; colour red
cYellow:	equ cGreen+cRed		; colour yellow
cAqua:		equ cGreen+cBlue	; colour aqua
cMagenta:	equ cBlue+cRed		; colour magenta

; Joypad input
btnStart:	equ %10000000 ; Start button	($80)
btnA:		equ %01000000 ; A		($40)
btnC:		equ %00100000 ; C		($20)
btnB:		equ %00010000 ; B		($10)
btnR:		equ %00001000 ; Right		($08)
btnL:		equ %00000100 ; Left		($04)
btnDn:		equ %00000010 ; Down		($02)
btnUp:		equ %00000001 ; Up		($01)
btnDir:		equ %00001111 ; Any direction	($0F)
btnABC:		equ %01110000 ; A, B or C	($70)
bitStart:	equ 7
bitA:		equ 6
bitC:		equ 5
bitB:		equ 4
bitR:		equ 3
bitL:		equ 2
bitDn:		equ 1
bitUp:		equ 0

; Object variables
obj struct DOTS
ID:		ds.l 1	; object ID number
Render:		ds.b 1	; bitfield for x/y flip, display mode
Routine:	ds.b 1	; routine number
ActHigh:	ds.b 1	; action height
ActWid:		ds.b 1	; action width
Priority:	ds.w 1	; sprite stack priority -- 0 is front
Gfx:		ds.w 1	; palette line & VRAM setting (2 bytes)
Map:		ds.l 1	; mappings address (4 bytes)
X:		ds.w 1	; x-axis position (2-4 bytes)
ScreenY:	ds.w 1	; y-axis position for screen-fixed items (2 bytes)
Y:		ds.l 1	; y-axis position (2-4 bytes)
VelX:		ds.w 1	; x-axis velocity (2 bytes)
VelY:		ds.w 1	; y-axis velocity (2 bytes)
Height:		ds.b 1	; height/2
Width:		ds.b 1	; width/2
Inertia:	ds.w 1	; potential speed (2 bytes)
Anim:		ds.b 1	; current animation
PrevAni:	ds.b 1	; previous animation
Frame:		ds.b 1	; current frame displayed
AniFrame:	ds.b 1	; current frame in animation script
TimeFrame:	ds.b 1	; time to next frame
DelayAni:
off_25:		ds.b 1	; time to delay animation
off_26:		ds.b 1
Angle:		ds.b 1	; angle
ColType:	ds.b 1	; collision response type
ColProp:
off_29:		ds.b 1	; collision extra property
Status:
off_2A:		ds.b 1	; orientation or mode
off_2B:		ds.b 1
Subtype:
off_2C:		ds.b 1	; object subtype
off_2D:		ds.b 1
off_2E:		ds.b 1
off_2F:		ds.b 1
off_30:		ds.b 1
off_31:		ds.b 1
off_32:		ds.b 1
off_33:		ds.b 1
off_34:		ds.b 1
off_35:		ds.b 1
off_36:		ds.b 1
off_37:		ds.b 1
off_38:		ds.b 1
off_39:		ds.b 1
off_3A:		ds.b 1
off_3B:		ds.b 1
2ndRout:
off_3C:		ds.b 1	; secondary routine number
off_3D:		ds.b 1
off_3E:		ds.b 1
off_3F:		ds.b 1
off_40:		ds.b 1
off_41:		ds.b 1
off_42:		ds.b 1
off_43:		ds.b 1
off_44:		ds.b 1
off_45:		ds.b 1
off_46:		ds.b 1
off_47:		ds.b 1
RespawnNo:	ds.w 1	; respawn list index number

	endstruct

obID:		equ obj.ID
obRender:	equ obj.Render
obGfx:		equ obj.Gfx
obMap:		equ obj.Map
obX:		equ obj.X
obScreenY:	equ obj.ScreenY
obY:		equ obj.Y
obVelX:		equ obj.VelX
obVelY:		equ obj.VelY
obActHigh:	equ obj.ActHigh
obActWid:	equ obj.ActWid
obHeight:	equ obj.Height
obWidth:	equ obj.Width
obPriority:	equ obj.Priority
obFrame:	equ obj.Frame
obAniFrame:	equ obj.AniFrame
obAnim:		equ obj.Anim
obPrevAni:	equ obj.PrevAni
obTimeFrame:	equ obj.TimeFrame
obDelayAni:	equ obj.DelayAni
obInertia:	equ obj.Inertia
obColType:	equ obj.ColType
obColProp:	equ obj.ColProp
obStatus:	equ obj.Status
obRespawnNo:	equ obj.RespawnNo
obRoutine:	equ obj.Routine
ob2ndRout:	equ obj.2ndRout
obAngle:	equ obj.Angle
obSubtype:	equ obj.Subtype
obSolid:	equ obj.2ndRout ; solid status flag

; ---------------------------------------------------------------------------
; when childsprites are activated (i.e. bit #6 of render_flags set)
next_subspr:		equ 6
mainspr_width:		equ obWidth
mainspr_height:		equ obHeight
mainspr_mapframe:	equ obFrame
mainspr_childsprites: 	equ $16	; amount of child sprites
subspr_data:		equ $18
sub2_x_pos:		equ $18	;x_vel
sub2_y_pos:		equ $1A	;y_vel
sub2_mapframe:		equ $1D
sub3_x_pos:		equ $1E	;y_radius
sub3_y_pos:		equ $20	;anim
sub3_mapframe:		equ $23	;anim_frame
sub4_x_pos:		equ $24	;anim_frame_timer
sub4_y_pos:		equ $26	;angle
sub4_mapframe:		equ $29	;collision_property
sub5_x_pos:		equ $2A	;status
sub5_y_pos:		equ $2C	;subtype
sub5_mapframe:		equ $2F
sub6_x_pos:		equ $30
sub6_y_pos:		equ $32
sub6_mapframe:		equ $35
sub7_x_pos:		equ $36
sub7_y_pos:		equ $38
sub7_mapframe:		equ $3B
sub8_x_pos:		equ $3C
sub8_y_pos:		equ $3E
sub8_mapframe:		equ $41
sub9_x_pos:		equ $42
sub9_y_pos:		equ $44
sub9_mapframe:		equ $47

; Object variables used by Sonic
flashtime:	equ objoff_30	; time between flashes after getting hit
invtime:	equ objoff_32	; time left for invincibility
shoetime:	equ objoff_34	; time left for speed shoes
stick_to_convex:equ objoff_38
jumpflag:	equ objoff_3C
standonobject:	equ objoff_42	; object Sonic stands on

; Miscellaneous object scratch-RAM
objoff_25:	equ obj.off_25
objoff_26:	equ obj.off_26
objoff_29:	equ obj.off_29
objoff_2A:	equ obj.off_2A
objoff_2B:	equ obj.off_2B
objoff_2C:	equ obj.off_2C
objoff_2E:	equ obj.off_2E
objoff_2F:	equ obj.off_2F
objoff_30:	equ obj.off_30
objoff_31:	equ obj.off_31
objoff_32:	equ obj.off_32
objoff_33:	equ obj.off_33
objoff_34:	equ obj.off_34
objoff_35:	equ obj.off_35
objoff_36:	equ obj.off_36
objoff_37:	equ obj.off_37
objoff_38:	equ obj.off_38
objoff_39:	equ obj.off_39
objoff_3A:	equ obj.off_3A
objoff_3B:	equ obj.off_3B
objoff_3C:	equ obj.off_3C
objoff_3D:	equ obj.off_3D
objoff_3E:	equ obj.off_3E
objoff_3F:	equ obj.off_3F
objoff_40:	equ obj.off_40
objoff_41:	equ obj.off_41
objoff_42:	equ obj.off_42
objoff_43:	equ obj.off_43
objoff_44:	equ obj.off_44
objoff_45:	equ obj.off_45
objoff_46:	equ obj.off_46
objoff_47:	equ obj.off_47

object_size_bits:	equ 6
object_size:	equ obj.len

; Animation flags
afEnd:		equ $FF	; return to beginning of animation
afBack:		equ $FE	; go back (specified number) bytes
afChange:	equ $FD	; run specified animation
afRoutine:	equ $FC	; increment routine counter
afReset:	equ $FB	; reset animation and 2nd object routine counter
af2ndRoutine:	equ $FA	; increment 2nd routine counter

MusID_Pause =		$7F			; FE
MusID_Unpause =		$80			; FF

; Music IDs
offset :=	MusicIndex
ptrsize :=	2
idstart :=	$01

; Background music
bgm__First	= idstart
bgm_GHZ		= id(ptr_mus81)
bgm_LZ		= id(ptr_mus82)
bgm_MZ		= id(ptr_mus83)
bgm_SLZ		= id(ptr_mus84)
bgm_SYZ		= id(ptr_mus85)
bgm_SBZ		= id(ptr_mus86)
bgm_Invincible	= id(ptr_mus87)
bgm_ExtraLife	= id(ptr_mus88)
bgm_SS		= id(ptr_mus89)
bgm_Title	= id(ptr_mus8A)
bgm_Ending	= id(ptr_mus8B)
bgm_Boss	= id(ptr_mus8C)
bgm_FZ		= id(ptr_mus8D)
bgm_GotThrough	= id(ptr_mus8E)
bgm_GameOver	= id(ptr_mus8F)
bgm_Continue	= id(ptr_mus90)
bgm_Credits	= id(ptr_mus91)
bgm_Drowning	= id(ptr_mus92)
bgm_Emerald	= id(ptr_mus93)
bgm__Last	= id(ptr_musend)

; Sound IDs
offset :=	SoundIndex
ptrsize :=	2
idstart :=	bgm__Last

; Sound effects
sfx__First	= idstart
sfx_Jump	= id(ptr_sndA0)
sfx_Lamppost	= id(ptr_sndA1)
sfx_A2		= id(ptr_sndA2)
sfx_Death	= id(ptr_sndA3)
sfx_Skid	= id(ptr_sndA4)
sfx_A5		= id(ptr_sndA5)
sfx_HitSpikes	= id(ptr_sndA6)
sfx_Push	= id(ptr_sndA7)
sfx_SSGoal	= id(ptr_sndA8)
sfx_SSItem	= id(ptr_sndA9)
sfx_Splash	= id(ptr_sndAA)
sfx_AB		= id(ptr_sndAB)
sfx_HitBoss	= id(ptr_sndAC)
sfx_Bubble	= id(ptr_sndAD)
sfx_Fireball	= id(ptr_sndAE)
sfx_Shield	= id(ptr_sndAF)
sfx_Saw		= id(ptr_sndB0)
sfx_Electric	= id(ptr_sndB1)
sfx_Drown	= id(ptr_sndB2)
sfx_Flamethrower:= id(ptr_sndB3)
sfx_Bumper	= id(ptr_sndB4)
sfx_Ring	= id(ptr_sndB5)
sfx_SpikesMove	= id(ptr_sndB6)
sfx_Rumbling	= id(ptr_sndB7)
sfx_B8		= id(ptr_sndB8)
sfx_Collapse	= id(ptr_sndB9)
sfx_SSGlass	= id(ptr_sndBA)
sfx_Door	= id(ptr_sndBB)
sfx_Teleport	= id(ptr_sndBC)
sfx_ChainStomp	= id(ptr_sndBD)
sfx_Roll	= id(ptr_sndBE)
sfx_Continue	= id(ptr_sndBF)
sfx_Basaran	= id(ptr_sndC0)
sfx_BreakItem	= id(ptr_sndC1)
sfx_Warning	= id(ptr_sndC2)
sfx_GiantRing	= id(ptr_sndC3)
sfx_Bomb	= id(ptr_sndC4)
sfx_Cash	= id(ptr_sndC5)
sfx_RingLoss	= id(ptr_sndC6)
sfx_ChainRise	= id(ptr_sndC7)
sfx_Burning	= id(ptr_sndC8)
sfx_Bonus	= id(ptr_sndC9)
sfx_EnterSS	= id(ptr_sndCA)
sfx_WallSmash	= id(ptr_sndCB)
sfx_Spring	= id(ptr_sndCC)
sfx_Switch	= id(ptr_sndCD)
sfx_RingLeft	= id(ptr_sndCE)
sfx_Signpost	= id(ptr_sndCF)
sfx_Waterfall	= id(ptr_sndD0)
sfx__Last	= id(ptr_sndend)

offset :=	zCommandIndex
ptrsize :=	4
idstart :=	sfx__Last

flg__First	= idstart
bgm_Fade	= id(CmdPtr_FadeOut)
sfx_Sega	= id(CmdPtr_SegaSound)
bgm_Speedup	= id(CmdPtr_SpeedUp)
bgm_Slowdown	= id(CmdPtr_SlowDown)
bgm_Stop	= id(CmdPtr_Stop)
flg__Last	= id(CmdPtr__End)

; Sonic frame IDs

	phase 0
fr_Null:	ds.b 1 ;  0
fr_Stand:	ds.b 1 ;  1
fr_Wait1:	ds.b 1 ;  2
fr_Wait2:	ds.b 1 ;  3
fr_Wait3:	ds.b 1 ;  4
fr_LookUp:	ds.b 1 ;  5
fr_Walk11:	ds.b 1 ;  6
fr_Walk12:	ds.b 1 ;  7
fr_Walk13:	ds.b 1 ;  8
fr_Walk14:	ds.b 1 ;  9
fr_Walk15:	ds.b 1 ;  $A
fr_Walk16:	ds.b 1 ;  $B
fr_Walk21:	ds.b 1 ;  $C
fr_Walk22:	ds.b 1 ;  $D
fr_Walk23:	ds.b 1 ;  $E
fr_Walk24:	ds.b 1 ;  $F
fr_Walk25:	ds.b 1 ;  $10
fr_Walk26:	ds.b 1 ;  $11
fr_Walk31:	ds.b 1 ;  $12
fr_Walk32:	ds.b 1 ;  $13
fr_Walk33:	ds.b 1 ;  $14
fr_Walk34:	ds.b 1 ;  $15
fr_Walk35:	ds.b 1 ;  $16
fr_Walk36:	ds.b 1 ;  $17
fr_Walk41:	ds.b 1 ;  $18
fr_Walk42:	ds.b 1 ;  $19
fr_Walk43:	ds.b 1 ;  $1A
fr_Walk44:	ds.b 1 ;  $1B
fr_Walk45:	ds.b 1 ;  $1C
fr_Walk46:	ds.b 1 ;  $1D
fr_Run11:	ds.b 1 ;  $1E
fr_Run12:	ds.b 1 ;  $1F
fr_Run13:	ds.b 1 ;  $20
fr_Run14:	ds.b 1 ;  $21
fr_Run21:	ds.b 1 ;  $22
fr_Run22:	ds.b 1 ;  $23
fr_Run23:	ds.b 1 ;  $24
fr_Run24:	ds.b 1 ;  $25
fr_Run31:	ds.b 1 ;  $26
fr_Run32:	ds.b 1 ;  $27
fr_Run33:	ds.b 1 ;  $28
fr_Run34:	ds.b 1 ;  $29
fr_Run41:	ds.b 1 ;  $2A
fr_Run42:	ds.b 1 ;  $2B
fr_Run43:	ds.b 1 ;  $2C
fr_Run44:	ds.b 1 ;  $2D
fr_Roll1:	ds.b 1 ;  $2E
fr_Roll2:	ds.b 1 ;  $2F
fr_Roll3:	ds.b 1 ;  $30
fr_Roll4:	ds.b 1 ;  $31
fr_Roll5:	ds.b 1 ;  $32
fr_Stop1:	ds.b 1 ;  $37
fr_Stop2:	ds.b 1 ;  $38
fr_Duck:	ds.b 1 ;  $39
fr_Balance1:	ds.b 1 ;  $3A
fr_Balance2:	ds.b 1 ;  $3B
fr_Float1:	ds.b 1 ;  $3C
fr_Float2:	ds.b 1 ;  $3D
fr_Float3:	ds.b 1 ;  $3E
fr_Float4:	ds.b 1 ;  $3F
fr_Spring:	ds.b 1 ;  $40
fr_Hang1:	ds.b 1 ;  $41
fr_Hang2:	ds.b 1 ;  $42
fr_Leap1:	ds.b 1 ;  $43
fr_Leap2:	ds.b 1 ;  $44
fr_Push1:	ds.b 1 ;  $45
fr_Push2:	ds.b 1 ;  $46
fr_Push3:	ds.b 1 ;  $47
fr_Push4:	ds.b 1 ;  $48
fr_Drown:	ds.b 1 ;  $4C
fr_Death:	ds.b 1 ;  $4D
fr_Float5:	ds.b 1 ;  $53
fr_Float6:	ds.b 1 ;  $54
fr_Injury:	ds.b 1 ;  $55
fr_GetAir:	ds.b 1 ;  $56
fr_WaterSlide:	ds.b 1 ;  $57
	dephase
	!org 0

; Boss locations
; The main values are based on where the camera boundaries mainly lie
; The end values are where the camera scrolls towards after defeat
boss_ghz_x:	equ $2960		; Green Hill Zone
boss_ghz_y:	equ $300
boss_ghz_end:	equ boss_ghz_x+$160

boss_lz_x:	equ $1DE0		; Labyrinth Zone
boss_lz_y:	equ $C0
boss_lz_end:	equ boss_lz_x+$250

boss_mz_x:	equ $1800		; Marble Zone
boss_mz_y:	equ $210
boss_mz_end:	equ boss_mz_x+$160

boss_slz_x:	equ $2000		; Star Light Zone
boss_slz_y:	equ $210
boss_slz_end:	equ boss_slz_x+$160

boss_syz_x:	equ $2C00		; Spring Yard Zone
boss_syz_y:	equ $4CC
boss_syz_end:	equ boss_syz_x+$140

boss_sbz2_x:	equ $2050		; Scrap Brain Zone Act 2 Cutscene
boss_sbz2_y:	equ $510

boss_fz_x:	equ $2450		; Final Zone
boss_fz_y:	equ $510
boss_fz_end:	equ boss_fz_x+$2B0

palette_line_0:	equ (0<<13)
palette_line_1:	equ (1<<13)
palette_line_2:	equ (2<<13)
palette_line_3:	equ (3<<13)

; Other sizes
palette_line_size: equ	$10*2	; 16 word entries

; ---------------------------------------------------------------------------
; VRAM and tile art base addresses.
; VRAM Reserved regions.
VRAM_Plane_A_Name_Table:	equ $C000	; Extends until $CFFF
VRAM_Plane_B_Name_Table:	equ $E000	; Extends until $EFFF

; VRAM Reserved regions, menu screen.
VRAM_Menu_Plane_A_Name_Table:	equ $C000	; Extends until $CFFF
VRAM_Menu_Plane_B_Name_Table:	equ $E000	; Extends until $EFFF
VRAM_Menu_Plane_Table_Size:	equ $1000	; 64 cells x 32 cells x 2 bytes per cell

; Tile VRAM Locations
ArtTile_VRAM_Start:		equ $000

; Common to 1p and 2p menus.
ArtTile_ArtNem_FontStuff:	equ $010

; Menu background.
ArtTile_ArtNem_MenuBox:		equ $070

; Level select icons.
ArtTile_ArtNem_LevelSelectPics:	equ $090

; Shared
ArtTile_GHZ_MZ_Swing:		equ $380
ArtTile_MZ_SYZ_Caterkiller:	equ $4FF
ArtTile_GHZ_SLZ_Smashable_Wall:	equ $50F

; Green Hill Zone
ArtTile_GHZ_Flower_4:		equ ArtTile_Level+$340
ArtTile_GHZ_Edge_Wall:		equ $34C
ArtTile_GHZ_Flower_Stalk:	equ ArtTile_Level+$358
ArtTile_GHZ_Big_Flower_1:	equ ArtTile_Level+$35C
ArtTile_GHZ_Small_Flower:	equ ArtTile_Level+$36C
ArtTile_GHZ_Waterfall:		equ ArtTile_Level+$378
ArtTile_GHZ_Flower_3:		equ ArtTile_Level+$380
ArtTile_GHZ_Bridge:		equ $38E
ArtTile_GHZ_Big_Flower_2:	equ ArtTile_Level+$390
ArtTile_GHZ_Spike_Pole:		equ $398
ArtTile_GHZ_Giant_Ball:		equ $3AA
ArtTile_GHZ_Purple_Rock:	equ $3D0

; Marble Zone
ArtTile_MZ_Block:		equ $2B8
ArtTile_MZ_Animated_Magma:	equ ArtTile_Level+$2D2
ArtTile_MZ_Animated_Lava:	equ ArtTile_Level+$2E2
ArtTile_MZ_Torch:		equ ArtTile_Level+$2F2
ArtTile_MZ_Spike_Stomper:	equ $300
ArtTile_MZ_Fireball:		equ $345
ArtTile_MZ_Glass_Pillar:	equ $38E
ArtTile_MZ_Lava:		equ $3A8

; Spring Yard Zone
ArtTile_SYZ_Bumper:		equ $380
ArtTile_SYZ_Big_Spikeball:	equ $396
ArtTile_SYZ_Spikeball_Chain:	equ $3BA

; Labyrinth Zone
ArtTile_LZ_Block_1:		equ $1E0
ArtTile_LZ_Block_2:		equ $1F0
ArtTile_LZ_Splash:		equ $259
ArtTile_LZ_Gargoyle:		equ $2E9
ArtTile_LZ_Water_Surface:	equ $300
ArtTile_LZ_Spikeball_Chain:	equ $310
ArtTile_LZ_Flapping_Door:	equ $328
ArtTile_LZ_Bubbles:		equ $348
ArtTile_LZ_Moving_Block:	equ $3BC
ArtTile_LZ_Door:		equ $3C4
ArtTile_LZ_Harpoon:		equ $3CC
ArtTile_LZ_Pole:		equ $3DE
ArtTile_LZ_Push_Block:		equ $3DE
ArtTile_LZ_Blocks:		equ $3E6
ArtTile_LZ_Conveyor_Belt:	equ $3F6
ArtTile_LZ_Sonic_Drowning:	equ $440
ArtTile_LZ_Rising_Platform:	equ ArtTile_LZ_Blocks+$69
ArtTile_LZ_Orbinaut:		equ $467
ArtTile_LZ_Cork:		equ ArtTile_LZ_Blocks+$11A

; Star Light Zone
ArtTile_SLZ_Seesaw:		equ $374
ArtTile_SLZ_Fan:		equ $3A0
ArtTile_SLZ_Pylon:		equ $3CC
ArtTile_SLZ_Swing:		equ $3DC
ArtTile_SLZ_Orbinaut:		equ $429
ArtTile_SLZ_Fireball:		equ $480
ArtTile_SLZ_Fireball_Launcher:	equ $4D8
ArtTile_SLZ_Collapsing_Floor:	equ $4E0
ArtTile_SLZ_Spikeball:		equ $4F0

; Scrap Brain Zone
ArtTile_SBZ_Caterkiller:	equ $2B0
ArtTile_SBZ_Moving_Block_Short:	equ $2C0
ArtTile_SBZ_Door:		equ $2E8
ArtTile_SBZ_Girder:		equ $2F0
ArtTile_SBZ_Disc:		equ $344
ArtTile_SBZ_Junction:		equ $348
ArtTile_SBZ_Swing:		equ $391
ArtTile_SBZ_Saw:		equ $3B5
ArtTile_SBZ_Flamethrower:	equ $3D9
ArtTile_SBZ_Collapsing_Floor:	equ $3F5
ArtTile_SBZ_Orbinaut:		equ $429
ArtTile_SBZ_Smoke_Puff_1:	equ ArtTile_Level+$448
ArtTile_SBZ_Smoke_Puff_2:	equ ArtTile_Level+$454
ArtTile_SBZ_Moving_Block_Long:	equ $460
ArtTile_SBZ_Horizontal_Door:	equ $46F
ArtTile_SBZ_Electric_Orb:	equ $47E
ArtTile_SBZ_Trap_Door:		equ $492
ArtTile_SBZ_Vanishing_Block:	equ $4C3
ArtTile_SBZ_Spinning_Platform:	equ $4DF

; Final Zone
ArtTile_FZ_Boss:		equ $300
ArtTile_FZ_Eggman_Fleeing:	equ $3A0
ArtTile_FZ_Eggman_No_Vehicle:	equ $470

; General Level Art
ArtTile_Level:			equ $000
ArtTile_Ball_Hog:		equ $302
ArtTile_Bomb:			equ $400
ArtTile_Crabmeat:		equ $400
ArtTile_Missile_Disolve:	equ $41C ; Unused
ArtTile_Buzz_Bomber:		equ $444
ArtTile_Chopper:		equ $47B
ArtTile_Yadrin:			equ $47B
ArtTile_Jaws:			equ $486
ArtTile_Newtron:		equ $49B
ArtTile_Burrobot:		equ $4A6
ArtTile_Basaran:		equ $4B8
ArtTile_Roller:			equ $4B8
ArtTile_Moto_Bug:		equ $4F0
ArtTile_Button:			equ $50F
ArtTile_Spikes:			equ $51B
ArtTile_Spring_Horizontal:	equ $523
ArtTile_Spring_Vertical:	equ $533
ArtTile_Shield:			equ $541
ArtTile_Invincibility:		equ $55C
ArtTile_Game_Over:		equ $55E
ArtTile_Title_Card:		equ $580
ArtTile_Animal_1:		equ $580
ArtTile_Animal_2:		equ $592
ArtTile_Explosion:		equ $5A0
ArtTile_Monitor:		equ $680
ArtTile_HUD:			equ $6CA
ArtTile_Sonic:			equ $780
ArtTile_Points:			equ $797
ArtTile_Lamppost:		equ $7A0
ArtTile_Ring:			equ $7B2
ArtTile_Lives_Counter:		equ $7D4

; Eggman
ArtTile_Eggman:			equ $400
ArtTile_Eggman_Weapons:		equ $46C
ArtTile_Eggman_Button:		equ $4A4
ArtTile_Eggman_Spikeball:	equ $518
ArtTile_Eggman_Trap_Floor:	equ $518
ArtTile_Eggman_Exhaust:		equ ArtTile_Eggman+$12A

; End of Level
ArtTile_Giant_Ring:		equ $400
ArtTile_Giant_Ring_Flash:	equ $462
ArtTile_Prison_Capsule:		equ $49D
ArtTile_Hidden_Points:		equ $4B6
ArtTile_Warp:			equ $541
ArtTile_Mini_Sonic:		equ $551
ArtTile_Bonuses:		equ $570
ArtTile_Signpost:		equ $680

; Sega Screen
ArtTile_Sega_Tiles:		equ $000

; Title Screen
ArtTile_Title_Japanese_Text:	equ $000
ArtTile_Title_Foreground:	equ $200
ArtTile_Title_Sonic:		equ $300
ArtTile_Title_Trademark:	equ $510
ArtTile_Level_Select_Font:	equ $680

; Continue Screen
ArtTile_Continue_Sonic:		equ $500
ArtTile_Continue_Number:	equ $6FC

; Ending
ArtTile_Ending_Flowers:		equ $3A0
ArtTile_Ending_Emeralds:	equ $3C5
ArtTile_Ending_Sonic:		equ $3E1
ArtTile_Ending_Eggman:		equ $524
ArtTile_Ending_Rabbit:		equ $553
ArtTile_Ending_Chicken:		equ $565
ArtTile_Ending_Penguin:		equ $573
ArtTile_Ending_Seal:		equ $585
ArtTile_Ending_Pig:		equ $593
ArtTile_Ending_Flicky:		equ $5A5
ArtTile_Ending_Squirrel:	equ $5B3
ArtTile_Ending_STH:		equ $5C5

; Try Again Screen
ArtTile_Try_Again_Emeralds:	equ $3C5
ArtTile_Try_Again_Eggman:	equ $3E1

; Special Stage
ArtTile_SS_Background_Clouds:	equ $000
ArtTile_SS_Background_Fish:	equ $051
ArtTile_SS_Wall:		equ $142
ArtTile_SS_Plane_1:		equ $200
ArtTile_SS_Bumper:		equ $23B
ArtTile_SS_Goal:		equ $251
ArtTile_SS_Up_Down:		equ $263
ArtTile_SS_R_Block:		equ $2F0
ArtTile_SS_Plane_2:		equ $300
ArtTile_SS_Extra_Life:		equ $370
ArtTile_SS_Emerald_Sparkle:	equ $3F0
ArtTile_SS_Plane_3:		equ $400
ArtTile_SS_Red_White_Block:	equ $470
ArtTile_SS_Ghost_Block:		equ $4F0
ArtTile_SS_Plane_4:		equ $500
ArtTile_SS_W_Block:		equ $570
ArtTile_SS_Glass:		equ $5F0
ArtTile_SS_Plane_5:		equ $600
ArtTile_SS_Plane_6:		equ $700
ArtTile_SS_Emerald:		equ $770
ArtTile_SS_Zone_1:		equ $797
ArtTile_SS_Zone_2:		equ $7A0
ArtTile_SS_Zone_3:		equ $7A9
ArtTile_SS_Zone_4:		equ $797
ArtTile_SS_Zone_5:		equ $7A0
ArtTile_SS_Zone_6:		equ $7A9

; Special Stage Results
ArtTile_SS_Results_Emeralds:	equ $541

; Font
ArtTile_Sonic_Team_Font:	equ $0A6
ArtTile_Credits_Font:		equ $5A0

; Error Handler
ArtTile_Error_Handler_Font:	equ $7C0
