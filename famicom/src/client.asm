;; client

; request redraws

requestUpdateStats:
  LDA #$01
  STA reqdraw_hp
  LDA #$01
  STA reqdraw_sp
  LDA #$01
  STA reqdraw_xp
  RTS

; check for updates required

updateClient:

checkReqCursor:
  LDA reqdraw_cursor
  CMP #$00
  BEQ checkReqCard1

  JSR updateCursor
  LDA #$00
  STA reqdraw_cursor
  INC reqdraws
  RTS

checkReqCard1:
  LDA reqdraw_card1
  CMP #$00
  BEQ checkReqCard2

  JSR updateCard1
  LDA #$00
  STA reqdraw_card1
  INC reqdraws
  RTS

checkReqCard2:
  LDA reqdraw_card2
  CMP #$00
  BEQ checkReqCard3

  JSR updateCard2
  LDA #$00
  STA reqdraw_card2
  INC reqdraws
  RTS

checkReqCard3:
  LDA reqdraw_card3
  CMP #$00
  BEQ checkReqCard4

  JSR updateCard3
  LDA #$00
  STA reqdraw_card3
  INC reqdraws
  RTS

checkReqCard4:
  LDA reqdraw_card4
  CMP #$00
  BEQ checkReqHP

  JSR updateCard4
  LDA #$00
  STA reqdraw_card4
  INC reqdraws
  RTS

checkReqHP:
  LDA reqdraw_hp
  CMP #$00
  BEQ checkReqSP

  JSR updateHealth
  JSR updateHealthBar
  LDA #$00
  STA reqdraw_hp
  INC reqdraws
  RTS

checkReqSP:
  LDA reqdraw_sp
  CMP #$00
  BEQ checkReqXP

  JSR updateShield
  JSR updateShieldBar
  LDA #$00
  STA reqdraw_sp
  INC reqdraws
  RTS

checkReqXP:
  LDA reqdraw_xp
  CMP #$00
  BEQ updateClientDone

  JSR updateExperience
  JSR updateExperienceBar
  LDA #$00
  STA reqdraw_xp
  INC reqdraws
  RTS

updateClientDone:
  RTS

; actual update code

updateCursor:
  LDX ui_selection
  LDA cursor_positions, x
  STA $0203        ; set tile.x pos
  CLC
  ADC #$08
  STA $0207        ; set tile.x pos
  RTS

updateHealth:
  LDA $2000 ; read PPU status to reset the high/low latch
  LDX #$00  ; Not quite sure why this is needed, but breaks otherwise
updateHealthDigit1:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$07
  STA $2006 ; write the low byte of $2000 address
  LDX health
  LDA number_high, x
  STA $2007
updateHealthDigit2:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$08
  STA $2006 ; write the low byte of $2000 address
  LDX health
  LDA number_low, x
  STA $2007
updateHealthFix:
  LDA #$00         ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateHealthBar:
  LDX #$00
  LDY health
  LDA healthbarpos, y ; regA has sprite offset
  TAY                 ; regY has sprite offset
updateHealthBarLoop:
  LDA #$20
  STA $2006           ; write the high byte of $2000 address
  LDA healthbaroffset, x
  STA $2006           ; write the low byte of $2000 address
  LDA progressbar, y    ; regA has sprite id
  INY
  STA $2007
  INX
  CPX #$06
  BNE updateHealthBarLoop
updateHealthBarDone:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateShield:
  LDA $2000 ; read PPU status to reset the high/low latch
  LDX #$00  ; Not quite sure why this is needed, but breaks otherwise
updateShieldDigit1:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$0e
  STA $2006 ; write the low byte of $2000 address
  LDX shield
  LDA number_high, x
  STA $2007
updateShieldDigit2:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$0f
  STA $2006 ; write the low byte of $2000 address
  LDX shield
  LDA number_low, x
  STA $2007
updateShieldDurabilityDigit1:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$0c
  STA $2006 ; write the low byte of $2000 address
  LDX shield_durability
  LDA card_glyphs, x
  STA $2007
