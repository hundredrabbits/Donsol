
;; main

;; skip if no input

handleJoy:                     ; 
  LDA next@input
  CMP #$00
  BNE releaseJoy
  INC seed1@deck               ; increment seed1
  JMP __MAIN

;; release input, store in regA

releaseJoy:                    ; 
  LDA next@input
  LDX #$00                     ; release
  STX next@input
  INC seed2@deck               ; increment seed2 on input

;;

checkJoy:                      ; 
  LDX view@game
  CPX #$00
  BNE @game
@splash:                       ; 
  CMP BUTTON_RIGHT
  BEQ onRight@splash
  CMP BUTTON_LEFT
  BEQ onLeft@splash
  CMP BUTTON_B
  BEQ onB@splash
  CMP BUTTON_A
  BEQ onA@splash
  JMP __MAIN
@game:                         ; 
  CMP BUTTON_RIGHT
  BEQ onRight@game
  CMP BUTTON_LEFT
  BEQ onLeft@game
  CMP BUTTON_SELECT
  BEQ onSelect@game
  CMP BUTTON_B
  BEQ onB@game
  CMP BUTTON_A
  BEQ onA@game
  JMP __MAIN

;;

onRight@splash:                ; 
  INC cursor@splash
  LDA cursor@splash
  CMP #$03
  BNE @done
  ; wrap around
  LDA #$00
  STA cursor@splash
@done:                         ; 
  LDA #$01                     ; request draw for cursor
  STA reqdraw_cursor
  JMP __MAIN

;;

onLeft@splash:                 ; 
  DEC cursor@splash
  LDA cursor@splash
  CMP #$FF
  BNE @done
  ; wrap around
  LDA #$02
  STA cursor@splash
@done:                         ; 
  LDA #$01                     ; request draw for cursor
  STA reqdraw_cursor
  JMP __MAIN

;;

onB@splash:                    ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  JMP __MAIN

;;

onA@splash:                    ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  JMP __MAIN

;;

onRight@game:                  ; 
  INC cursor@game
  LDA cursor@game
  CMP #$04
  BNE @done
  ; wrap around
  LDA #$00
  STA cursor@game
@done:                         ; 
  LDA #$01                     ; request draw for cursor
  STA reqdraw_cursor
  STA reqdraw_name
  JMP __MAIN

;;

onLeft@game:                   ; 
  DEC cursor@game
  LDA cursor@game
  CMP #$FF
  BNE @done
  ; wrap around
  LDA #$03
  STA cursor@game
@done:                         ; 
  LDA #$01                     ; request draw for cursor
  STA reqdraw_cursor
  STA reqdraw_name
  JMP __MAIN

;;

onSelect@game:                 ; 
  JSR show@splash
  JMP __MAIN

;;

onB@game:                      ; 
  JSR tryRun@player
  JMP __MAIN

;;

onA@game:                      ; 
  JSR tryFlip@room             ; flip selected card
  JMP __MAIN