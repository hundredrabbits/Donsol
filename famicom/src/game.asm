
;;

restart@game:                  ; 
  JSR init@deck
  JSR shuffle@deck
  JSR reset@player
  JSR enter@room
  JSR requestUpdateStats
  JSR requestUpdateRun
  JSR update@cursor
  JSR requestUpdateCards
  JSR requestUpdateName
  ; set enter dialog
  LDA #$04
  JSR show@dialog
  ; reset room timer
  LDA #$30
  STA timer@room
  RTS

;;

askQuit@game:                  ; TODO: Implement actual return to splash
  ; dialog
  LDA #$0E
  JSR show@dialog
  RTS