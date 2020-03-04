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

requestUpdateCursor:
  LDA #$01
  STA reqdraw_cursor
  RTS

requestUpdateCards:
  LDA #$01
  STA reqdraw_card1
  LDA #$01
  STA reqdraw_card2
  LDA #$01
  STA reqdraw_card3
  LDA #$01
  STA reqdraw_card4
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
  LDX cursor_pos
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
updatePotionSickness:
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
  JSR updateHealthFix
updateSicknessFalse:
  LDA #$00
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

  ; load card in regY
  LDY card1
  JSR loadCardSprite  ; require regX(tile) regY(card_id)

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
  
  ; load card in regY
  LDY card2
  JSR loadCardSprite  ; require regX(tile) regY(card_id)

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
  
  ; load card in regY
  LDY card3
  JSR loadCardSprite  ; require regX(tile) regY(card_id)

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
  
  ; load card in regY
  LDY card4
  JSR loadCardSprite  ; require regX(tile) regY(card_id)

  STA $2007        ; set tile.x pos
  INX
  CPX #$36
  BNE drawCard4Loop
drawCard4Done:
  LDA #$00            ; No background scrolling
  STA $2005
  STA $2005
  RTS

loadCardSprite:       ; regX = tile_id, regY = card_id
  LDA card_types, y
  CMP #$00
  BEQ loadCardSpriteHeart
  CMP #$01
  BEQ loadCardSpriteDiamond
  CMP #$02
  BEQ loadCardSpriteSpade
  CMP #$03
  BEQ loadCardSpriteClover
  CMP #$04
  BEQ loadCardSpriteJoker
  LDA blank, x
  RTS
loadCardSpriteHeart:
  JSR loadSpriteHeart
  RTS
loadCardSpriteDiamond:
  JSR loadSpriteDiamond
  RTS
loadCardSpriteSpade:
  JSR loadSpriteSpade
  RTS
loadCardSpriteClover:
  JSR loadSpriteClover
  RTS
loadCardSpriteJoker:
  JSR loadSpriteJoker
  RTS

loadSpriteHeart:
  TYA
  CMP #$00
  BEQ loadHeart01
  CMP #$01
  BEQ loadHeart02
  CMP #$02
  BEQ loadHeart03
  CMP #$03
  BEQ loadHeart04
  CMP #$04
  BEQ loadHeart05
  CMP #$05
  BEQ loadHeart06
  CMP #$06
  BEQ loadHeart07
  CMP #$07
  BEQ loadHeart08
  CMP #$08
  BEQ loadHeart09
  CMP #$09
  BEQ loadHeart10
  CMP #$0a
  BEQ loadHeart11
  CMP #$0b
  BEQ loadHeart12
  CMP #$0c
  BEQ loadHeart13
  RTS
loadHeart01:
  LDA heart1, x
  RTS
loadHeart02:
  LDA heart2, x
  RTS
loadHeart03:
  LDA heart3, x
  RTS
loadHeart04:
  LDA heart4, x
  RTS
loadHeart05:
  LDA heart5, x
  RTS
loadHeart06:
  LDA heart6, x
  RTS
loadHeart07:
  LDA heart7, x
  RTS
loadHeart08:
  LDA heart8, x
  RTS
loadHeart09:
  LDA heart9, x
  RTS
loadHeart10:
  LDA heart10, x
  RTS
loadHeart11:
  LDA heart11, x
  RTS
loadHeart12:
  LDA heart12, x
  RTS
loadHeart13:
  LDA heart13, x
  RTS

loadSpriteDiamond:
  TYA
  CMP #$0d
  BEQ loadDiamond01
  CMP #$0e
  BEQ loadDiamond02
  CMP #$0f
  BEQ loadDiamond03
  CMP #$10
  BEQ loadDiamond04
  CMP #$11
  BEQ loadDiamond05
  CMP #$12
  BEQ loadDiamond06
  CMP #$13
  BEQ loadDiamond07
  CMP #$14
  BEQ loadDiamond08
  CMP #$15
  BEQ loadDiamond09
  CMP #$16
  BEQ loadDiamond10
  CMP #$17
  BEQ loadDiamond11
  CMP #$18
  BEQ loadDiamond12
  CMP #$19
  BEQ loadDiamond13
  RTS
