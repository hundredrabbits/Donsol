
resetStats:
  LDA #$15
  STA health_max
  LDA health_max
  STA health
  LDA #$00
  STA shield
  STA experience
  STA is_dead
  STA potion_sickness
  LDA #$01
  STA can_run
  RTS

runTests:
  LDA #$83
  STA test_id

  JSR testPotion
  JSR testSickness
  JSR testShield
  JSR testAttack
  JSR testDeath
  JSR resetStats
  RTS

testPass:
  LDA $2000           ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006           ; write the high byte of $2000 address
  LDA test_id
  STA $2006           ; write the low byte of $2000 address
  LDA #$a2
  STA $2007  
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  INC test_id
  RTS

testFail:
  LDX test_id
  LDA $2000           ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006           ; write the high byte of $2000 address
  LDA test_id
  STA $2006           ; write the low byte of $2000 address
  LDA #$a3
  STA $2007  
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  INC test_id
  RTS

; health test

testPotion:
  JSR resetStats
  ; take some dammage
  LDA #$10
  STA health
  ; pick
  LDY #$02            ; Hearts 3
  JSR pickCard
  ; test health
  LDA health
  CMP #$13            ; health = $13(18)
  BNE testPotionFail
  ; pass
testPotionPass:
  JSR testPass
  RTS
testPotionFail:
  JSR testFail
  RTS

testSickness:
  JSR resetStats
  ; take some dammage
  LDA #$04
  STA health
  ; drink two potions
  LDY #$04            ; Hearts 5
  JSR pickCard
  LDY #$05            ; Hearts 6
  JSR pickCard
  ; test health
  LDA health
  CMP #$09            ; health = $09(09)[4hp + 5hp]
  BNE testSicknessFail
  ; test sickness
  LDA potion_sickness
  CMP #$01            ; sickness = true
  BNE testSicknessFail
  ; pass
testSicknessPass:
  JSR testPass
  RTS
testSicknessFail:
  JSR testFail
  RTS

; shield

testShield:
  JSR resetStats
  ; pick
  LDY #$0e            ; Diamonds 2
  JSR pickCard
  ; test health
  LDA shield
  CMP #$02            ; shield = $02(02)
  BNE testShieldFail
  ; pass
testShieldPass:
  JSR testPass
  RTS
testShieldFail:
  JSR testFail
  RTS

; attack

testAttack:
  JSR resetStats
  ; pick
  LDY #$1f            ; Spades 6
  JSR pickCard
  ; test health
  LDA health
  CMP #$0f            ; shield = $0f(15)
  BNE testAttackFail
  ; pass
testAttackPass:
  JSR testPass
  RTS
testAttackFail:
  JSR testFail
  RTS

; death

testDeath:
  JSR resetStats
  ; Lower health
  LDA #$04
  STA health
  ; pick
  LDY #$1f            ; Spades 6
  JSR pickCard
  ; test health
  LDA health
  CMP #$00            ; health = $00(00)
  BNE testDeathFail
  ; test death flag
  LDA is_dead
  CMP #$01            ; health = $00(00)
  BNE testDeathFail
  ; pass
testDeathPass:
  JSR testPass
  RTS
testDeathFail:
  JSR testFail
  RTS