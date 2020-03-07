
;; Tests

runTests:                      ; 
  LDA #$43
  STA test_id
  JSR testPotion
  JSR testSickness
  JSR testShield
  JSR testAttack
  JSR testAttackDeath
  JSR testAttackShieldBlock
  JSR testAttackShieldOverflow
  JSR testAttackShieldOverflowDeath
  JSR testAttackShieldBreak
  JSR testAttackShieldBreakDeath
  ; JSR testComplete
  ; JSR testCanRun
  ; JSR testCannotRun
  JSR resetStats
  RTS
testPass:                      ; 
  LDA $2000                    ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006                    ; write the high byte of $2000 address
  LDA test_id
  STA $2006                    ; write the low byte of $2000 address
  LDA #$6A
  STA $2007
  LDA #$00                     ; No background scrolling
  STA $2005
  STA $2005
  INC test_id
  RTS
testFail:                      ; 
  LDX test_id
  LDA $2000                    ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006                    ; write the high byte of $2000 address
  LDA test_id
  STA $2006                    ; write the low byte of $2000 address
  LDA #$6B
  STA $2007
  LDA #$00                     ; No background scrolling
  STA $2005
  STA $2005
  INC test_id
  RTS

;; Drink 3hp | Shield is 0sp | Health is 21hp

testPotion:                    ; 
  JSR resetStats
  ; take some dammage
  LDA #$10
  STA health
  ; pick
  LDY #$02                     ; Hearts 3
  JSR pickCard
  ; test health
  LDA health
  CMP #$13                     ; health = $13(18)
  BNE testPotionFail
  ; pass
testPotionPass:                ; 
  JSR testPass
  RTS
testPotionFail:                ; 
  JSR testFail
  RTS

;; Drink 5hp | Drink 6hp | Shield is 0sp | Health is 9hp

testSickness:                  ; 
  JSR resetStats
  ; take some dammage
  LDA #$04
  STA health
  ; drink two potions
  LDY #$04                     ; Hearts 5
  JSR pickCard
  LDY #$05                     ; Hearts 6
  JSR pickCard
  ; test health
  LDA health
  CMP #$09                     ; health = $09(09)[4hp + 5hp]
  BNE testSicknessFail
  ; test sickness
  LDA potion_sickness
  CMP #$01                     ; sickness = true
  BNE testSicknessFail
  ; pass
testSicknessPass:              ; 
  JSR testPass
  RTS
testSicknessFail:              ; 
  JSR testFail
  RTS

;; Equip 2sp | Shield is 2sp | Health is 21hp

testShield:                    ; 
  JSR resetStats
  ; pick
  LDY #$0E                     ; Diamonds 2
  JSR pickCard
  ; test health
  LDA shield
  CMP #$02                     ; shield = $02(02)
  BNE testShieldFail
  ; pass
testShieldPass:                ; 
  JSR testPass
  RTS
testShieldFail:                ; 
  JSR testFail
  RTS

;; Attack 6ap | Loose 6hp | Shield is 0sp | Health is 15hp

testAttack:                    ; 
  JSR resetStats
  ; pick
  LDY #$1F                     ; Spades 6
  JSR pickCard
  ; test health
  LDA health
  CMP #$0F                     ; shield = $0f(15)
  BNE testAttackFail
  ; pass
testAttackPass:                ; 
  JSR testPass
  RTS
testAttackFail:                ; 
  JSR testFail
  RTS

;; Attack 6ap | Loose 6hp | Shield is 0sp | Health is 0hp

testAttackDeath:               ; 
  JSR resetStats
  ; Lower health
  LDA #$04
  STA health
  ; pick
  LDY #$1F                     ; Spades 6
  JSR pickCard
  ; test health
  LDA health
  CMP #$00                     ; health = $00(00)
  BNE testAttackDeathFail
  ; pass
testAttackDeathPass:           ; 
  JSR testPass
  RTS
testAttackDeathFail:           ; 
  JSR testFail
  RTS

;; Equip 6sp | Attack 4ap | Loose 0hp | Shield is 6dp | Health is 18hp

