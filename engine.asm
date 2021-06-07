INCLUDE "hardware.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
isFirstFrame: ds 1
ScrollX: ds 1
BGPalette: ds 1
BGBuffer: ds 2+1+100
SECTION "Home", ROM0[$150]

Start:
  di

  ld a, IEF_VBLANK
  ld [rIE], a

.VBlankWait:
  ld a, [rLY]
  xor 148
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

  xor a
  ld hl, $FE00
  ld b, $A0
.OAMResetLoop:
  ldh [hli], a
  dec b
  jr nz, .OAMResetLoop

  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_BG8000
  ldh [rLCDC], a

  xor a
  ldh [rIF], a

  ei
  halt
  di

  xor a
  ldh [rIF], a

  ei
  halt

  ld a, %11100100
  ld [BGPalette], a
  ld a, %00100111
  ldh [rOBP0], a

  xor a
  ld [ScrollX], a
  inc a
  ld [isFirstFrame], a

InfiniteLoop:

  halt
  jp InfiniteLoop



VBlankInterrupt:
  push hl
  push bc
  push de
  push af

  ld a, [BGBuffer+2]
  or 0
  jr z, .skipCopyBufferLoop

  ld c, a

  ld a, [BGBuffer]
  ld d, a
  ld a, [BGBuffer+1]
  ld e, a

  ld hl, BGBuffer+3
.copyBufferLoop:
  ld a, [hli]
  ld [de], a
  inc de
  dec c
  jr nz, .copyBufferLoop

  xor a
  ld [BGBuffer+2], a
.skipCopyBufferLoop
  pop af
  pop de
  pop bc
  pop hl
  reti


Characters:
;INCBIN "background.chr"
;INCBIN "shared.chr"
INCBIN "sprite.chr"
EndCharacters:
