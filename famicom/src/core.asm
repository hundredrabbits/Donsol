
;; core

clearBackground:               ; [skip]
  BIT PPUSTATUS                ; reset latch
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00
  LDY #$00
@loop:                         ; 
  LDA #$00                     ; sprite id
  STA PPUDATA
  INY
  CPY #$00
  BNE @loop
  INX
  CPX #$04
  BNE @loop
  RTS

;; Interface

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
@heart:                        ; 
  CMP #$00
  BNE @diamond
  JSR runPotion
  JSR addSickness@player
  RTS
@diamond:                      ; 
  CMP #$01
  BNE @enemies
  JSR runShield
  JSR removeSickness@player
  RTS
@enemies:                      ; 
  JSR runAttack
  JSR removeSickness@player
@done:                         ; 
  RTS

;; turn(potion)

runPotion:                     ; 
  ; check for potion sickness
  LDA sickness@player
  CMP #$01
  BNE @tryWaste
  ; when sick
  LDA #$01                     ; dialog:sickness
  JSR show@dialog
  RTS
@tryWaste:                     ; 
  LDA hp@player
  CMP #$15
  BNE @heal
  ; when already full health
  LDA #$07                     ; dialog:potion
  JSR show@dialog
  RTS
@heal:                         ; 
  LDA hp@player
  CLC
  ADC card_last_value
  STA hp@player
  ; specials
  JSR clampHealth
  LDA #$06                     ; dialog:potion
  JSR show@dialog
  RTS

;; turn(shield)

runShield:                     ; 
  LDA card_last_value
  STA sp@player
  LDA #$16                     ; max durability is $15+1
  STA dp@player
  LDA #$05                     ; dialog: shield
  JSR show@dialog
  RTS

;; turn(attack)

runAttack:                     ; 
  ; check if can block
  LDA sp@player
  CMP #$00
  BNE @blocking
  LDA #$08                     ; dialog:unshielded
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
  LDA #$02                     ; dialog:shield break
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
  LDA #$0B                     ; dialog:damages
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
  LDA #$0A                     ; dialog:blocked
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
  LDA #$03                     ; dialog:death
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