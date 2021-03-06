  ld a, [wIsFirstFrame] ;checks if it's the first frame of that specific game state
  cp a, False
  jp z, .skipFirstScreenLoading

.titleScreenLoading
  xor a, a
  ld [wIsFirstFrame], a

  ld a, $99
  ld [wVRAMCopyDest], a
  ld a, $04
  ld [wVRAMCopyDest+1], a

  ld a, 13
  ld [wVRAMCopyLen], a
  ld c, a

  xor a, a
  ld [wVRAMCopyType], a
  ld hl, wVRAMCopyBuffer
.zerofillBufferTitleScreen
  ld [hli], a
  dec c
  jr nz, .zerofillBufferTitleScreen

  halt


  ld a, $99
  ld [wVRAMCopyDest], a
  ld a, $24
  ld [wVRAMCopyDest+1], a

  ld a, 12
  ld [wVRAMCopyLen], a

  halt

  ld a, PRESS_START_SIZE
  ld [wVRAMCopyLen], a
  ld c, a

  ld a, $9A
  ld [wVRAMCopyDest], a
  ld a, $04
  ld [wVRAMCopyDest+1], a

  ld hl, .pressStartMenu
  ld a, h
  ld [wVRAMCopyBuffer], a
  ld a, l
  ld [wVRAMCopyBuffer+1], a
  ld a, VRAMCOPY_POINTER
  ld [wVRAMCopyType], a

  halt

  jr .skipFirstScreenLoading
PRESS_START_SIZE equ 12
.pressStartMenu:
  db $13, $15, $8, $16, $16, $0, $0, $16, $17, $4, $15, $17
.skipFirstScreenLoading:
