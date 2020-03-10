
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
@heart:
  CMP #$00
  BNE selectCardHeart
  JSR runPotion
  JSR add_sick@player
  RTS
@diamond:
  CMP #$01
  BNE @spade
  JSR runShield
  JSR remove_sick@player
  RTS
@else:
  CMP #$02
  BEQ selectCardSpadeCloverJoker
  CMP #$03
  BEQ selectCardSpadeCloverJoker
  CMP #$04
  BEQ selectCardSpadeCloverJoker
@none:                         ; 
  RTS

;; selection

selectCardDiamond:             ; 
  
  RTS
selectCardSpadeCloverJoker:    ; 
  JSR runAttack
  JSR remove_sick@player
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
  JSR show@dialog
  RTS

;; turn(potion-sickness)

runPotionSickness:             ; 
  ; dialog:sickness
  LDA #$01
  JSR show@dialog
  RTS

;; turn(potion-waste)

runPotionWaste:                ; 
  ; dialog:potion
  LDA #$07
  JSR show@dialog
  RTS

;; turn(shield)

runShield:                     ; 
  LDA card_last_value
  STA sp@player
  LDA #$16                     ; max durability is $15+1
  STA dp@player
  ; dialog
  LDA #$05
  JSR show@dialog
  RTS

;; turn(attack)

runAttack:                     ; 
  ; check if can block
  LDA sp@player
  CMP #$00
  BNE @blocking
  ; dialog:unshielded
  LDA #$08
  JSR show@dialog
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
  JSR show@dialog
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
  JSR show@dialog
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
  JSR show@dialog
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
  JSR show@dialog
  RTS                          ; stop attack phase
@survive:                      ; 
  LDA hp@player
  SEC
  SBC damages@player
  STA hp@player
  RTS

;; flags

clampHealth:                   ; 
  LDA hp@player
  CMP #$15
  BCC @done
  LDA #$15
  STA hp@player
@done:                         ; 
  RTS