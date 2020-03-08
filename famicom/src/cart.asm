
;; constants

PPUCTRL             .equ $2000
PPUMASK             .equ $2001
PPUSTATUS           .equ $2002
SPRADDR             .equ $2003
PPUSCROLL           .equ $2005
PPUADDR             .equ $2006
PPUDATA             .equ $2007
SPRDMA              .equ $4014
SNDCHN              .equ $4015
JOY1                .equ $4016
JOY2                .equ $4017

;; iNES header

  .db  "NES", $1a              ; identification of the iNES header
  .db  1                       ; number of 16KB PRG-ROM pages
  .db  $01                     ; number of 8KB CHR-ROM pages
  .db  $70|%0001               ; mapper 7
  .dsb $09,$00                 ; clear the remaining bytes
  .fillvalue $FF               ; Sets all unused space in rom to value $FF

;; cart

include "src/head.asm"
include "src/setup.asm"
include "src/nmi.asm"
include "src/core.asm"
include "src/client.asm"
include "src/tests.asm"
include "src/tables.asm"

;; vectors

  .pad $FFFA
  .dw NMI
  .dw RESET
  .dw 0

;; include sprites

  .incbin "src/sprite.chr"