
;; Tests

run@tests:                     ; 
  LDA #$43
  STA count@test
  JSR potion@tests
  JSR sickness@tests
  JSR shield@tests
  JSR attack@tests
  JSR testAttackDeath
  JSR testAttackShieldBlock
  JSR testAttackShieldOverflow
  JSR testAttackShieldOverflowDeath
  JSR testAttackShieldBreak
  JSR testAttackShieldBreakDeath
  ; JSR testComplete
  ; JSR testCanRun
  ; JSR testCannotRun
  JSR reset@player
  RTS

;;

pass@tests:                    ; 
  LDA $2000                    ; read PPU status to reset the high/low latch
  LDA #$20
  STA PPUADDR                  ; write the high byte
  LDA count@test
  STA PPUADDR                  ; write the low byte
  LDA #$6A
  STA PPUDATA
  LDA #$00                     ; No background scrolling
  STA PPUSCROLL
  STA PPUSCROLL
  INC count@test
  RTS

;;

fail@tests:                    ; 
  LDX count@test
  LDA $2000                    ; read PPU status to reset the high/low latch
  LDA #$20
  STA PPUADDR                  ; write the high byte
  LDA count@test
  STA PPUADDR                  ; write the low byte
  LDA #$6B
  STA PPUDATA
  LDA #$00                     ; No background scrolling
  STA PPUSCROLL
  STA PPUSCROLL
  INC count@test
  RTS

;; Drink 3hp | Shield is 0sp | Health is 21hp

potion@tests:                  ; 
  JSR reset@player
  ; take some dammage
  LDA #$10
  STA health@player
  ; pick
  LDY #$02                     ; Hearts 3
  JSR pickCard
  ; test health
  LDA health@player
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
  STA health@player
  ; drink two potions
  LDY #$04                     ; Hearts 5
  JSR pickCard
  LDY #$05                     ; Hearts 6
  JSR pickCard
  ; test health
  LDA health@player
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
  JSR pickCard
  ; test health
  LDA shield@player
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
  JSR pickCard
  ; test health
  LDA health@player
  CMP #$0F                     ; shield = $0f(15)
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS

;; Attack 6ap | Loose 6hp | Shield is 0sp | Health is 0hp

testAttackDeath:               ; 
  JSR reset@player
  ; Lower health
  LDA #$04
  STA health@player
  ; pick
  LDY #$1F                     ; Spades 6
  JSR pickCard
  ; test health
  LDA health@player
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
  JSR pickCard
  LDY #$1D                     ; Spades 4
  JSR pickCard
  ; loose 3hp
  LDA health@player
  CMP #$15
  BNE @fail
  ; shield durability 6
  LDA durability@player
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
  JSR pickCard
  LDY #$1F                     ; Spades 6
  JSR pickCard
  ; loose 3hp
  LDA health@player
  CMP #$12
  BNE @fail
  ; shield durability 6
  LDA durability@player
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
  STA health@player
  ; pick
  LDY #$0F                     ; Diamond 3
  JSR pickCard
  LDY #$1F                     ; Spades 6
  JSR pickCard
  ; loose 3hp
  LDA health@player
  CMP #$00
  BNE @fail
  ; shield durability 6
  LDA durability@player
  CMP #$06
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS

;; Equip 4sp | Attack 3ap | Loose 0hp | Attack 4ap | Shield breaks | Loose 4hp | Shield is 0dp | Health is 17hp

testAttackShieldBreak:         ; 
  JSR reset@player
  ; pick
  LDY #$10                     ; Diamond 4
  JSR pickCard
  LDY #$1C                     ; Spades 3
  JSR pickCard
  LDY #$1D                     ; Spades 4
  JSR pickCard
  ; loose 4hp
  LDA health@player
  CMP #$11
  BNE @fail
  ; shield durability 0
  LDA durability@player
  CMP #$00
  BNE @fail
  ; shield 0
  LDA shield@player
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
  STA health@player
  ; pick
  LDY #$10                     ; Diamond 4
  JSR pickCard
  LDY #$1C                     ; Spades 3
  JSR pickCard
  LDY #$1D                     ; Spades 4
  JSR pickCard
  ; loose 4hp
  LDA health@player
  CMP #$00
  BNE @fail
  ; shield durability 0
  LDA durability@player
  CMP #$00
  BNE @fail
  ; shield 0
  LDA shield@player
  CMP #$00
  BNE @fail
  ; pass
  JSR pass@tests
  RTS
@fail:                         ; 
  JSR fail@tests
  RTS