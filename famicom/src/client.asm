
;; client

requestUpdateStats:            ; 
  LDA #$01
  STA reqdraw_hp
  LDA #$01
  STA reqdraw_sp
  LDA #$01
  STA reqdraw_xp
  RTS
requestUpdateCursor:           ; 
  LDA #$01
  STA reqdraw_cursor
  RTS
requestUpdateDialog:           ; 
  LDA #$01
  STA reqdraw_dialog
  RTS
requestUpdateCards:            ; 
  LDA #$01
  STA reqdraw_card1
  LDA #$01
  STA reqdraw_card2
  LDA #$01
  STA reqdraw_card3
  LDA #$01
  STA reqdraw_card4
  RTS

;; interpolate

interpolateStats:              ; 
  JSR interpolateHealth
  JSR interpolateShield
  RTS

;;

interpolateHealth:             ; 
  LDA ui_health                ; follower x
  CMP health                   ; sprite x
  BEQ interpolateHealthDone
  BCC interpolateHealthInc
  DEC ui_health
  ; request redraw
  LDA #$01
  STA reqdraw_hp
  RTS
interpolateHealthInc:          ; 
  INC ui_health
  ; request redraw
  LDA #$01
  STA reqdraw_hp
interpolateHealthDone:         ; 
  RTS

;;

interpolateShield:             ; 
  LDA ui_shield                ; follower x
  CMP shield                   ; sprite x
  BEQ interpolateShieldDone
  BCC interpolateShieldInc
  DEC ui_shield
  ; request redraw
  LDA #$01
  STA reqdraw_sp
  RTS
interpolateShieldInc:          ; 
  INC ui_shield
  ; request redraw
  LDA #$01
  STA reqdraw_sp
interpolateShieldDone:         ; 
  RTS

;; check for updates required

updateClient:                  ; 
checkReqCursor:                ; TODO: not sure if the cursor should take a render frame..
  LDA reqdraw_cursor
  CMP #$00
  BEQ checkReqCard1
  JSR updateCursor
  LDA #$00
  STA reqdraw_cursor
  INC reqdraws
  RTS
checkReqCard1:                 ; 
  LDA reqdraw_card1
  CMP #$00
  BEQ checkReqCard2
  JSR updateCard1
  LDA #$00
  STA reqdraw_card1
  INC reqdraws
  RTS
checkReqCard2:                 ; 
  LDA reqdraw_card2
  CMP #$00
  BEQ checkReqCard3
  JSR updateCard2
  LDA #$00
  STA reqdraw_card2
  INC reqdraws
  RTS
checkReqCard3:                 ; 
  LDA reqdraw_card3
  CMP #$00
  BEQ checkReqCard4
  JSR updateCard3
  LDA #$00
  STA reqdraw_card3
  INC reqdraws
  RTS
checkReqCard4:                 ; 
  LDA reqdraw_card4
  CMP #$00
  BEQ checkReqHP
  JSR updateCard4
  LDA #$00
  STA reqdraw_card4
  INC reqdraws
  RTS
checkReqHP:                    ; 
  LDA reqdraw_hp
  CMP #$00
  BEQ checkReqSP
  JSR updateHealth
  JSR updateHealthBar
  LDA #$00
  STA reqdraw_hp
  INC reqdraws
  RTS
checkReqSP:                    ; 
  LDA reqdraw_sp
  CMP #$00
  BEQ checkReqXP
  JSR updateShield
  JSR updateShieldBar
  LDA #$00
  STA reqdraw_sp
  INC reqdraws
  RTS
checkReqXP:                    ; 
  LDA reqdraw_xp
  CMP #$00
  BEQ checkReqDialog
  JSR updateExperience
  JSR updateExperienceBar
  LDA #$00
  STA reqdraw_xp
  INC reqdraws
  RTS
checkReqDialog:                ; 
  LDA reqdraw_dialog
  CMP #$00
  BEQ updateClientDone
  JSR updateDialog
  LDA #$00
  STA reqdraw_dialog
  INC reqdraws
  RTS
updateClientDone:              ; 
  RTS

;; actual update code

updateCursor:                  ; 
  LDX cursor_pos
  LDA cursor_positions, x
  STA $0203                    ; set tile.x pos
  CLC
  ADC #$08
  STA $0207                    ; set tile.x pos
  RTS

;; health value

updateHealth:                  ; 
  LDA $2000                    ; read PPU status to reset the high/low latch
  LDX #$00                     ; Not quite sure why this is needed, but breaks otherwise
  JSR renderStop
