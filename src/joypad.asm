INCLUDE "src/lib/hardware.inc"

JOYPADMASK EQU %00001111

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
  and a, JOYPADMASK
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
  and a, JOYPADMASK
  swap a

  or a, b
  ld [Joypad1], a

  ld a, P1F_GET_NONE
  ld [rP1], a
  ret
