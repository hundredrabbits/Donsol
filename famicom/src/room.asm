
;; room

update@room:                   ; update from the nmi
  ; look for unflipped cards
  LDA card1@room
  CMP #$36
  BNE @incomplete
  LDA card2@room
  CMP #$36
  BNE @incomplete
  LDA card3@room
  CMP #$36
  BNE @incomplete
  LDA card4@room
  CMP #$36
  BNE @incomplete
  ; when the room is complete
  LDA timer@room
  CMP #$00
  BEQ @proceed
  DEC timer@room
  RTS
@proceed:                      ; 
  ; reset ran flag
  LDA #$00
  STA has_run@player
  ; reset timer
  LDA #$30
  STA timer@room
  ; go on..
  JSR enter@room
@incomplete:                   ; 
  RTS

;;

enter@room:                    ; 
  JSR pull@deck                ; pull card1
  LDY hand@deck
  TYA
  STA card1@room
  JSR pull@deck                ; pull card2
  LDY hand@deck
  TYA
  STA card2@room
  JSR pull@deck                ; pull card3
  LDY hand@deck
  TYA
  STA card3@room
  JSR pull@deck                ; pull card4
  LDY hand@deck
  TYA
  STA card4@room
  ; etcs
  JSR checkRun
  JSR requestUpdateRun
  JSR requestUpdateCards
  RTS

;; flip card from the table, used in controls when press

flip@room:                     ; (x:card_pos) ->
  LDA hp@player
  CMP #$00
  BEQ @done
  ; when player is alive
  LDA card1@room, x
  CMP #$36
  BEQ @done
  ; when card is not flipped
  TAY                          ; pick card
  JSR pickCard
  LDA #$36                     ; flip card
  STA card1@room, x
  LDA #$01                     ; request draw
  STA reqdraw_card1, x
@done:                         ; 
  RTS

;; TODO no need to count, could just check if there is any monster left.

enemiesLeft@room:              ; () -> a:count
  LDX #$00
@card1:                        ; 
  LDY card1@room
  LDA card_enemies, y
  CMP #$01
  BNE @card2
  INX
@card2:                        ; 
  LDY card2@room
  LDA card_enemies, y
  CMP #$01
  BNE @card3
  INX
@card3:                        ; 
  LDY card3@room
  LDA card_enemies, y
  CMP #$01
  BNE @card4
  INX
@card4:                        ; 
  LDY card4@room
  LDA card_enemies, y
  CMP #$01
  BNE @done
  INX
@done:                         ; 
  TXA
  RTS

;; running

checkRun:                      ; 
  LDA difficulty@player
  CMP #$00
  BEQ @Easy
  CMP #$01
  BEQ @Normal
  CMP #$02
  BEQ @Hard
@Easy:                         ; RULE | can escape if when no monsters present or when has not escaped before
  JSR enemiesLeft@room
  CMP #$00
  BEQ @enableRun               ; when monsters left
  LDA has_run@player
  CMP #$01
  BEQ @disableRun              ; when has not escaped
  JSR @enableRun
  RTS
@Normal:                       ; RULE | can escape when has not escaped before
  LDA has_run@player
  CMP #$01
  BEQ @disableRun              ; when has not escaped
  JSR @enableRun
  RTS
@Hard:                         ; RULE | can escape if there are no monsters present
  JSR enemiesLeft@room
  CMP #$00
  BNE @disableRun              ; when no monsters present
  JSR @enableRun
  RTS
@enableRun:                    ; 
  LDA #$01
  STA can_run@player
  RTS
@disableRun
  LDA #$00
  STA can_run@player
  RTS

;; return non-flipped cards back to the end of the deck

returnCards@room:              ; 
@return1:                      ; 
  LDA card1@room
  CMP #$36
  BEQ @return2
  JSR return@deck
@return2:                      ; 
  LDA card2@room
  CMP #$36
  BEQ @return3
  JSR return@deck
@return3:                      ; 
  LDA card3@room
  CMP #$36
  BEQ @return4
  JSR return@deck
@return4:                      ; 
  LDA card4@room
  CMP #$36
  BEQ @done
  JSR return@deck
@done
  RTS

;;

run@room:                      ; 
  ; check if player is alive
  LDA hp@player
  CMP #$00
  BEQ @respawn                 ; 
  ; when alive
  JSR checkRun
  LDA can_run@player
  ; check if can run
  CMP #$01
  BNE @unable
  ; when able, record running
  LDA #$01
  STA has_run@player
  ; draw cards for next room
  JSR returnCards@room
  JSR enter@room
  ; dialog:run
  LDA #$0C
  JSR show@dialog
  RTS
@respawn:                      ; 
  JSR restart@game
  RTS
@unable:                       ; 
  ; dialog:cannot_run
  LDA #$04
  JSR show@dialog
  RTS