updateHealthDigit1:            ; 
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$07
  STA $2006                    ; write the low byte of $2000 address
  LDX ui_health
  LDA number_high, x
  STA $2007
updateHealthDigit2:            ; 
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$08
  STA $2006                    ; write the low byte of $2000 address
  LDX ui_health
  LDA number_low, x
  STA $2007
updatePotionSickness:          ; 
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$05
  STA $2006                    ; write the low byte of $2000 address
  LDA potion_sickness
  CMP #$01
  BNE updateSicknessFalse
updateSicknessTrue:            ; 
  LDA #$3F
  STA $2007  
  JSR updateHealthDone
updateSicknessFalse:           ; 
  LDA #$00
  STA $2007  
updateHealthDone:              ; 
  JSR renderStop
  RTS

;; health bar

updateHealthBar:               ; 
  LDX #$00
  LDY ui_health
  LDA healthbarpos, y          ; regA has sprite offset
  TAY                          ; regY has sprite offset
  JSR renderStop
updateHealthBarLoop:           ; 
  LDA #$20
  STA $2006                    ; write the high byte of $2000 address
  LDA healthbaroffset, x
  STA $2006                    ; write the low byte of $2000 address
  LDA progressbar, y           ; regA has sprite id
  INY
  STA $2007
  INX
  CPX #$06
  BNE updateHealthBarLoop
  JSR renderStart
  RTS

;; shield value

updateShield:                  ; 
  LDA $2000                    ; read PPU status to reset the high/low latch
  LDX #$00                     ; Not quite sure why this is needed, but breaks otherwise
  JSR renderStop
updateShieldDigit1:            ; 
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$0E
  STA $2006                    ; write the low byte of $2000 address
  LDX ui_shield
  LDA number_high, x
  STA $2007
updateShieldDigit2:            ; 
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$0F
  STA $2006                    ; write the low byte of $2000 address
  LDX ui_shield
  LDA number_low, x
  STA $2007
updateShieldDurabilityDigit1:  ; 
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$0C
  STA $2006                    ; write the low byte of $2000 address
  LDX shield_durability
  LDA card_glyphs, x
  STA $2007
  JSR renderStart
  RTS

;; shield bar

updateShieldBar:               ; 
  LDX #$00
  LDY ui_shield
  LDA shieldbarpos, y          ; regA has sprite offset
  TAY                          ; regY has sprite offset
  JSR renderStop
updateShieldBarLoop:           ; 
  LDA #$20
  STA $2006                    ; write the high byte of $2000 address
  LDA shieldbaroffset, x
  STA $2006                    ; write the low byte of $2000 address
  LDA progressbar, y           ; regA has sprite id
  INY
  STA $2007
  INX
  CPX #$06
  BNE updateShieldBarLoop
  JSR renderStart
  RTS

;; experience value

updateExperience:              ; 
  LDA $2000                    ; read PPU status to reset the high/low latch
  LDX #$00                     ; Not quite sure why this is needed, but breaks otherwise
  JSR renderStop
updateExperienceDigit1:        ; 
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$15
  STA $2006                    ; write the low byte of $2000 address
  LDX experience
  LDA number_high, x
  STA $2007
updateExperienceDigit2:        ; 
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$16
  STA $2006                    ; write the low byte of $2000 address
  LDX experience
  LDA number_low, x
  STA $2007
  JSR renderStart
  RTS

;; experience bar

updateExperienceBar:           ; 
  LDX #$00
  LDY experience
  LDA experiencebarpos, y      ; regA has sprite offset
  TAY                          ; regY has sprite offset
  JSR renderStop
updateExperienceBarLoop:       ; 
  LDA #$20
  STA $2006                    ; write the high byte of $2000 address
  LDA experiencebaroffset, x
  STA $2006                    ; write the low byte of $2000 address
  LDA progressbar, y           ; regA has sprite id
  INY
  STA $2007
  INX
  CPX #$06
  BNE updateExperienceBarLoop
  JSR renderStart
  RTS

;; to merge into a single routine

updateCard1:                   ; 
  LDA #$00
  LDX #$00
  JSR renderStop
drawCardLoop:                  ; 
  LDA card1pos_high, x
  STA $2006                    ; write the high byte of $2000 address
  LDA card1pos_low, x
  STA $2006                    ; write the low byte of $2000 address
  ; load card in regY
  LDY card1
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA $2007                    ; set tile.x pos
  INX
  CPX #$36
  BNE drawCardLoop
