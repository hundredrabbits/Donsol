
;; main, ends on [JMP __MAIN]

handlejoy:                     ; 
  LDA trigger@input
  CMP #$00
  BEQ @skip
  CMP #$01
  BEQ onRight@input
  CMP #$02
  BEQ onLeft@input
  CMP #$10
  BEQ onStart@input
  CMP #$20
  BEQ onSelect@input
  CMP #$40
  BEQ onB@input
  CMP #$80
  BEQ onA@input
@skip:                         ; 

;; input stuff

doTheRest:                     ; 
  JSR main@splash
  JSR main@game
  JMP __MAIN

;;

onRight@input:                 ; 
  LDA #$00                     ; release trigger
  STA trigger@input
  LDA view@game                ; check view
  CMP #$00
  BEQ @splash
@game:                         ; 
  JSR selectNext@game
  JMP doTheRest
@splash:                       ; 
  JSR selectNext@splash
  JMP doTheRest

;;

onLeft@input:                  ; 
  LDA #$00                     ; release trigger
  STA trigger@input
  LDA view@game                ; check view
  CMP #$00
  BEQ @splash
@game:                         ; 
  JSR selectPrev@game
  JMP doTheRest
@splash:                       ; 
  JSR selectPrev@splash
  JMP doTheRest

;;

onSelect@input:                ; 
  LDA #$00                     ; release trigger
  STA trigger@input
  LDA view@game                ; check view
  CMP #$00
  BEQ @splash
@game:                         ; 
  JSR show@splash
  JMP doTheRest
@splash:                       ; 
  JMP doTheRest

;;

onStart@input:                 ; 
  LDA #$00                     ; release trigger
  STA trigger@input
  JMP doTheRest

;;

onB@input:                     ; 
  LDA #$00                     ; release trigger
  STA trigger@input
  LDA view@game                ; check view
  CMP #$00
  BEQ @splash
@game:                         ; 
  JSR run@player
  JMP doTheRest
@splash:                       ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  JMP doTheRest

;;

onA@input:                     ; 
  LDA #$00                     ; release trigger
  STA trigger@input
  LDA view@game                ; check view
  CMP #$00
  BEQ @splash
@game:                         ; 
  LDX cursor@game
  JSR flipCard@room            ; flip selected card
  JMP doTheRest
@splash:                       ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  JMP doTheRest