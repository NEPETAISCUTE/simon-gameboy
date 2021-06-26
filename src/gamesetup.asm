  ld a, [wIsFirstFrame]
  cp a, False
  jr z, .skipFirstScreenLoading

  ld a, True
  ld [wIsGeneratingNewInput], a
  ld [wLevel], a
  ld [wInputLength], a

  ld a, 3
  ld [wMaxInputLength], a

.maingameScreenLoading
  xor a, a
  ld [wIsFirstFrame], a

  ld a, [wFrameCNT]
  ld b, a
  ld a, [wFrameCNT+1]
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
