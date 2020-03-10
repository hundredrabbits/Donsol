
;; room

enter@room:                    ; 
  LDX #$00
  ; pull card1
  JSR pull@deck
  LDX #$00
  LDY hand@deck
  JSR add@room
  ; pull card2
  JSR pull@deck
  LDX #$01
  LDY hand@deck
  JSR add@room
  ; pull card3
  JSR pull@deck
  LDX #$02
  LDY hand@deck
  JSR add@room
  ; pull card4
  JSR pull@deck
  LDX #$03
  LDY hand@deck
  JSR add@room
  ; etcs
  JSR checkRun
  JSR requestUpdateRun
  RTS

;; add a card to the table

add@room:                      ; (x:card_pos, y:card_id)
  TYA
  STA card1@room, x
  LDA #$01                     ; Request update
  STA reqdraw_card1, x
  RTS

;;

count@room:                    ; () -> store count in x
  LDX #$00
@card1:                        ; 
  LDA card1@room
  CMP #$36
  BEQ @card2
  INX
@card2:                        ; 
  LDA card2@room
  CMP #$36
  BEQ @card3
  INX
@card3:                        ; 
  LDA card3@room
  CMP #$36
  BEQ @card4
  INX
@card4:                        ; 
  LDA card4@room
  CMP #$36
  BEQ @done
  INX
@done:                         ; 
  RTS

;; check for completed room

checkRoom:                     ; 
  ; check if player is alive
  LDA hp@player
  CMP #$00
  BEQ @done
  ; get the number of cards left
  JSR count@room               ; stores in x
  TXA
  CMP #$00
  BNE @done
  ; is complete
  LDA #$01
  STA completed@room           ; set completed@room to $01
@done:                         ; 
  ; auto change room if all cards are flipped
  LDA completed@room
  CMP #$01
  BEQ @complete
  RTS
@complete:                     ; 
  LDA #$30                     ; how long until next draw
  STA timer@room
  RTS

;; room timer for auto change

checkRoomTimer:                ; 
  ; check if room complete is true
  LDA completed@room
  CMP #$00
  BEQ @done
  ; check if room timer is done
  LDA timer@room
  CMP #$00
  BEQ completeRoom
  ; decrement timer
  DEC timer@room
@done:                         ; 
  RTS                          ; return from NMI interup

;; TODO: merge with checkRoomTimer routine

completeRoom:                  ; 
  ; reset ran flag
  LDA #$00
  STA has_run@player
  JSR checkRun
  JSR requestUpdateRun
  ; go on..
  JSR enter@room
  RTS

;; TODO: merge with checkRoomTimer routine(UNUSED!!)

enterNextRoom:                 ; 
  LDA #$00
  STA completed@room
  STA timer@room
  JSR enter@room               ; TODO: replace with real draw
  RTS

;; running

checkRun:                      ; 
  ; Easy Mode: Can run when has not run before.
  ; Normal Mode: Can run when has not run before, AND there is only 1 monster left.
  ; Hard Mode: Can never run.
  LDA difficulty@player
  CMP #$00
  BEQ @Easy
  CMP #$01
  BEQ @Normal
  CMP #$02
  BEQ @Hard
@Easy:                         ; (x:cards_left)
  ; can at any time, only once
  LDA has_run@player
  CMP #$00
  BEQ @enableRun
  JSR @disableRun
  RTS
@Normal:                       ; 
  ; can run, when has not ran before
  LDA has_run@player
  CMP #$01
  BEQ @disableRun
  ; can run when 3 cards left on table
  JSR count@room               ; store cards left in room, in regX
  TXA
  CMP #$01
  BEQ @enableRun
  RTS
@Hard:                         ; 
  ; can never run
  JSR @disableRun
  RTS
@enableRun:                    ; 
  LDA #$01
  STA can_run@player
  RTS
@disableRun
  LDA #$00
  STA can_run@player
  RTS

;;

tryRun:                        ; 
  ; check if player is alive
  LDA hp@player
  CMP #$00
  BNE @begin
  JSR restart
  RTS
@begin:                        ; 
  JSR checkRun
  LDA can_run@player
  CMP #$01
  BNE @unable
  ; record running
  LDA #$01
  STA has_run@player
  ; draw cards for next room
  JSR drawHand2                ; TODO: replace with real draw
  ; update interface
  JSR requestUpdateRun
  ; dialog:run
  LDA #$0C
  STA dialog_id
  JSR requestUpdateDialog
  RTS
@unable:                       ; 
  ; dialog:cannot_run
  LDA #$0D
  STA dialog_id
  JSR requestUpdateDialog
  RTS

;;

drawHand1:                     ; 
  LDX #$00
  LDY #$13                     ; Diamonds 7
  JSR add@room
  LDX #$01
  LDY #$24                     ; Spades 11
  JSR add@room
  LDX #$02
  LDY #$02                     ; Hearts 3
  JSR add@room
  LDX #$03
  LDY #$2B                     ; Clubs 5
  JSR add@room
  JSR checkRun
  JSR requestUpdateRun
  RTS

;;

drawHand2:                     ; 
  LDX #$00
  LDY #$1D                     ; Spades 8
  JSR add@room
  LDX #$01
  LDY #$14                     ; Diamonds 8
  JSR add@room
  LDX #$02
  LDY #$34                     ; Hearts 4
  JSR add@room
  LDX #$03
  LDY #$06                     ; Clubs 5
  JSR add@room
  JSR checkRun
  JSR requestUpdateRun
  RTS