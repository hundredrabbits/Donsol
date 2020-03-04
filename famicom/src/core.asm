;; core

GameStart:
  ; reset health($15 = 21)
  LDA #$15
  STA health
  ; reset controls
  LDA #$00
  STA arrow_left_pressed
  STA arrow_right_pressed
  STA experience
  STA ui_selection
  LDA #$01
  STA can_run 
  ; tests
  JSR runTests
  JSR requestUpdateStats

  ; table

  LDX #$00
  LDY #$05            ; Hearts 6
  JSR drawCard
  LDX #$01
  LDY #$13            ; Diamonds 7
  JSR drawCard
  LDX #$02
  LDY #$21            ; Spades 8
  JSR drawCard
  LDX #$03
  LDY #$2f            ; Clubs 9
  JSR drawCard

  ;

  LDA #$01
  STA reqdraw_cursor

  ;

  LDA #$01
  STA reqdraw_card1
  LDA #$01
  STA reqdraw_card2
  LDA #$01
  STA reqdraw_card3
  LDA #$01
  STA reqdraw_card4


  ; UI
  ; JSR updateStats
  ; JSR updateCards

EnableSprites:
  LDA #%10010000      ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110      ; enable sprites, enable background, no clipping on left side
  STA $2001
  
  LDA #$00            ; No background scrolling
  STA $2006
  STA $2006
  STA $2005
  STA $2005

Forever:
  JMP Forever         ; jump back to Forever, infinite loop

NMI:
  LDA #$00
  STA $2003           ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014           ; set the high byte (02) of the RAM address, start the transfer

  JSR updateClient

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016           ; tell both the controllers to latch buttons

ReadA: 
  LDA $4016
  AND #%00000001      ; only look at bit 0
  BEQ ReadARelease    ; check if button is already pressed
  LDA a_pressed
  CMP #$01
  BEQ ReadADone
  LDX ui_selection    ; load selection in X
  LDY card1, x        ; select card on table, from offset of card1
  JSR pickCard        ; record press
  LDA #$01
  STA a_pressed 
  JMP ReadADone
ReadARelease:         ; record release
  LDA #$00
  STA a_pressed 
ReadADone:
  
ReadB: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadBDone
  NOP
ReadBDone:        ; handling this button is done

ReadSel: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadSelDone 
  NOP
ReadSelDone:        ; handling this button is done

ReadStart: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadStartDone 
  NOP
ReadStartDone:        ; handling this button is done

ReadUp: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadUpDone 
  NOP
ReadUpDone:        ; handling this button is done

ReadDown: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadDownDone 
  NOP
ReadDownDone:        ; handling this button is done

ReadLeft: 
  LDA $4016
  AND #%00000001
  BEQ ReadLeftRelease  ; check if button is already pressed
  LDA arrow_left_pressed
  CMP #$01
  BEQ ReadLeftDone
  JSR selectPrevCard ; record press
  LDA #$01
  STA arrow_left_pressed 
  JMP ReadLeftDone
ReadLeftRelease: ; record release
  LDA #$00
  STA arrow_left_pressed 
ReadLeftDone:

ReadRight: 
  LDA $4016
  AND #%00000001
  BEQ ReadRightRelease ; check if button is already pressed
  LDA arrow_right_pressed
  CMP #$01
  BEQ ReadRightDone
  JSR selectNextCard ; record press
  LDA #$01
  STA arrow_right_pressed 
  JMP ReadRightDone
ReadRightRelease: ; record release
  LDA #$00
  STA arrow_right_pressed 
ReadRightDone:

  RTI             ; return from interrupt

; selection

selectNextCard:
  LDA ui_selection
  CMP #$03
  BEQ selectNextAround
  INC ui_selection
  JMP selectNextDone
selectNextAround:
  LDA #$00
  STA ui_selection
selectNextDone:
  LDA #$01
  STA reqdraw_cursor
  RTS

selectPrevCard:
  LDA ui_selection
  CMP #$00
  BEQ selectPrevAround
  DEC ui_selection
  JMP selectPrevDone
selectPrevAround:
  LDA #$03
  STA ui_selection
selectPrevDone:
  LDA #$01
  STA reqdraw_cursor
  RTS

; Draw card to the table

drawCard:
  ; Card table pos, must be in Xreg
  ; Card deck id, must be in Yreg
  TYA 
  STA card1, x
  RTS

; Pick card from the deck

pickCard: 
  ; Card must be in Yreg
  TYA                 ; transfer from Y to A
  ; check if card is flipped
  CMP #$36            ; if card is $36(flipped)
  BEQ pickCardDone    ; skip selection
  ; load card data
  LDA card_types, y
  STA card_last_type  ; load type
  LDA card_values, y
  STA card_last_value ; load value
  ; branch types
  LDA card_types, y
  CMP #$00
  BEQ selectCardHeart
  CMP #$01
  BEQ selectCardDiamond
  CMP #$02
  BEQ selectCardSpade
  CMP #$03
  BEQ selectCardClub
  CMP #$04
  BEQ selectCardJoker
pickCardDone:
  RTS

selectCardHeart:
  JSR runPotion
  JSR addPotionSickness
  JSR flipCard
  RTS

selectCardDiamond:
  JSR runShield
  JSR removePotionSickness
  JSR flipCard
  RTS

selectCardSpade:
  JSR runAttack
  JSR removePotionSickness
  JSR flipCard
  RTS

selectCardClub:
  JSR runAttack
  JSR removePotionSickness
  JSR flipCard
  RTS

selectCardJoker:
  JSR runAttack
  JSR removePotionSickness
  JSR flipCard
  RTS

flipCard:
  LDX ui_selection
  LDA #$36            ; $36 is flipped
  STA card1, x
  INC experience
  JSR requestUpdateStats
  ; if room is complete, draw
  ; TODO: split client from core
  ; JSR checkRoom
  ; JSR updateStats
  ; JSR updateSickness
  RTS

checkRoom:
  LDA #$00
  STA room_complete
  LDA card1
  CMP #$36
  BNE checkRoomDone
  LDA card2
  CMP #$36
  BNE checkRoomDone
  LDA card3
  CMP #$36
  BNE checkRoomDone
  LDA card4
  CMP #$36
  BNE checkRoomDone
  LDA #$01
  STA room_complete ; set room_complete to $01
checkRoomDone:
  ; auto change room if all cards are flipped
  ; TODO: start timer
  LDA room_complete
  CMP #$01
  BEQ drawCards
  RTS

; cards

drawCards:
  LDA #$03   ; heart 4
  STA card1
  LDA #$0e   ; diamond 5
  STA card2
  LDA #$1f   ; spades 6
  STA card3
  LDA #$2d   ; club 7
  STA card4
  RTS

; turns

runPotion:
  ; check for potion sickness
  LDA potion_sickness
  CMP #$01
  BEQ runPotionDone
  ; heal
  LDA health
  CLC
  ADC card_last_value
  STA health
  ; specials
  JSR clampHealth
runPotionDone:
  RTS

runShield:
  LDA card_last_value
  STA shield
  LDA #$16 ; max durability is $15+1
  STA shield_durability
  RTS

runAttack:
  ; check if can block
  LDA shield
  CMP #$00
  BNE runAttackBlock
  ; load damages(unblocked)
  LDA card_last_value
  STA damages
  JSR runDamages
  RTS
runAttackBlock:
  ; check if shield breaking
  LDA card_last_value
  CMP shield_durability
  BCC runAttackShielded
  ; break shield
  LDA #$00
  STA shield
  STA shield_durability
  ; load damages(unblocked)
  LDA card_last_value 
  STA damages
  JSR runDamages
  RTS
runAttackShielded:
  ; check for overflow
  LDA card_last_value
  CMP shield
  BCC runAttackShieldedFull
runAttackShieldedPartial:
  ; load damages(partial)
  LDA card_last_value
  SEC
  SBC shield ; damages is now stored in A
  STA damages
  JSR runDamages
  ; damage shield
  LDA card_last_value
  STA shield_durability
  RTS
runAttackShieldedFull:
  ; damage shield
  LDA card_last_value
  STA shield_durability
  RTS

runDamages:
  ; check if killing
  LDA damages
  CMP health
  BCC runDamagesSurvive
runDamagesDeath:
  LDA #$00
  STA health
  STA shield
  STA experience
  RTS                 ; stop attack phase
runDamagesSurvive:
  LDA health
  SEC
  SBC damages
  STA health
  RTS

; flags

addPotionSickness:
  LDA #$01
  STA potion_sickness
  RTS

removePotionSickness:
  LDA #$00
  STA potion_sickness
  RTS

clampHealth:
  LDA health
  CMP #$15
  BCC clampHealthDone
  LDA #$15
  STA health
clampHealthDone:
  RTS
