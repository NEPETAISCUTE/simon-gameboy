SECTION "maths", ROM0

;;Multiply
;;return in a
;;a is the first number to multiply
;;a is multiplied by b
;;so basically mul is a*b
;;f is trashed, along with a, b and d
Multiply::
  ld d, a
.loop:
  dec b
  jr z, .end

  add a, d
  jr .loop
.end
  ret

;;LoopShiftLeft
;;return in a
;;a is the number to shift
;;a is shifted b times
;;f, a and b are trashed
LoopShiftLeft::
  sla a
  dec b
  jr nz, LoopShiftLeft
  ret
