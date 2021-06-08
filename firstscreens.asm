  ld a, [isFirstFrame]
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


  jr .skipFirstScreenLoading
.maingameScreenLoading

  jr .skipFirstScreenLoading
.skipFirstScreenLoading
