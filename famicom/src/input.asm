
;; lock

lock@input:                    ; 
  LDA #$06
  STA timer@input
  RTS

;;

right@input:                   ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR selectNext@game
@splash:                       ; 
  JSR selectNext@splash
  RTS

;;

left@input:                    ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR selectPrev@game
@splash:                       ; 
  JSR selectPrev@splash
  RTS