
;;

restart@game:                  ; 
  JSR init@deck
  JSR shuffle@deck
  JSR reset@player
  JSR enter@room               ; TODO: replace with real draw
  JSR requestUpdateStats
  JSR requestUpdateRun
  JSR requestUpdateCursor
  JSR requestUpdateCards
  JSR requestUpdateName
  ; dialog
  LDA #$04
  JSR show@dialog
  RTS

;;

askQuit@game:                  ; TODO: Implement actual return to splash
  ; dialog
  LDA #$0E
  JSR show@dialog
  RTS