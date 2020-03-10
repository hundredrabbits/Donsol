
;;

restart:                       ; 
  JSR init@deck
  JSR resetStats
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
  LDA health
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
  INC experience
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
  LDA potion_sickness
  CMP #$01
  BEQ runPotionSickness
  ; check for potion waste
  LDA health
  CMP #$15
  BEQ runPotionWaste
  ; heal
  LDA health
  CLC
  ADC card_last_value
  STA health
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
  STA shield
  LDA #$16                     ; max durability is $15+1
  STA shield_durability
  ; dialog
  LDA #$05
  STA dialog_id
  JSR requestUpdateDialog
  RTS

;; turn(attack)

runAttack:                     ; 
  ; check if can block
  LDA shield
  CMP #$00
  BNE @blocking
  ; dialog:unshielded
  LDA #$08
  STA dialog_id
  JSR requestUpdateDialog
  ; load damages(unblocked)
  LDA card_last_value
  STA damages
  JSR runDamages
  RTS
@blocking:                     ; 
  ; check if shield breaking
  LDA card_last_value
  CMP shield_durability
  BCC @shielded
  ; dialog:shield break
  LDA #$02
  STA dialog_id
  JSR requestUpdateDialog
  ; break shield
  LDA #$00
  STA shield
  STA shield_durability
  ; load damages(unblocked)
  LDA card_last_value
  STA damages
  JSR runDamages
  RTS
@shielded:                     ; 
  ; check for overflow
  LDA card_last_value
  CMP shield
  BCC @blocked
  ; dialog:damages
  LDA #$0B
  STA dialog_id
  JSR requestUpdateDialog
  ; load damages(partial)
  LDA card_last_value
  SEC
  SBC shield                   ; damages is now stored in A
  STA damages
  JSR runDamages
  ; damage shield
  LDA card_last_value
  STA shield_durability
  RTS
@blocked:                      ; 
  ; damage shield
  LDA card_last_value
  STA shield_durability
  ; dialog:blocked
  LDA #$0A
  STA dialog_id
  JSR requestUpdateDialog
  RTS

;; damages

runDamages:                    ; 
  ; check if killing
  LDA damages
  CMP health
  BCC @survive
  LDA #$00
  STA health
  STA shield
  STA experience
  ; dialog:death
  LDA #$03
  STA dialog_id
  JSR requestUpdateDialog
  RTS                          ; stop attack phase
@survive:                      ; 
  LDA health
  SEC
  SBC damages
  STA health
  ; dialog:attack
  LDA #$09
  STA dialog_id
  JSR requestUpdateDialog
  RTS

;; flags

addPotionSickness:             ; 
  LDA #$01
  STA potion_sickness
  RTS
removePotionSickness:          ; 
  LDA #$00
  STA potion_sickness
  RTS
clampHealth:                   ; 
  LDA health
  CMP #$15
  BCC @done
  LDA #$15
  STA health
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
  LDA health
  CMP #$00
  BEQ @done
  ; get the number of cards left
  JSR countCardsLeft           ; stores in x
  TXA
  CMP #$00
  BNE @done
  ; is complete
  LDA #$01
  STA room_complete            ; set room_complete to $01
@done:                         ; 
  ; auto change room if all cards are flipped
  LDA room_complete
  CMP #$01
  BEQ @complete
  RTS
@complete:                     ; 
  LDA #$30                     ; how long until next draw
  STA room_timer
  RTS

;; room timer for auto change

checkRoomTimer:                ; 
  ; check if room complete is true
  LDA room_complete
  CMP #$00
  BEQ @done
  ; check if room timer is done
  LDA room_timer
  CMP #$00
  BEQ completeRoom
  ; decrement timer
  DEC room_timer
@done:                         ; 
  RTS                          ; return from NMI interup

;; TODO: merge with checkRoomTimer routine

completeRoom:                  ; 
  ; reset ran flag
  LDA #$00
  STA has_run
  JSR checkRun
  JSR requestUpdateRun
  ; go on..
  JSR enterNextRoom
  RTS

;; TODO: merge with checkRoomTimer routine

enterNextRoom:                 ; 
  LDA #$00
  STA room_complete
  STA room_timer
  JSR drawHand1                ; TODO: replace with real draw
  RTS

;;

checkRun:                      ; 
  ; Easy Mode: Can run when has not run before.
  ; Normal Mode: Can run when has not run before, AND there is only 1 monster left.
  ; Hard Mode: Can never run.
  LDA difficulty
  CMP #$00
  BEQ @Easy
  CMP #$01
  BEQ @Normal
  CMP #$02
  BEQ @Hard
@Easy:                         ; (x:cards_left)
  ; can at any time, only once
  LDA has_run
  CMP #$00
  BEQ @enableRun
  JSR @disableRun
  RTS
@Normal:                       ; 
  ; can run, when has not ran before
  LDA has_run
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
  STA can_run
  RTS
@disableRun
  LDA #$00
  STA can_run
  RTS

;;

tryRun:                        ; 
  ; check if player is alive
  LDA health
  CMP #$00
  BNE @begin
  JSR restart
  RTS
@begin:                        ; 
  JSR checkRun
  LDA can_run
  CMP #$01
  BNE @unable
  ; record running
  LDA #$01
  STA has_run
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