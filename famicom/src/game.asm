
;;

show@game:                     ; 
  ; set game mode
  LDA #$01
  STA view@game
  ; setup cursor
  JSR initCursor@game
  JSR updateCursor@game
  RTS

;;

restart@game:                  ; 
  JSR init@deck
  JSR shuffle@deck
  JSR reset@player
  JSR enter@room
  JSR requestUpdateStats
  JSR requestUpdateRun
  JSR updateCursor@game
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
  LDA cursor@game
  CMP #$03
  BEQ @wrap
  INC cursor@game
  JMP @done
@wrap:                         ; 
  LDA #$00
  STA cursor@game
@done:                         ; 
  JSR updateCursor@game
  RTS

;;

selectPrev@game:               ; 
  LDA cursor@game
  CMP #$00
  BEQ @wrap
  DEC cursor@game
  JMP @done
@wrap:                         ; 
  LDA #$03
  STA cursor@game
@done:                         ; 
  JSR updateCursor@game
  RTS

;;

select@game:                   ; 
  LDX cursor@game
  JSR flip@room
  RTS

;;

return@game:                   ; 
  ; askquit: leave(TODO)
  ; dungeon: run
  JSR run@room
  RTS
onSelectChange@game:           ; 
  ; JSR update@cursor
  RTS

;;

initCursor@game:               ; 
  LDA #$B0                     ; cursor(left)
  STA $0200                    ; set tile.y pos
  LDA #$10
  STA $0201                    ; set tile.id
  LDA #$00
  STA $0202                    ; set tile.attribute
  LDA #$88
  STA $0203                    ; set tile.x pos
  LDA #$B0                     ; cursor(right)
  STA $0204                    ; set tile.y pos
  LDA #$11
  STA $0205                    ; set tile.id
  LDA #$00
  STA $0206                    ; set tile.attribute
  LDA #$88
  STA $0207                    ; set tile.x pos
  RTS

;;

updateCursor@game:             ; 
  LDX cursor@game
  LDA selections@game, x
  STA $0203                    ; set tile.x pos
  CLC
  ADC #$08
  STA $0207                    ; set tile.x pos
  RTS