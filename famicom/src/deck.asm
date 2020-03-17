
;; deck: Create a deck of 54($36) cards, from zeropage $80

init@deck:                     ; 
  ; set deck length
  LDA #$35
  STA length@deck
  LDX #$00
@loop:                         ; 
  TXA
  STA $80, x
  INX
  CPX #$36
  BNE @loop
  RTS

;; take last card from the deck

pullCard@deck:                 ; 
  LDA length@deck
  CMP #$00
  BEQ @finished
  ; when cards are left
  LDA $80
  STA hand@deck
  JSR shift@deck
  RTS
@finished:                     ; 
  ; when reached the end
  LDA #$36
  STA hand@deck
  RTS

;; return card to deck

returnCard@deck:               ; (a:card_id)
  LDX length@deck
  INX
  STA $80, x
  INC length@deck
  RTS

;; Shift deck forward by 1

shift@deck:                    ; 
  DEC length@deck
  LDX #$00
@loop:                         ; 
  TXA
  TAY
  INY
  LDA $80, y
  STA $80, x
  INX
  CPX #$36                     ; TODO only shift cards up to deck length
  BNE @loop
@done:                         ; 
  RTS

;; Shuffle

shuffle@deck:                  ; 
  LDX #$00
@loop:                         ; 
  LDA shuffleA, x
  STA $80, x
  INX
  CPX #$36
  BNE @loop
  RTS

;;

;; Pick card from the deck

pickCard@deck:                 ; (y:card_id)
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
  JSR pickPotion@deck
  JSR addSickness@player
  RTS
@diamond:                      ; 
  CMP #$01
  BNE @enemies
  JSR pickShield@deck
  JSR removeSickness@player
  RTS
@enemies:                      ; 
  JSR pickEnemy@deck
  JSR removeSickness@player
@done:                         ; 
  RTS

;; turn(potion)

pickPotion@deck:               ; 
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
  JSR clampHealth@player
  LDA #$06                     ; dialog:potion
  JSR show@dialog
  RTS

;; turn(shield)

pickShield@deck:               ; 
  LDA card_last_value
  STA sp@player
  LDA #$16                     ; max durability is $15+1
  STA dp@player
  LDA #$05                     ; dialog: shield
  JSR show@dialog
  RTS

;; turn(attack)

pickEnemy@deck:                ; 
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

;;

hack@deck:                     ; 
  ; $03,$10,$18,$23,$32,$0f,$06,$2a,$1e,$0b,$34
  ; hand
  LDA #$03
  STA $80
  LDA #$10
  STA $81
  LDA #$18
  STA $82
  LDA #$23
  STA $83
  ; room 2
  LDA #$1E
  STA $84
  LDA #$15
  STA $85
  LDA #$34
  STA $86
  ; room 3
  LDA #$00
  STA $87
  STA $88
  STA $89
  STA $8a
  STA $8b
  ; trim deck
  LDA #$07
  STA length@deck
  RTS