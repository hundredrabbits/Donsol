
;; Cart

  include "src/head.asm"

;;

  .org $C000

;; init

__INIT:                        ; 
  include "src/init.asm"

;; jump back to Forever, infinite loop

__MAIN:                        ; 
  include "src/main.asm"
  JMP __MAIN

;; NMI

__NMI:                         ; 
  include "src/nmi.asm"        ; 
  RTI                          ; return from interrupt

;; includes

  include "src/splash.asm"
  include "src/game.asm"
  include "src/input.asm"
  include "src/core.asm"
  include "src/deck.asm"
  include "src/player.asm"
  include "src/room.asm"
  include "src/client.asm"
  include "src/dialog.asm"
  include "src/tests.asm"
  include "src/tables.asm"

;; vectors

  .pad $FFFA
  .dw __NMI
  .dw __INIT
  .dw 0

;; include sprites

  .incbin "src/sprite.chr"