updateShieldFix:
  LDA #$00         ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateShieldBar:
  LDX #$00
  LDY shield
  LDA shieldbarpos, y ; regA has sprite offset
  TAY                 ; regY has sprite offset
updateShieldBarLoop:
  LDA #$20
  STA $2006           ; write the high byte of $2000 address
  LDA shieldbaroffset, x
  STA $2006           ; write the low byte of $2000 address
  LDA progressbar, y    ; regA has sprite id
  INY
  STA $2007
  INX
  CPX #$06
  BNE updateShieldBarLoop
updateShieldBarDone:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateExperience:
  LDA $2000 ; read PPU status to reset the high/low latch
  LDX #$00  ; Not quite sure why this is needed, but breaks otherwise
updateExperienceDigit1:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$15
  STA $2006 ; write the low byte of $2000 address
  LDX experience
  LDA number_high, x
  STA $2007
updateExperienceDigit2:
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$16
  STA $2006 ; write the low byte of $2000 address
  LDX experience
  LDA number_low, x
  STA $2007
updateExperienceFix:
  LDA #$00         ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateExperienceBar:
  LDX #$00
  LDY experience
  LDA experiencebarpos, y ; regA has sprite offset
  TAY                 ; regY has sprite offset
updateExperienceBarLoop:
  LDA #$20
  STA $2006           ; write the high byte of $2000 address
  LDA experiencebaroffset, x
  STA $2006           ; write the low byte of $2000 address
  LDA progressbar, y    ; regA has sprite id
  INY
  STA $2007
  INX
  CPX #$06
  BNE updateExperienceBarLoop
updateExperienceBarDone:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateStats:
  JSR updateHealth
  JSR updateHealthBar
  JSR updateShield
  JSR updateShieldBar
  JSR updateExperience
  JSR updateExperienceBar
  RTS

; to merge into a single routine

updateCard1:
  LDA #$00
  LDX #$00
drawCardLoop:
  LDA card1pos_high, x
  STA $2006           ; write the high byte of $2000 address
  LDA card1pos_low, x
  STA $2006           ; write the low byte of $2000 address
  LDA blank, x
  STA $2007        ; set tile.x pos
  INX
  CPX #$36
  BNE drawCardLoop
drawCardDone:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateCard2:
  LDA #$00
  LDX #$00
drawCard2Loop:
  LDA card1pos_high, x
  STA $2006           ; write the high byte of $2000 address
  LDA card2pos_low, x
  STA $2006           ; write the low byte of $2000 address
  LDA spade1, x
  STA $2007        ; set tile.x pos
  INX
  CPX #$36
  BNE drawCard2Loop
drawCard2Done:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateCard3:
  LDA #$00
  LDX #$00
drawCard3Loop:
  LDA card3pos_high, x
  STA $2006           ; write the high byte of $2000 address
  LDA card3pos_low, x
  STA $2006           ; write the low byte of $2000 address
  LDA diamond11, x
  STA $2007        ; set tile.x pos
  INX
  CPX #$36
  BNE drawCard3Loop
drawCard3Done:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateCard4:
  LDA #$00
  LDX #$00
drawCard4Loop:
  LDA card3pos_high, x
  STA $2006           ; write the high byte of $2000 address
  LDA card4pos_low, x
  STA $2006           ; write the low byte of $2000 address
  LDA heart10, x
  STA $2007        ; set tile.x pos
  INX
  CPX #$36
  BNE drawCard4Loop
drawCard4Done:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

updateSickness:
  LDA $2000 ; read PPU status to reset the high/low latch
  LDA #$21
  STA $2006           ; write the high byte of $2000 address
  LDA #$05
  STA $2006           ; write the low byte of $2000 address
  LDA potion_sickness
  CMP #$01
  BNE updateSicknessFalse
updateSicknessTrue:
  LDA #$3f
  STA $2007  
  JSR updateSicknessDone
updateSicknessFalse:
  LDA #$00
  STA $2007  
updateSicknessDone:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS