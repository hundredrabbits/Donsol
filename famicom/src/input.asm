
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
  JSR lock@input
@splash:                       ; 
  JSR selectNext@splash
  JSR lock@input
  RTS

;;

left@input:                    ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR selectPrev@game
  JSR lock@input
@splash:                       ; 
  JSR selectPrev@splash
  JSR lock@input
  RTS

;;

a@input:                       ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR select@game
  JSR lock@input
@splash:                       ; 
  JSR select@splash
  JSR lock@input
  RTS

;;

b@input:                       ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR return@game
  JSR lock@input
@splash:                       ; 
  JSR return@splash
  JSR lock@input
  RTS

;;

select@input:                  ; 
  JSR askQuit@game
  JSR lock@input
  RTS

;;

start@input:                   ; 
  JSR askQuit@game
  JSR lock@input
  RTS