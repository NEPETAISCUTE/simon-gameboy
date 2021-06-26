  ld a, [wIsGeneratingNewInput]
  cp a, 0
  jr nz, .skipDisplay

  ld a, [wCurrentInputDisplayed]
  ld hl, wInputList
  ld e, a
  xor a, a
  ld c, a
  ld d, a
  add hl, de

.waitVRAM
  ldh a, [rSTAT]
  and a, STATF_BUSY
  jr nz, .waitVRAM

  ld a, [hl]
  ld b, a

  ld hl, $9906

  and a, PADF_A
  jr nz, .displayA

.afterDisplayAJump:
  ld a, b
  and a, PADF_B
  jr nz, .displayB

.afterDisplayBJump:
  ld a, b
  and a, PADF_SELECT
  jr nz, .displaySelect

.afterDisplaySelectJump:
  ld a, b
  and a, PADF_START
  jr nz, .displayStart

  jr .skipDisplay

.displayA:


  ld a, $04
  ld [hli], a
  inc hl
  jr .afterDisplayAJump

.displayB:

  ld a, $05
  ld [hli], a
  inc hl
  jr .afterDisplayBJump

.displaySelect:

  ld a, $08
  ld [hli], a
  inc hl
  jr .afterDisplaySelectJump

.displayStart:

  ld a, $17
  ld [hli], a
  inc hl
  jr .skipDisplay

.skipDisplay:
