
;; Tests

run@tests:                     ; [skip]
  LDA #$43
  STA count@tests
  JSR potion@tests
  JSR sickness@tests
  JSR shield@tests
  JSR attack@tests
  JSR death@tests
  JSR testAttackShieldBlock
  JSR testAttackShieldOverflow
  JSR testAttackShieldOverflowDeath
  JSR break@tests
  JSR testAttackShieldBreakDeath
  JSR reset@player
  RTS

;;

pass@tests:                    ; 
  BIT PPUSTATUS                ; read PPU status to reset the high/low latch
  LDA #$20
  STA PPUADDR                  ; write the high byte
  LDA count@tests
  STA PPUADDR                  ; write the low byte
  LDA #$6A
  STA PPUDATA
  LDA #$00                     ; No background scrolling
  STA PPUSCROLL
  STA PPUSCROLL
  INC count@tests
  RTS

;;

fail@tests:                    ; 
  LDX count@tests
  BIT PPUSTATUS                ; read PPU status to reset the high/low latch
  LDA #$20
  STA PPUADDR                  ; write the high byte
  LDA count@tests
  STA PPUADDR                  ; write the low byte
  LDA #$6B
  STA PPUDATA
  LDA #$00                     ; No background scrolling
  STA PPUSCROLL
  STA PPUSCROLL
  INC count@tests
  RTS

;; Drink 3hp | Shield is 0sp | Health is 21hp

potion@tests:                  ; 
  JSR reset@player
  ; take some dammage
  LDA #$10
  STA hp@player
  ; pick
  LDY #$02                     ; Hearts 3
  JSR pickCard@deck
  ; test health
  LDA hp@player
  CMP #$13                     ; health = $13(18)
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS

;; Drink 5hp | Drink 6hp | Shield is 0sp | Health is 9hp

sickness@tests:                ; 
  JSR reset@player
  ; take some dammage
  LDA #$04
  STA hp@player
  ; drink two potions
  LDY #$04                     ; Hearts 5
  JSR pickCard@deck
  LDY #$05                     ; Hearts 6
  JSR pickCard@deck
  ; test health
  LDA hp@player
  CMP #$09                     ; health = $09(09)[4hp + 5hp]
  BNE @fail
  ; test sickness
  LDA sickness@player
  CMP #$01                     ; sickness = true
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS

;; Equip 2sp | Shield is 2sp | Health is 21hp

shield@tests:                  ; 
  JSR reset@player
  ; pick
  LDY #$0E                     ; Diamonds 2
  JSR pickCard@deck
  ; test health
  LDA sp@player
  CMP #$02                     ; shield = $02(02)
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS

;; Attack 6ap | Loose 6hp | Shield is 0sp | Health is 15hp

attack@tests:                  ; 
  JSR reset@player
  ; pick
  LDY #$1F                     ; Spades 6
  JSR pickCard@deck
  ; test health
  LDA hp@player
  CMP #$0F                     ; shield = $0f(15)
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS

;; Attack 6ap | Loose 6hp | Shield is 0sp | Health is 0hp

death@tests:                   ; 
  JSR reset@player
  ; Lower health
  LDA #$04
  STA hp@player
  ; pick
  LDY #$1F                     ; Spades 6
  JSR pickCard@deck
  ; test health
  LDA hp@player
  CMP #$00                     ; health = $00(00)
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS

;; Equip 6sp | Attack 4ap | Loose 0hp | Shield is 6dp | Health is 18hp

testAttackShieldBlock:         ; 
  JSR reset@player
  ; pick
  LDY #$12                     ; Diamond 6
  JSR pickCard@deck
  LDY #$1D                     ; Spades 4
  JSR pickCard@deck
  ; loose 3hp
  LDA hp@player
  CMP #$15
  BNE @fail
  ; shield durability 6
  LDA dp@player
  CMP #$04
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS

;; Equip 3sp | Attack 6ap | Loose 3hp | Shield is 6dp | Health is 18hp

testAttackShieldOverflow:      ; 
  JSR reset@player
  ; pick
  LDY #$0F                     ; Diamond 3
  JSR pickCard@deck
  LDY #$1F                     ; Spades 6
  JSR pickCard@deck
  ; loose 3hp
  LDA hp@player
  CMP #$12
  BNE @fail
  ; shield durability 6
  LDA dp@player
  CMP #$06
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS

;; Equip 3sp | Attack 6ap | Loose 3hp | Shield is 6dp | Health is 18hp

testAttackShieldOverflowDeath: ; 
  JSR reset@player
  ; Lower health
  LDA #$02
  STA hp@player
  ; pick
  LDY #$0F                     ; Diamond 3
  JSR pickCard@deck
  LDY #$1F                     ; Spades 6
  JSR pickCard@deck
  ; loose 3hp
  LDA hp@player
  CMP #$00
  BNE @fail
  ; shield durability 6
  LDA dp@player
  CMP #$06
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS

;; Equip 4sp | Attack 3ap | Loose 0hp | Attack 4ap | Shield breaks | Loose 4hp | Shield is 0dp | Health is 17hp

break@tests:                   ; 
  JSR reset@player
  ; pick
  LDY #$10                     ; Diamond 4
  JSR pickCard@deck
  LDY #$1C                     ; Spades 3
  JSR pickCard@deck
  LDY #$1D                     ; Spades 4
  JSR pickCard@deck
  ; loose 4hp
  LDA hp@player
  CMP #$11
  BNE @fail
  ; shield durability 0
  LDA dp@player
  CMP #$00
  BNE @fail
  ; shield 0
  LDA sp@player
  CMP #$00
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS

;; Equip 4sp | Attack 3ap | Loose 0hp | Attack 4ap | Shield breaks | Loose 4hp | Shield is 0dp | Health is 17hp

testAttackShieldBreakDeath:    ; 
  JSR reset@player
  ; Lower health
  LDA #$02
  STA hp@player
  ; pick
  LDY #$10                     ; Diamond 4
  JSR pickCard@deck
  LDY #$1C                     ; Spades 3
  JSR pickCard@deck
  LDY #$1D                     ; Spades 4
  JSR pickCard@deck
  ; loose 4hp
  LDA hp@player
  CMP #$00
  BNE @fail
  ; shield durability 0
  LDA dp@player
  CMP #$00
  BNE @fail
  ; shield 0
  LDA sp@player
  CMP #$00
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS