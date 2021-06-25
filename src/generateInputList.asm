SECTION "input generator", ROM0



generateInputList::
  ld a, [wInputLength]
  ld c, a

  ld de, wInputList
.generationLoop:
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
  jr nz, .generationLoop

  xor a, a
  ld [wIsGeneratingNewInput], a
