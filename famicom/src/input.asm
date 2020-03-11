
;;

update@input:                  ; run from nmi
  LDA last@input
  CMP BUTTON_A
  BEQ onA@input
  CMP BUTTON_B
  BEQ onB@input
  CMP BUTTON_SELECT
  BEQ onSELECT@input
  CMP BUTTON_START
  BEQ onSTART@input
  CMP BUTTON_LEFT
  BEQ onLEFT@input
  CMP BUTTON_RIGHT
  BEQ onRIGHT@input
  RTS

;;

onA@input:                     ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR select@game
  JSR lock@input
  RTS
@splash:                       ; 
  JSR select@splash
  JSR lock@input
  RTS

;;

onB@input:                     ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR return@game
  JSR lock@input
  RTS
@splash:                       ; 
  JSR return@splash
  JSR lock@input
  RTS

;;

onSELECT@input:                ; 
  ; TODO: 
  ; JSR askQuit@game
  ; JSR lock@input
  RTS

;;

onSTART@input:                 ; 
  ; TODO: 
  ; JSR askQuit@game
  ; JSR lock@input
  RTS

;;

onLEFT@input:                  ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR selectPrev@game
  JSR lock@input
  RTS
@splash:                       ; 
  JSR selectPrev@splash
  JSR lock@input
  RTS

;;

onRIGHT@input:                 ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR selectNext@game
  JSR lock@input
  RTS
@splash:                       ; 
  JSR selectNext@splash
  JSR lock@input
  RTS

;; lock

lock@input:                    ; 
  LDA #$06
  STA timer@input
  ; release
  LDA #$00
  STA last@input
  RTS