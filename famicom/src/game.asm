
;;

show@game:                     ; 
  ; set game mode
  LDA #$01
  STA view@game
  RTS

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

;;

selectNext@game:               ; 
  LDA cursor@splash
  CMP #$02
  BEQ @wrap
  INC cursor@splash
  JMP @done
@wrap:                         ; 
  LDA #$00
  STA cursor@splash
@done:                         ; 
  JSR onSelectChange@splash
  RTS

;;

selectPrev@game:               ; 
  LDA cursor@splash
  CMP #$00
  BEQ @wrap
  DEC cursor@splash
  JMP @done
@wrap:                         ; 
  LDA #$02
  STA cursor@splash
@done:                         ; 
  JSR onSelectChange@splash
  RTS

;;

onSelectChange@game:           ; 
  ; JSR update@cursor
  RTS