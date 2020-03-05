
;; cart

include "src/head.asm"
include "src/setup.asm"
include "src/nmi.asm"
include "src/core.asm"
include "src/client.asm"
include "src/tests.asm"
include "src/tables.asm"
include "src/cards.asm"

;; vectors

  .pad $FFFA
  .dw NMI
  .dw RESET
  .dw 0

;; include sprites

  .incbin "src/sprite.chr"