INCLUDE "src/lib/hardware.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;not really useful, but still better than having numbers in code i guess?
LY_VBLANK EQU 148
SIZE_OAM EQU $A0
PALETTE_BLACK_ON_WHITE EQU %00100111

;;;boolean
False EQU $0
True EQU $1

;;;gameStates:
STATE_TITLE EQU $0
STATE_MAINGAME EQU $1
STATE_GAMEOVER EQU $2

;;;VRAMCopyTypes:
VRAMCOPY_RAW EQU $0
VRAMCOPY_POINTER EQU $1

;;gameplay timer maxes:
TIMER_PRESS_MAX EQU 255
TIMER_MULTI_PRESS_MAX EQU 6

;;correct check:
UNKNOWN EQU $FF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION "Vectors", ROM0[$40]
  jp VBlankInterrupt

SECTION "Header", ROM0[$100]
  nop
  jp Start

  NINTENDO_LOGO

  db "PlatformTst" ;11 char game name

  db "PTST" ;short code indicating the game name

  db CART_COMPATIBLE_DMG ;defines if the game is DMG, color compatible, or color only

  dw $0000 ;the editor code

  db CART_INDICATOR_GB ;it indicates the cart isn't SGB compatible

  db CART_ROM ;defines the cartridge board type, here it's suppawsed to be just a rom alone, with no additional WRAM

  db CART_ROM_32KB ;defines the size of the rom, here just 32 KB

  db CART_SRAM_NONE ;defines the amount of SRAM for the cartridge, here none

  db CART_DEST_NON_JAPANESE ;defines the destination of the cartridge

  db $33 ;new license code

  db $00 ;version number

  ds 1 ;header checksum, automatically fixed by rgbfix

  ds 2 ;global checksum, automatically fixed by rgbfix

SECTION "WRAM", WRAM0

;;engine stuff
wIsFirstFrame: db ;C000

wGameState: db ;C001

wJoypad1:: db ;C002

wFrameCNT:: dw ;C003

wVRAMCopyType: db ;C005
wVRAMCopyDest: dw ;C006
wVRAMCopyLen: db ;C008
wVRAMCopyBuffer: ds 100 ;C009 - C06D

;;game variables stuff
wIsGeneratingNewInput:: db ;C06D
wIsInputCorrect:: db ;C06E

wInputLength:: db ;C06F
wMaxInputLength:: db ;C070
wLevel:: db ;C071

wCurrentInputDisplayed:: db ;C072
wCurrentInputToPress:: db ;C073

wTimerDisplay:: dw ;C074
wTimerToPress:: dw ;C076
wTimerMultiPress:: db ;C078

wInputList:: ds 255 ;C079 - C176

SECTION "Home", ROM0[$150]

Start:
  di

  ld a, IEF_VBLANK
  ld [rIE], a

  xor a, a
  ld [wVRAMCopyLen], a

.VBlankWait:
  ld a, [rLY]
  cp a, LY_VBLANK
  jr nz, .VBlankWait

  ld a, LCDCF_OFF
  ld [rLCDC], a

  ld hl, _VRAM
  ld bc, Characters
  ld de, EndCharacters - Characters
.chrLoadLoop:
  ld a, [bc]
  ld [hli], a

  inc bc
  dec de
  ld a, d
  or e
  jr nz, .chrLoadLoop

  xor a, a
  ld hl, _OAMRAM
  ld b, SIZE_OAM
.OAMResetLoop:
  ld [hli], a
  dec b
  jr nz, .OAMResetLoop

  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_BG8000
  ldh [rLCDC], a

  xor a, a
  ldh [rIF], a
  ld [wFrameCNT], a
  ld [wFrameCNT+1], a
  ld [wGameState], a
  ld [wCurrentInputDisplayed], a
  ld [wTimerDisplay], a
  ld [wTimerDisplay+1], a
  ld [wTimerToPress], a
  ld [wTimerToPress+1], a
  ld [wTimerMultiPress], a
  ld [wIsInputCorrect], a

  ei
  halt
  di

  xor a, a
  ldh [rIF], a

  ei
  halt

  ld a, PALETTE_BLACK_ON_WHITE
  ldh [rOBP0], a

  ld a, True
  ld [wIsFirstFrame], a

