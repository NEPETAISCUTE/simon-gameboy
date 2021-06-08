  ld a, [isFirstFrame] ;checks if it's the first frame of that specific game state
  or a, 0
  jr z, .skipFirstScreenLoading

  ld a, [gameState]
  or a, 0
  jr z, .titleScreenLoading

  ld a, [gameState]
  xor a, 1
  jr z, .maingameScreenLoading

.gameoverScreenLoading

  jr .skipFirstScreenLoading
.titleScreenLoading
  xor a, a
  ld [isFirstFrame], a

  ld a, $99
  ld [wVRAMCopyDest], a
  ld a, $04
  ld [wVRAMCopyDest+1], a

  ld a, 13
  ld [wVRAMCopyLen], a

  xor a, a
  ld [wVRAMCopyType], a
  ld c, 13
  ld hl, wVRAMCopyBuffer
.zerofillBuffer
  ld [hli], a
  dec c
  jr nz, .zerofillBuffer

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
.maingameScreenLoading

  jr .skipFirstScreenLoading



PRESS_START_SIZE equ 12
.pressStartMenu:
  db $13, $15, $8, $16, $16, $0, $0, $16, $17, $4, $15, $17
.skipFirstScreenLoading:
