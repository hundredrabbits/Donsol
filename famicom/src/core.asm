
;;

restart:                       ; 
  JSR init@deck
  JSR reset@player
  JSR drawHand1                ; TODO: replace with real draw
  JSR requestUpdateStats
  JSR requestUpdateRun
  JSR requestUpdateCursor
  JSR requestUpdateCards
  JSR requestUpdateName
  ; dialog
  LDA #$04
  STA dialog_id
  JSR requestUpdateDialog
  RTS

;; Draw card to the table

drawCard:                      ; (x:card_pos, y:card_id)
  TYA
  STA card1, x
  LDA #$01                     ; Request update
  STA reqdraw_card1, x
  RTS

;; flip card from the table, used in controls when press

flipCard:                      ; (x:card_pos)
  ; check if player is alive
  LDA hp@player
  CMP #$00
  BEQ @done
  ; check if card is flipped
  LDA card1, x                 ; get card id from table
  CMP #$36
  BEQ @done                    ; skip when card is already flipped
  TAY
  JSR pickCard
  ; flip card
  LDA #$36                     ; $36 is flipped
  STA card1, x
  LDA #$01                     ; Request update
  STA reqdraw_card1, x
  ; misc
  INC xp@player
  JSR requestUpdateStats
@done:                         ; 
  JSR checkRoom
  JSR checkRun
  JSR requestUpdateRun
  RTS

;; Pick card from the deck

pickCard:                      ; (y:card_id)
  TYA                          ; transfer from Y to A
  ; check if card is flipped
  CMP #$36                     ; if card is $36(flipped)
  BEQ @done                    ; skip selection
  ; load card data
  LDA card_types, y
  STA card_last_type           ; load type
  LDA card_values, y
  STA card_last_value          ; load value
  ; branch types
  LDA card_types, y
  CMP #$00
  BEQ selectCardHeart
  CMP #$01
  BEQ selectCardDiamond
  CMP #$02
  BEQ selectCardSpade
  CMP #$03
  BEQ selectCardClover
  CMP #$04
  BEQ selectCardJoker
@done:                         ; 
  RTS

;; selection

selectCardHeart:               ; 
  JSR runPotion
  JSR addPotionSickness
  RTS
selectCardDiamond:             ; 
  JSR runShield
  JSR removePotionSickness
  RTS
selectCardSpade:               ; 
  JSR runAttack
  JSR removePotionSickness
  RTS
selectCardClover:              ; 
  JSR runAttack
  JSR removePotionSickness
  RTS
selectCardJoker:               ; 
  JSR runAttack
  JSR removePotionSickness
  RTS

;; turn(potion)

runPotion:                     ; 
  ; check for potion sickness
  LDA sickness@player
  CMP #$01
  BEQ runPotionSickness
  ; check for potion waste
  LDA hp@player
  CMP #$15
  BEQ runPotionWaste
  ; heal
  LDA hp@player
  CLC
  ADC card_last_value
  STA hp@player
  ; specials
  JSR clampHealth
  ; dialog:potion
  LDA #$06
  STA dialog_id
  JSR requestUpdateDialog
  RTS

;; turn(potion-sickness)

runPotionSickness:             ; 
  ; dialog:sickness
  LDA #$01
  STA dialog_id
  JSR requestUpdateDialog
  RTS

;; turn(potion-waste)

runPotionWaste:                ; 
  ; dialog:potion
  LDA #$07
  STA dialog_id
  JSR requestUpdateDialog
  RTS

;; turn(shield)

runShield:                     ; 
  LDA card_last_value
  STA sp@player
  LDA #$16                     ; max durability is $15+1
  STA dp@player
  ; dialog
  LDA #$05
  STA dialog_id
  JSR requestUpdateDialog
  RTS

;; turn(attack)

runAttack:                     ; 
  ; check if can block
  LDA sp@player
  CMP #$00
  BNE @blocking
  ; dialog:unshielded
  LDA #$08
  STA dialog_id
  JSR requestUpdateDialog
  ; load damages(unblocked)
  LDA card_last_value
  STA damages@player
  JSR runDamages
  RTS
@blocking:                     ; 
  ; check if shield breaking
  LDA card_last_value
  CMP dp@player
  BCC @shielded
  ; dialog:shield break
  LDA #$02
  STA dialog_id
  JSR requestUpdateDialog
  ; break shield
  LDA #$00
  STA sp@player
  STA dp@player
  ; load damages(unblocked)
  LDA card_last_value
  STA damages@player
  JSR runDamages
  RTS
@shielded:                     ; 
  ; check for overflow
  LDA card_last_value
  CMP sp@player
  BCC @blocked
  ; dialog:damages
  LDA #$0B
  STA dialog_id
  JSR requestUpdateDialog
  ; load damages(partial)
  LDA card_last_value
  SEC
  SBC sp@player                ; damages is now stored in A
  STA damages@player
  JSR runDamages
  ; damage shield
  LDA card_last_value
  STA dp@player
  RTS
@blocked:                      ; 
  ; damage shield
  LDA card_last_value
  STA dp@player
  ; dialog:blocked
  LDA #$0A
  STA dialog_id
  JSR requestUpdateDialog
  RTS

;; damages

runDamages:                    ; 
  ; check if killing
  LDA damages@player
  CMP hp@player
  BCC @survive
  LDA #$00
  STA hp@player
  STA sp@player
  STA xp@player
  ; dialog:death
  LDA #$03
  STA dialog_id
  JSR requestUpdateDialog
  RTS                          ; stop attack phase
@survive:                      ; 
  LDA hp@player
  SEC
  SBC damages@player
  STA hp@player
  ; dialog:attack
  LDA #$09
  STA dialog_id
  JSR requestUpdateDialog
  RTS

;; flags

addPotionSickness:             ; 
  LDA #$01
  STA sickness@player
  RTS
removePotionSickness:          ; 
  LDA #$00
  STA sickness@player
  RTS
clampHealth:                   ; 
  LDA hp@player
  CMP #$15
  BCC @done
  LDA #$15
  STA hp@player
@done:                         ; 
  RTS

;;

countCardsLeft:                ; () -> store count in x
  LDX #$00
@card1:                        ; 
  LDA card1
  CMP #$36
  BEQ @card2
  INX
@card2:                        ; 
  LDA card2
  CMP #$36
  BEQ @card3
  INX
@card3:                        ; 
  LDA card3
  CMP #$36
  BEQ @card4
  INX
@card4:                        ; 
  LDA card4
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
  JSR countCardsLeft           ; stores in x
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
  JSR enterNextRoom
  RTS

;; TODO: merge with checkRoomTimer routine

enterNextRoom:                 ; 
  LDA #$00
  STA completed@room
  STA timer@room
  JSR drawHand1                ; TODO: replace with real draw
  RTS

;;

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
  JSR countCardsLeft           ; store cards left in room, in regX
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
  JSR drawCard
  LDX #$01
  LDY #$24                     ; Spades 11
  JSR drawCard
  LDX #$02
  LDY #$02                     ; Hearts 3
  JSR drawCard
  LDX #$03
  LDY #$2B                     ; Clubs 5
  JSR drawCard
  JSR checkRun
  JSR requestUpdateRun
  RTS

;;

drawHand2:                     ; 
  LDX #$00
  LDY #$1D                     ; Spades 8
  JSR drawCard
  LDX #$01
  LDY #$14                     ; Diamonds 8
  JSR drawCard
  LDX #$02
  LDY #$34                     ; Hearts 4
  JSR drawCard
  LDX #$03
  LDY #$06                     ; Clubs 5
  JSR drawCard
  JSR checkRun
  JSR requestUpdateRun
  RTS