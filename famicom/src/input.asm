
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
@game:                         ; 
  LDX cursor@game
  JSR flip@room                ; flip selected card
  JSR lock@input
  RTS
@splash:                       ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  JSR lock@input
  RTS

;;

onB@input:                     ; 
  LDA view@game
  CMP #$00
  BEQ @splash
@game:                         ; 
  JSR run@room
  JSR lock@input
  RTS
@splash:                       ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  JSR lock@input
  RTS

;;

onSELECT@input:                ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR show@splash
  JSR lock@input
  RTS
@splash:                       ; 
  NOP
  RTS

;;

onSTART@input:                 ; 
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