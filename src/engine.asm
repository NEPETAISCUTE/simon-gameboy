INCLUDE "src/lib/hardware.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;gameStates:
STATE_TITLE EQU $0
STATE_MAINGAME EQU $1
STATE_GAMEOVER EQU $2

;;;VRAMCopyTypes:
VRAMCOPY_RAW EQU $0
VRAMCOPY_POINTER EQU $1

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

  db $00 ;header checksum, automatically fixed by rgbfix

  db $0000 ;global checksum, automatically fixed by rgbfix

SECTION "WRAM", WRAM0
isFirstFrame: db

gameState: db

BGPalette: db

Joypad1:: db

wVRAMCopyType: db
wVRAMCopyDest: dw
wVRAMCopyLen: db
wVRAMCopyBuffer: ds 100
SECTION "Home", ROM0[$150]

Start:
  di

  ld a, IEF_VBLANK
  ld [rIE], a

  xor a, a
  ld [wVRAMCopyLen], a

.VBlankWait:
  ld a, [rLY]
  xor a, 148
  jr nz, .VBlankWait

  ld a, LCDCF_OFF
  ld [rLCDC], a

  ld hl, $8000
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
  ld hl, $FE00
  ld b, $A0
.OAMResetLoop:
  ld [hli], a
  dec b
  jr nz, .OAMResetLoop

  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_BG8000
  ldh [rLCDC], a

  xor a, a
  ldh [rIF], a
  ld [gameState], a

  ei
  halt
  di

  xor a, a
  ldh [rIF], a

  ei
  halt

  ld a, %11100100
  ld [BGPalette], a
  ld a, %00100111
  ldh [rOBP0], a

  ld a, 1
  ld [isFirstFrame], a

InfiniteLoop:

INCLUDE "src/firstscreens.asm"

  call ReadJoypad
  halt
  jp InfiniteLoop



VBlankInterrupt:
  push hl
  push bc
  push de
  push af

  ld a, [wVRAMCopyLen] ;grab the size of the buffer being written to VRAM
  or a, 0
  jr z, .skipCopyBufferLoop ;if it's 0, just skip the whole process of copying the buffer to VRAM

  ld c, a ;else, set up the counter, target and source addresses

  ld hl, wVRAMCopyBuffer

  ld a, [wVRAMCopyType]
  or 0
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
