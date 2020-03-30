
;; main

incrementSeed:                 ; [skip]
  LDA view@game
  CMP #$00                     ; if is on splash
  BNE @done
  INC seed1@deck               ; increment random seed
@done:                         ; 
  INC seed2@deck

;;

handleJoy:                     ; [skip]
  LDA next@input
  CMP #$00
  BEQ @done
  LDA next@input
  LDX #$00                     ; release
  STX next@input
  CMP BUTTON_RIGHT
  BEQ onRight@input            ; skip on #$00
  CMP BUTTON_LEFT
  BEQ onLeft@input
  CMP BUTTON_SELECT
  BEQ onSelect@input
  CMP BUTTON_B
  BEQ onB@input
  CMP BUTTON_A
  BEQ onA@input
@done:                         ; 
  JMP __MAIN

;;

onRight@input:                 ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR selectNext@game
  JMP __MAIN
@splash:                       ; 
  JSR selectNext@splash
  JMP __MAIN

;;

onLeft@input:                  ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR selectPrev@game
  JMP __MAIN
@splash:                       ; 
  JSR selectPrev@splash
  JMP __MAIN

;;

onSelect@input:                ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR show@splash
  JMP __MAIN
@splash:                       ; 
  NOP
  JMP __MAIN

;;

onB@input:                     ; 
  LDA view@game
  CMP #$00
  BEQ @splash
@game:                         ; 
  JSR run@player
  JMP __MAIN
@splash:                       ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  JMP __MAIN

;;

onA@input:                     ; 
  LDA view@game
  CMP #$00
  BEQ @splash
@game:                         ; 
  LDX cursor@game
  JSR flipCard@room            ; flip selected card
  JMP __MAIN
@splash:                       ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  JMP __MAIN