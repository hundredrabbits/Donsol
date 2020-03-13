
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

pull@deck:                     ; 
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

return@deck:                   ; (a:card_id)
  LDX length@deck
  INX
  STA $80,x
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
  CPX #$36
  BNE @loop
@done
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