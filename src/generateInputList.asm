SECTION "input generator", ROM0



generateInputList::
  ld a, [wInputLength]
  ld c, a

  ld de, wInputList
  ld a, [wLevel]
  cp a, 4
  jr nc, .generationLoopHard
.generationLoopEasy:
  push bc
  call rand
  pop bc

  ld b, a
  swap a
  add a, b
  adc a, 1
  swap a
  and %00000011

  ld b, a
  ld a, 1
  call LoopShiftLeft

  ld [de], a
  inc de
  dec c
  jr nz, .generationLoopEasy
  jr .end
.generationLoopHard:
  push bc
  call rand
  pop bc
  ;apparently this algorithm is the same as A%15, i still don't understand exactly how it works, but it's fine
  ld b, a
  swap a
  add a, b
  adc a, 1
  swap a
  and %00001111

  inc a

  ld [de], a
  inc de
  dec c
  jr nz, .generationLoopHard
.end:
  xor a, a
  ld [wIsGeneratingNewInput], a
