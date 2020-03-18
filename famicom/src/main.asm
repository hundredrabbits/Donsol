
;; main, ends on [JMP __MAIN]

;; input stuff

handlejoy:                     ; 
  ; read buttons
  LDA timer@input
  CMP #$00
  BNE doTheRest
  ;
  LDA last@input
  CMP #$01
  BEQ onRight@input
  JMP __MAIN

;;

onRight@input:                 ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR selectNext@game
  RTS
@splash:                       ; 
  INC $40
  JSR selectNext@splash
  LDA #$00
  STA last@input
  JMP doTheRest
  RTS

;;

onA@input:                     ; 
  LDA view@game
  CMP #$00
  BEQ @splash
@game:                         ; 
  LDX cursor@game
  JSR flipCard@room            ; flip selected card
  RTS
@splash:                       ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  RTS

;;

onB@input:                     ; 
  LDA view@game
  CMP #$00
  BEQ @splash
@game:                         ; 
  JSR run@player
  RTS
@splash:                       ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  RTS

;;

onSelect@input:                ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR show@splash
  RTS
@splash:                       ; 
  NOP
  RTS

;;

onStart@input:                 ; 
  RTS

;;

onLeft@input:                  ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR selectPrev@game
  RTS
@splash:                       ; 
  JSR selectPrev@splash
  RTS

;;

doTheRest:                     ; 
                               ; 
  JSR main@splash
  JSR main@game