
;; deck: Create a deck of 54($36) cards, from zeropage $80

init@deck:                     ; 
  LDA #$35                     ; set deck length
  STA length@deck
  LDX #$00
@loop:                         ; 
  TXA
  STA $80, x                   ; fill the deck with cards(ordered)
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
  ; experiment
  TXA
  SBC #$01
  CMP length@deck              ; TODO only shift cards up to deck length
  BNE @loop
@done:                         ; 
  RTS

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

;; Shuffle

shuffle@deck:                  ; shuffle deck by pushing all cards to $C0 on zero-page
  ; initial shuffle
  LDX #$00
@send0_loop:                   ; 
  LDY shuffle0, x              ; store the value
  LDA $80, y
  STA $C0, x
  INX
  CPX #$36
  BNE @send0_loop
  ; 
  JSR mix@deck
  LDA seed2@deck
  STA seed1@deck
  JSR mix@deck
  RTS

;;

mix@deck:                      ; 
@send0:                        ; 
  LDA seed1@deck
  AND #%00000001
  BEQ @send1
  ; begin
  LDX #$00
@send0_loop:                   ; 
  LDY shuffle0, x              ; store the value
  LDA $80, y
  STA $C0, x
  INX
  CPX #$36
  BNE @send0_loop
  JSR return@deck
  ; end
@send1:                        ; 
  LDA seed1@deck
  AND #%00000010
  BEQ @send2
  ; begin
  LDX #$00
@send1_loop:                   ; 
  LDY shuffle0, x              ; store the value
  LDA $80, y
  STA $C0, x
  INX
  CPX #$36
  BNE @send1_loop
  JSR return@deck
  ; end
@send2:                        ; 
  LDA seed1@deck
  AND #%00000100
  BEQ @send3
  ; begin
  LDX #$00
@send2_loop:                   ; 
  LDY shuffle0, x              ; store the value
  LDA $80, y
  STA $C0, x
  INX
  CPX #$36
  BNE @send2_loop
  JSR return@deck
  ; end
@send3:                        ; 
  LDA seed1@deck
  AND #%00001000
  BEQ @send4
  ; begin
  LDX #$00
@send3_loop:                   ; 
  LDY shuffle0, x              ; store the value
  LDA $80, y
  STA $C0, x
  INX
  CPX #$36
  BNE @send3_loop
  JSR return@deck
  ; end
@send4:                        ; 
  LDA seed1@deck
  AND #%00010000
  BEQ @send5
  ; begin
  LDX #$00
@send4_loop:                   ; 
  LDY shuffle4, x              ; store the value
  LDA $80, y
  STA $C0, x
  INX
  CPX #$36
  BNE @send4_loop
  JSR return@deck
  ; end
@send5:                        ; 
  LDA seed1@deck
  AND #%00100000
  BEQ @send6
  ; begin
  LDX #$00
@send5_loop:                   ; 
  LDY shuffle5, x              ; store the value
  LDA $80, y
  STA $C0, x
  INX
  CPX #$36
  BNE @send5_loop
  JSR return@deck
  ; end
@send6:                        ; 
  LDA seed1@deck
  AND #%01000000
  BEQ @send7
  ; begin
  LDX #$00
@send6_loop:                   ; 
  LDY shuffle6, x              ; store the value
  LDA $80, y
  STA $C0, x
  INX
  CPX #$36
  BNE @send6_loop
  JSR return@deck
  ; end
@send7:                        ; 
  LDA seed1@deck
  AND #%10000000
  BEQ @done
  ; begin
  LDX #$00
@send7_loop:                   ; 
  LDY shuffle7, x              ; store the value
  LDA $80, y
  STA $C0, x
  INX
  CPX #$36
  BNE @send7_loop
  JSR return@deck
  ; end
@done
  RTS

;;

return@deck:                   ; 
  LDX #$00
@loop:                         ; 
  LDA $C0, x                   ; move $C0 to $80
  STA $80, x
  LDA #$00                     ; clear
  STA $C0, x
  INX
  CPX #$36
  BNE @loop
  INC $40
  RTS