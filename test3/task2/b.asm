%include "rw32-2022.inc"

segment .data
  x dd 1.0
  y dd 2.0

section .text

task32:
  enter 0,0

  fld dword [ebp+12]
  push __float32__(6.35)
  fld dword [esp]
  add esp,4
  faddp
  fsqrt

  fldpi
  fld dword [ebp+8]
  fmulp

  fld dword [ebp+12]
  faddp
  fcos

  fmulp

  fld dword [ebp+8]
  push __float32__(4.0)
  fld dword [esp]
  add esp,4
  fdivp

  fld dword [ebp+12]
  faddp

  fabs

  fdivp

  leave
  ret

CMAIN:
  push ebp
  mov ebp,esp
  ;;

  push dword [y]
  push dword [x]
  call task32
  add esp, 8

  ;;
  pop ebp

    ret