TitleScreenLoop:

  INCLUDE "src/titlescreen.asm"

  call ReadJoypad

  ld a, [wGameState]
  cp a, STATE_TITLE
  jr nz, .skipTitleLogic

  ld a, [wJoypad1]
  and a, PADF_START
  jr z, .skipTitleLogic

  ld a, STATE_MAINGAME
  ld [wGameState], a

  ld a, True
  ld [wIsFirstFrame], a

.skipTitleLogic
  halt

  ld a, [wGameState]
  cp a, 1
  jr z, MainGameLoop

  jp TitleScreenLoop

MainGameLoop:

INCLUDE "src/gamesetup.asm"

  ld a, [wIsGeneratingNewInput]
  cp a, 0

  jr z, .skipGeneration

  call generateInputList

.skipGeneration:
  INCLUDE "src/renderInGame.asm"
  call ReadJoypad

  halt
  jp MainGameLoop

VBlankInterrupt:
  push hl
  push bc
  push de
  push af

  ld a, [wVRAMCopyLen] ;grab the size of the buffer being written to VRAM
  cp a, 0
  jr z, .skipCopyBufferLoop ;if it's 0, just skip the whole process of copying the buffer to VRAM

  ld c, a ;else, set up the counter, target and source addresses

  ld hl, wVRAMCopyBuffer

  ld a, [wVRAMCopyType]
  cp a, 0
  jr z, .skipPointerDereferencing

  ld d, [hl]
  inc hl
  ld e, [hl]
  ld h, d
  ld l, e

.skipPointerDereferencing:
  ld a, [wVRAMCopyDest]
  ld d, a
  ld a, [wVRAMCopyDest+1]
  ld e, a

.copyBufferLoop: ;and enter the copy loop
  ld a, [hli]
  ld [de], a
  inc de
  dec c
  jr nz, .copyBufferLoop

  xor a
  ld [wVRAMCopyLen], a
.skipCopyBufferLoop

  ;;;just a framecounter
  ld a, [wFrameCNT]
  ld b, a
  ld a, [wFrameCNT+1]
  ld c, a
  inc bc
  ld a, b
  ld [wFrameCNT], a
  ld a, c
  ld [wFrameCNT+1], a

  ld a, [wTimerToPress]
  ld d, a
  ld a, [wTimerToPress+1]
  or a, d
  jr z, .skipPressTimerLogic

  ld a, [wTimerToPress]
  ld e, a

  dec de

  ld a, e
  ld [wTimerToPress+1], a
  ld a, d
  ld [wTimerToPress], a

  ld a, [wIsInputCorrect]
  cp a, $FF
  jr nz, .skipPressTimerLogic

  ld a, [wJoypad1]
  and a, %00001111
  jr z, .skipPressTimerLogic

  ld a, [wTimerMultiPress]
  dec a
  ld [wTimerMultiPress], a


.skipPressTimerLogic
  ld a, [wTimerDisplay]
  ld b, a
  ld a, [wTimerDisplay+1]
  or a, b
  jr z, .skipDisplayTimerLogic

  ld a, [wTimerDisplay+1]
  ld c, a
  dec bc

  ld a, b
  ld [wTimerDisplay], a
  ld a, c
  ld [wTimerDisplay+1], a

.skipDisplayTimerLogic

  pop af
  pop de
  pop bc
  pop hl
  reti


Characters:
INCBIN "src/assets/background.chr"
INCBIN "src/assets/shared.chr"
INCBIN "src/assets/sprite.chr"
EndCharacters:
