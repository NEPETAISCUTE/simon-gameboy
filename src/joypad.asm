INCLUDE "src/lib/hardware.inc"

SECTION "Joypad", ROM0

ReadJoypad::
  ld a, P1F_GET_DPAD
  ldh [rP1], a

  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]
  cpl
  ld b, a

  ld a, P1F_GET_BTN
  ldh [rP1], a

  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]
  cpl
  swap a

  or a, b
  ld [Joypad1], a
  ret
