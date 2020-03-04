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
  STA cursor_pos
  LDA #$01
  STA can_run 
  ; tests
  ;JSR runTests

  ; table

  LDX #$00
  LDY #$13            ; Diamonds 7
  JSR drawCard
  LDX #$01
  LDY #$24            ; Spades 11
  JSR drawCard
  LDX #$02
  LDY #$02            ; Hearts 3
  JSR drawCard
  LDX #$03
  LDY #$2b            ; Clubs 5
  JSR drawCard

  ;

  JSR requestUpdateStats
  JSR requestUpdateCursor
  JSR requestUpdateCards

  ;

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
  LDX cursor_pos
  JSR flipCard
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
  JSR drawNextRoom
ReadSelDone:        ; handling this button is done

ReadStart: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadStartDone 
  JSR drawNextRoom
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
  JSR moveCursorLeft ; record press
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
  JSR moveCursorRight ; record press
  LDA #$01
  STA arrow_right_pressed 
  JMP ReadRightDone
ReadRightRelease: ; record release
  LDA #$00
  STA arrow_right_pressed 
ReadRightDone:

  RTI             ; return from interrupt

; selection

moveCursorRight:
  LDA cursor_pos
  CMP #$03
  BEQ selectNextAround
  INC cursor_pos
  JMP selectNextDone
selectNextAround:
  LDA #$00
  STA cursor_pos
selectNextDone:
  LDA #$01
  STA reqdraw_cursor
  RTS

moveCursorLeft:
  LDA cursor_pos
  CMP #$00
  BEQ selectPrevAround
  DEC cursor_pos
  JMP selectPrevDone
selectPrevAround:
  LDA #$03
  STA cursor_pos
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
  LDA #$01            ; Request update
  STA reqdraw_card1, x
  RTS

; flip card from the table

flipCard:
  ; Card table pos, must be in Xreg
  LDA card1, x        ; get card id from table
  TAY 
  JSR pickCard
  ; flip card
  LDA #$36            ; $36 is flipped
  STA card1, x
  LDA #$01            ; Request update
  STA reqdraw_card1, x
  ; misc
  INC experience
  JSR requestUpdateStats
  RTS

; Pick card from the deck

pickCard: 
  ; Card deck id must be in Yreg
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
  BEQ selectCardClover
  CMP #$04
  BEQ selectCardJoker
pickCardDone:
  RTS

selectCardHeart:
  JSR runPotion
  JSR addPotionSickness
  ; JSR flipCard
  RTS

selectCardDiamond:
  JSR runShield
  JSR removePotionSickness
  ; JSR flipCard
  RTS

selectCardSpade:
  JSR runAttack
  JSR removePotionSickness
  ; JSR flipCard
  RTS

selectCardClover:
  JSR runAttack
  JSR removePotionSickness
  ; JSR flipCard
  RTS

selectCardJoker:
  JSR runAttack
  JSR removePotionSickness
  ; JSR flipCard
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
  LDA #$2d   ; clover 7
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



; TODO

drawNextRoom:

  LDX #$00
  LDY #$1d            ; Spades 8
  JSR drawCard

  LDX #$01
  LDY #$14            ; Diamonds 8
  JSR drawCard

  LDX #$02
  LDY #$34            ; Hearts 4
  JSR drawCard

  LDX #$03
  LDY #$08            ; Clubs 5
  JSR drawCard

  RTS