loadDiamond01:
  LDA diamond1, x
  RTS
loadDiamond02:
  LDA diamond2, x
  RTS
loadDiamond03:
  LDA diamond3, x
  RTS
loadDiamond04:
  LDA diamond4, x
  RTS
loadDiamond05:
  LDA diamond5, x
  RTS
loadDiamond06:
  LDA diamond6, x
  RTS
loadDiamond07:
  LDA diamond7, x
  RTS
loadDiamond08:
  LDA diamond8, x
  RTS
loadDiamond09:
  LDA diamond9, x
  RTS
loadDiamond10:
  LDA diamond10, x
  RTS
loadDiamond11:
  LDA diamond11, x
  RTS
loadDiamond12:
  LDA diamond12, x
  RTS
loadDiamond13:
  LDA diamond13, x
  RTS

loadSpriteSpade:
  TYA
  CMP #$1a
  BEQ loadSpade01
  CMP #$1b
  BEQ loadSpade02
  CMP #$1c
  BEQ loadSpade03
  CMP #$1d
  BEQ loadSpade04
  CMP #$1e
  BEQ loadSpade05
  CMP #$1f
  BEQ loadSpade06
  CMP #$20
  BEQ loadSpade07
  CMP #$21
  BEQ loadSpade08
  CMP #$22
  BEQ loadSpade09
  CMP #$23
  BEQ loadSpade10
  CMP #$24
  BEQ loadSpade11
  CMP #$25
  BEQ loadSpade12
  CMP #$26
  BEQ loadSpade13
  RTS
loadSpade01:
  LDA spade1, x
  RTS
loadSpade02:
  LDA spade2, x
  RTS
loadSpade03:
  LDA spade3, x
  RTS
loadSpade04:
  LDA spade4, x
  RTS
loadSpade05:
  LDA spade5, x
  RTS
loadSpade06:
  LDA spade6, x
  RTS
loadSpade07:
  LDA spade7, x
  RTS
loadSpade08:
  LDA spade8, x
  RTS
loadSpade09:
  LDA spade9, x
  RTS
loadSpade10:
  LDA spade10, x
  RTS
loadSpade11:
  LDA spade11, x
  RTS
loadSpade12:
  LDA spade12, x
  RTS
loadSpade13:
  LDA spade13, x
  RTS

loadSpriteClover:
  TYA
  CMP #$27
  BEQ loadClover01
  CMP #$28
  BEQ loadClover02
  CMP #$29
  BEQ loadClover03
  CMP #$2a
  BEQ loadClover04
  CMP #$2b
  BEQ loadClover05
  CMP #$2c
  BEQ loadClover06
  CMP #$2d
  BEQ loadClover07
  CMP #$2e
  BEQ loadClover08
  CMP #$2f
  BEQ loadClover09
  CMP #$30
  BEQ loadClover10
  CMP #$31
  BEQ loadClover11
  CMP #$32
  BEQ loadClover12
  CMP #$33
  BEQ loadClover13
  RTS
loadClover01:
  LDA clover1, x
  RTS
loadClover02:
  LDA clover2, x
  RTS
loadClover03:
  LDA clover3, x
  RTS
loadClover04:
  LDA clover4, x
  RTS
loadClover05:
  LDA clover5, x
  RTS
loadClover06:
  LDA clover6, x
  RTS
loadClover07:
  LDA clover7, x
  RTS
loadClover08:
  LDA clover8, x
  RTS
loadClover09:
  LDA clover9, x
  RTS
loadClover10:
  LDA clover10, x
  RTS
loadClover11:
  LDA clover11, x
  RTS
loadClover12:
  LDA clover12, x
  RTS
loadClover13:
  LDA clover13, x
  RTS

loadSpriteJoker:
  TYA
  CMP #$34
  BEQ loadJoker01
  CMP #$35
  BEQ loadJoker02
  RTS
loadJoker01:
  LDA joker1, x
  RTS
loadJoker02:
  LDA joker2, x
  RTS