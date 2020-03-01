
GameStart:
  ; reset health($15 = 21)
  LDA #$15
  STA health_max
  LDA health_max
  STA health
  ; reset controls
  LDA #$00
  STA arrow_left_pressed
  STA arrow_right_pressed
  STA experience
  STA is_dead
  STA ui_selection
  LDA #$01
  STA can_run

  JSR drawCards
  JSR updateCursor
  JSR updateStats

Forever:
  JMP Forever     ; jump back to Forever, infinite loop

NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016       ; tell both the controllers to latch buttons

ReadA: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadARelease  ; check if button is already pressed
  LDA a_pressed
  CMP #$01
  BEQ ReadADone
  JSR selectCard ; record press
  LDA #$01
  STA a_pressed 
  JMP ReadADone
ReadARelease: ; record release
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
  JSR updateCursor
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
  JSR updateCursor
  RTS

selectCard:
  ; check if card is flipped
  LDX ui_selection    ; load selection in X
  LDA card1, x        ; select card on table
  CMP #$36            ; if card is $36(flipped)
  BEQ selectCardDone  ; skip selection
  ; load card data
  STA card_last       ; 
  LDX card_last
  LDA card_types, x
  STA card_last_type  ; load type
  LDA card_values, x
  STA card_last_value ; load value
  ; branch types
  LDA card_types, x
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
selectCardDone:
  RTS

selectCardHeart:
  JSR runPotion
  JSR flipCard
  RTS

selectCardDiamond:
  JSR runShield
  JSR flipCard
  RTS

selectCardSpade:
  JSR runAttack
  JSR flipCard
  RTS

selectCardClub:
  JSR runAttack
  JSR flipCard
  RTS

selectCardJoker:
  JSR runAttack
  JSR flipCard
  RTS

flipCard:
  LDX ui_selection
  LDA #$36            ; $36 is flipped
  STA card1, x
  INC experience
  ; if room is complete, draw
  JSR checkRoom
  JSR updateStats
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
  JSR addPotionSickness
runPotionDone:
  RTS

runShield:
  LDA card_last_value
  STA shield
  STA shield_max
  ; specials
  JSR removePotionSickness
  RTS

runAttack:
  ; TODO: check if hit is killing
  LDA health
  CLC
  SBC card_last_value
  STA health
  ; TODO: implement shield malus
  ; TODO: implement death
  ; specials
  JSR removePotionSickness
  RTS

; tools

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
  CMP health_max
  BCC clampHealthDone
  LDA health_max
  STA health
clampHealthDone:
  RTS

; cards

drawCards:
  LDA #$03   ; heart 4
  STA card1
  LDA #$11   ; diamond 5
  STA card2
  LDA #$1f   ; spades 6
  STA card3
  LDA #$2d   ; club 7
  STA card4
  RTS

; loaders

load00:
  LDX #$00
  LDY #$00
  RTS

load21:
  LDX #$02
  LDY #$01
  RTS

; update

updateHealth:
  LDA $2000 ; read PPU status to reset the high/low latch
updateHealthDigit1:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$07
  STA $2006 ; write the low byte of $2000 address
  LDX health
  LDA number_high, x
  STA $2007
updateHealthDigit2:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$08
  STA $2006 ; write the low byte of $2000 address
  LDX health
  LDA number_low, x
  STA $2007
updateHealthFix:
  LDA #$00         ; No background scrolling
  STA $2005
  STA $2005

  RTS

updateShield:
  LDA $2000 ; read PPU status to reset the high/low latch
updateShieldDigit1:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$0e
  STA $2006 ; write the low byte of $2000 address
  LDX shield
  LDA number_high, x
  STA $2007
updateShieldDigit2:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$0f
  STA $2006 ; write the low byte of $2000 address
  LDX shield
  LDA number_low, x
  STA $2007
updateShieldFix:
  LDA #$00         ; No background scrolling
  STA $2005
  STA $2005

  RTS

updateExperience:
  LDA $2000 ; read PPU status to reset the high/low latch
updateExperienceDigit1:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$15
  STA $2006 ; write the low byte of $2000 address
  LDX experience
  LDA number_high, x
  STA $2007
updateExperienceDigit2:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$16
  STA $2006 ; write the low byte of $2000 address
  LDX experience
  LDA number_low, x
  STA $2007
updateExperienceFix:
  LDA #$00         ; No background scrolling
  STA $2005
  STA $2005

  RTS

updateStats:
  JSR updateHealth
  JSR updateShield
  JSR updateExperience
  RTS

updateCursor:
  LDX ui_selection
  LDA cursor_positions, x
  STA $0203        ; set tile.x pos
  CLC
  ADC #$08
  STA $0207        ; set tile.x pos
  RTS