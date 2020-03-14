
;; main

;; read inputs

detectView:                    ; 
  LDA view@game
  CMP #$00
  JSR main@splash
  JSR main@game
  JSR main@room
  JSR main@input