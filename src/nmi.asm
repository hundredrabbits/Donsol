
;; nmi

;; detect joy

readJoy:                       ; [skip]
  LDA #$01
  STA JOY1                     ; start reading
  STA down@input
  LSR a
  STA JOY1
@loop:                         ; 
  LDA JOY1
  LSR a
  ROL down@input
  BCC @loop

;;

saveJoy:                       ; [skip]
  LDA down@input
  CMP last@input
  BEQ @done
  STA last@input
  CMP #$00
  BEQ @done
  STA next@input
@done:                         ; 

;; route screens

sendView:                      ; 
  LDX view@game
  CPX #$00
  BNE viewGame

;;

viewSplash:                    ; 
@splashScreen:                 ; 
  LDA reqdraw_splash           ; splash-screen
  CMP #$01
  BNE @splashCursor
  JMP redrawScreen@splash
@splashCursor:                 ; 
  LDA reqdraw_cursor           ; splash-cursor
  CMP #$01
  BNE @done
  JMP redrawCursor@splash
@done
  RTI

;;

viewGame:                      ; 
  JSR interpolateStats@game
@checkReqGame:                 ; 
  LDA reqdraw_game
  CMP #$01
  BNE @checkReqSP
  JMP redrawScreen@game
@checkReqSP:                   ; [skip]
  LDA redraws@game
  AND REQ_SP
  BEQ @checkReqHP
  JMP redrawShield@game
@checkReqHP:                   ; 
  LDA redraws@game
  AND REQ_HP
  BEQ @checkReqCursor
  JMP redrawHealth@game
@checkReqCursor:               ; 
  LDA reqdraw_cursor
  CMP #$01
  BNE @checkName
  JMP redrawCursor@game
@checkName:                    ; 
  LDA reqdraw_name
  CMP #$01
  BNE @checkReqCard1
  JMP redrawName@game
@checkReqCard1:                ; 
  LDA redraws@game
  AND REQ_CARD1
  BEQ @checkReqCard2
  JMP redrawCard1@game
@checkReqCard2:                ; 
  LDA redraws@game
  AND REQ_CARD2
  BEQ @checkReqCard3
  JMP redrawCard2@game
@checkReqCard3:                ; 
  LDA redraws@game
  AND REQ_CARD3
  BEQ @checkReqCard4
  JMP redrawCard3@game
@checkReqCard4:                ; 
  LDA redraws@game
  AND REQ_CARD4
  BEQ @checkReqXP
  JMP redrawCard4@game
@checkReqXP:                   ; 
  LDA redraws@game
  AND REQ_XP
  BEQ @checkReqRun
  JMP redrawExperience@game
@checkReqRun:                  ; 
  LDA redraws@game
  AND REQ_RUN
  BEQ @checkReqDialog
  JMP redrawRun@game
@checkReqDialog:               ; 
  LDA reqdraw_dialog
  CMP #$01
  BNE @done
  JMP redraw@dialog
@done
  RTI

;;