drawCardDone:                  ; 
  JSR renderStart
  RTS

;;

updateCard2:                   ; 
  LDA #$00
  LDX #$00
  JSR renderStop
drawCard2Loop:                 ; 
  LDA card1pos_high, x
  STA $2006                    ; write the high byte of $2000 address
  LDA card2pos_low, x
  STA $2006                    ; write the low byte of $2000 address
  ; load card in regY
  LDY card2
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA $2007                    ; set tile.x pos
  INX
  CPX #$36
  BNE drawCard2Loop
drawCard2Done:                 ; 
  JSR renderStart
  RTS

;;

updateCard3:                   ; 
  LDA #$00
  LDX #$00
  JSR renderStop
drawCard3Loop:                 ; 
  LDA card3pos_high, x
  STA $2006                    ; write the high byte of $2000 address
  LDA card3pos_low, x
  STA $2006                    ; write the low byte of $2000 address
  ; load card in regY
  LDY card3
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA $2007                    ; set tile.x pos
  INX
  CPX #$36
  BNE drawCard3Loop
drawCard3Done:                 ; 
  JSR renderStart
  RTS

;;

updateCard4:                   ; 
  LDA #$00
  LDX #$00
  JSR renderStop
drawCard4Loop:                 ; 
  LDA card3pos_high, x
  STA $2006                    ; write the high byte of $2000 address
  LDA card4pos_low, x
  STA $2006                    ; write the low byte of $2000 address
  ; load card in regY
  LDY card4
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA $2007                    ; set tile.x pos
  INX
  CPX #$36
  BNE drawCard4Loop
drawCard4Done:                 ; 
  JSR renderStart
  RTS

;; dialog

updateDialog:                  ; 
  LDA $2002
  LDA #$23
  STA $2006
  LDA #$03
  STA $2006
  LDX #$00
  JSR renderStop
updateDialogLoop:              ; 
  LDY dialog_id
  JSR loadDialog
  STA $2007
  INX
  CPX #$18
  BNE updateDialogLoop
drawDialogDone:                ; 
  JSR renderStart
  RTS

;; dialog loader

loadDialog:                    ; (x:tile_id, y:dialog_id)
  TYA
  CMP #$00
  BEQ loadDialogClear
  CMP #$01
  BEQ loadDialogSickness
  CMP #$02
  BEQ loadDialogBreak
  CMP #$03
  BEQ loadDialogDeath
  CMP #$04
  BEQ loadDialogEnter
  CMP #$05
  BEQ loadDialogShield
  CMP #$06
  BEQ loadDialogPotion
  CMP #$07
  BEQ loadDialogEnterRoom
  ; TODO
  CMP #$08
  BEQ loadDialogEnterRoom
  CMP #$09
  BEQ loadDialogEnterRoom
  CMP #$0A
  BEQ loadDialogEnterRoom
  CMP #$0B
  BEQ loadDialogEnterRoom
loadDialogClear:               ; 
  LDA dialog_clear_data, x
  RTS
loadDialogSickness:            ; 
  LDA dialog_sickness_data, x
  RTS
loadDialogBreak:               ; 
  LDA dialog_shieldbreak_data, x
  RTS
loadDialogDeath:               ; 
  LDA dialog_death_data, x
  RTS
loadDialogEnter:               ; 
  LDA dialog_enterdungeon_data, x
  RTS
loadDialogShield:              ; 
  LDA dialog_shield_data, x
  RTS
loadDialogPotion:              ; 
  LDA dialog_potion_data, x
  RTS
loadDialogEnterRoom:           ; 
  LDA dialog_enterroom_data, x
  RTS

;; card sprites

; Form a 16-bit address contained in the given location, AND the one 
; following.  Add to that address the contents of the Y register.  
; Fetch the value stored at that address.
; 
;   LDA ($B4),Y  where Y contains 6
;   
; If $B4 contains $EE AND $B5 contains $12 then the value at memory 
; location $12EE + Y (6) = $12F4 is fetched AND put in the accumulator.

;;

loadCardSprite:                ; (x:tile_id, y:card_id)
  ; find card offset
  LDA cards_test_low,y
  STA cards_low
  LDA cards_test_high,y
  STA cards_high
  ; add y + x registers
  TYA
  STX cards_temp
  CLC
  ADC cards_temp
  TAY
  ; load card sprite
  LDA (cards_low), y           ; load value at 16-bit address from (cards_low + cards_high) + y
  RTS