testAttackShieldBlock:         ; 
  JSR resetStats
  ; pick
  LDY #$12                     ; Diamond 6
  JSR pickCard
  LDY #$1D                     ; Spades 4
  JSR pickCard
  ; loose 3hp
  LDA health
  CMP #$15
  BNE testAttackShieldBlockFail
  ; shield durability 6
  LDA shield_durability
  CMP #$04
  BNE testAttackShieldBlockFail
  ; pass
testAttackShieldBlockedPass:   ; 
  JSR testPass
  RTS
testAttackShieldBlockFail:     ; 
  JSR testFail
  RTS

;; Equip 3sp | Attack 6ap | Loose 3hp | Shield is 6dp | Health is 18hp

testAttackShieldOverflow:      ; 
  JSR resetStats
  ; pick
  LDY #$0F                     ; Diamond 3
  JSR pickCard
  LDY #$1F                     ; Spades 6
  JSR pickCard
  ; loose 3hp
  LDA health
  CMP #$12
  BNE testAttackShieldOverflowFail
  ; shield durability 6
  LDA shield_durability
  CMP #$06
  BNE testAttackShieldOverflowFail
  ; pass
testAttackShieldOverflowPass:  ; 
  JSR testPass
  RTS
testAttackShieldOverflowFail:  ; 
  JSR testFail
  RTS

;; Equip 3sp | Attack 6ap | Loose 3hp | Shield is 6dp | Health is 18hp

testAttackShieldOverflowDeath: ; 
  JSR resetStats
  ; Lower health
  LDA #$02
  STA health
  ; pick
  LDY #$0F                     ; Diamond 3
  JSR pickCard
  LDY #$1F                     ; Spades 6
  JSR pickCard
  ; loose 3hp
  LDA health
  CMP #$00
  BNE testAttackShieldOverflowDeathFail
  ; shield durability 6
  LDA shield_durability
  CMP #$06
  BNE testAttackShieldOverflowDeathFail
  ; pass
testAttackShieldOverflowDeathPass:; 
  JSR testPass
  RTS
testAttackShieldOverflowDeathFail:; 
  JSR testFail
  RTS

;; Equip 4sp | Attack 3ap | Loose 0hp | Attack 4ap | Shield breaks | Loose 4hp | Shield is 0dp | Health is 17hp

testAttackShieldBreak:         ; 
  JSR resetStats
  ; pick
  LDY #$10                     ; Diamond 4
  JSR pickCard
  LDY #$1C                     ; Spades 3
  JSR pickCard
  LDY #$1D                     ; Spades 4
  JSR pickCard
  ; loose 4hp
  LDA health
  CMP #$11
  BNE testAttackShieldBreakFail
  ; shield durability 0
  LDA shield_durability
  CMP #$00
  BNE testAttackShieldBreakFail
  ; shield 0
  LDA shield
  CMP #$00
  BNE testAttackShieldBreakFail
  ; pass
testAttackShieldBreakPass:     ; 
  JSR testPass
  RTS
testAttackShieldBreakFail:     ; 
  JSR testFail
  RTS

;; Equip 4sp | Attack 3ap | Loose 0hp | Attack 4ap | Shield breaks | Loose 4hp | Shield is 0dp | Health is 17hp

testAttackShieldBreakDeath:    ; 
  JSR resetStats
  ; Lower health
  LDA #$02
  STA health
  ; pick
  LDY #$10                     ; Diamond 4
  JSR pickCard
  LDY #$1C                     ; Spades 3
  JSR pickCard
  LDY #$1D                     ; Spades 4
  JSR pickCard
  ; loose 4hp
  LDA health
  CMP #$00
  BNE testAttackShieldBreakDeathFail
  ; shield durability 0
  LDA shield_durability
  CMP #$00
  BNE testAttackShieldBreakDeathFail
  ; shield 0
  LDA shield
  CMP #$00
  BNE testAttackShieldBreakDeathFail
  ; pass
testAttackShieldBreakDeathPass:; 
  JSR testPass
  RTS
testAttackShieldBreakDeathFail:; 
  JSR testFail
  RTS