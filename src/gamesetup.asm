  ld a, [isFirstFrame]
  cp a, False
  jr z, .skipFirstScreenLoading

.maingameScreenLoading
  xor a, a
  ld [isFirstFrame], a

  ld a, [FrameCNT]
  ld b, a
  ld a, [FrameCNT+1]
  ld c, a

  call srand

  ld a, $9A
  ld [wVRAMCopyDest], a
  ld a, $04
  ld [wVRAMCopyDest+1], a

  ld a, 12
  ld [wVRAMCopyLen], a
  ld c, a

  xor a, a
  ld [wVRAMCopyType], a
  ld hl, wVRAMCopyBuffer
.zerofillBufferMaingame
  ld [hli], a
  dec c
  jr nz, .zerofillBufferMaingame
  halt
.skipFirstScreenLoading:
