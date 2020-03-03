
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
  ; table
  JSR drawCards
  ; UI
  JSR updateStats
  JSR updateCursor
  ; JSR updateCards

EnableSprites:
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001
  
  LDA #$00         ; No background scrolling
  STA $2006
  STA $2006
  STA $2005
  STA $2005

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
  LDX ui_selection    ; load selection in X
  LDY card1, x        ; select card on table, from offset of card1
  JSR pickCard ; record press
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

pickCard: ; select card in reg Y
  ; check if card is flipped
  TYA                 ; transfer from Y to A
  CMP #$36            ; if card is $36(flipped)
  BEQ pickCardDone  ; skip selection
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
  ; if room is complete, draw
  JSR checkRoom
  JSR updateStats
  JSR updateSickness
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
  CMP #$15
  BCC clampHealthDone
  LDA #$15
  STA health
clampHealthDone:
  RTS

; update

updateHealth:
  LDA $2000 ; read PPU status to reset the high/low latch
  LDX #$00  ; Not quite sure why this is needed, but breaks otherwise
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

updateHealthBar:
  LDX #$00
  LDY health
  LDA healthbarpos, y ; regA has sprite offset
  TAY                 ; regY has sprite offset
updateHealthBarLoop:
  LDA #$20
  STA $2006           ; write the high byte of $2000 address
  LDA healthbaroffset, x
  STA $2006           ; write the low byte of $2000 address
  LDA healthbar, y    ; regA has sprite id
  INY
  STA $2007
  INX
  CPX #$06
  BNE updateHealthBarLoop
updateHealthBarDone:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateShield:
  LDA $2000 ; read PPU status to reset the high/low latch
  LDX #$00  ; Not quite sure why this is needed, but breaks otherwise
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
updateShieldDurabilityDigit1:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$0c
  STA $2006 ; write the low byte of $2000 address
  LDX shield_durability
  LDA card_glyphs, x
  STA $2007
updateShieldFix:
  LDA #$00         ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateShieldBar:
  LDX #$00
  LDY shield
  LDA shieldbarpos, y ; regA has sprite offset
  TAY                 ; regY has sprite offset
updateShieldBarLoop:
  LDA #$20
  STA $2006           ; write the high byte of $2000 address
  LDA shieldbaroffset, x
  STA $2006           ; write the low byte of $2000 address
  LDA healthbar, y    ; regA has sprite id
  INY
  STA $2007
  INX
  CPX #$06
  BNE updateShieldBarLoop
updateShieldBarDone:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateExperience:
  LDA $2000 ; read PPU status to reset the high/low latch
  LDX #$00  ; Not quite sure why this is needed, but breaks otherwise
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

updateExperienceBar:
  LDX #$00
  LDY experience
  LDA experiencebarpos, y ; regA has sprite offset
  TAY                 ; regY has sprite offset
updateExperienceBarLoop:
  LDA #$20
  STA $2006           ; write the high byte of $2000 address
  LDA experiencebaroffset, x
  STA $2006           ; write the low byte of $2000 address
  LDA experiencebar, y    ; regA has sprite id
  INY
  STA $2007
  INX
  CPX #$06
  BNE updateExperienceBarLoop
updateExperienceBarDone:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateStats:
  JSR updateHealth
  JSR updateHealthBar
  JSR updateShield
  JSR updateShieldBar
  JSR updateExperience
  JSR updateExperienceBar
  RTS

updateCards:
  JSR drawCard1
  JSR drawCard2
  JSR drawCard3
  JSR drawCard4
  RTS

updateCursor:
  LDX ui_selection
  LDA cursor_positions, x
  STA $0203        ; set tile.x pos
  CLC
  ADC #$08
  STA $0207        ; set tile.x pos
  RTS

; to merge into a single routine

drawCard1:
  LDA #$00
  LDX #$00
drawCardLoop:
  LDA card1pos_high, x
  STA $2006           ; write the high byte of $2000 address
  LDA card1pos_low, x
  STA $2006           ; write the low byte of $2000 address
  LDA blank, x
  STA $2007        ; set tile.x pos
  INX
  CPX #$36
  BNE drawCardLoop
drawCardDone:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

drawCard2:
  LDA #$00
  LDX #$00
drawCard2Loop:
  LDA card1pos_high, x
  STA $2006           ; write the high byte of $2000 address
  LDA card2pos_low, x
  STA $2006           ; write the low byte of $2000 address
  LDA spade1, x
  STA $2007        ; set tile.x pos
  INX
  CPX #$36
  BNE drawCard2Loop
drawCard2Done:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

drawCard3:
  LDA #$00
  LDX #$00
drawCard3Loop:
  LDA card3pos_high, x
  STA $2006           ; write the high byte of $2000 address
  LDA card3pos_low, x
  STA $2006           ; write the low byte of $2000 address
  LDA diamond11, x
  STA $2007        ; set tile.x pos
  INX
  CPX #$36
  BNE drawCard3Loop
drawCard3Done:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

drawCard4:
  LDA #$00
  LDX #$00
drawCard4Loop:
  LDA card3pos_high, x
  STA $2006           ; write the high byte of $2000 address
  LDA card4pos_low, x
  STA $2006           ; write the low byte of $2000 address
  LDA heart10, x
  STA $2007        ; set tile.x pos
  INX
  CPX #$36
  BNE drawCard4Loop
drawCard4Done:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateSickness:
  LDA $2000 ; read PPU status to reset the high/low latch
  LDA #$21
  STA $2006           ; write the high byte of $2000 address
  LDA #$05
  STA $2006           ; write the low byte of $2000 address
  LDA potion_sickness
  CMP #$01
  BNE updateSicknessFalse
updateSicknessTrue:
  LDA #$3f
  STA $2007  
  JSR updateSicknessDone
updateSicknessFalse:
  LDA #$00
  STA $2007  
updateSicknessDone:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS