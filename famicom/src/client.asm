
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
requestUpdateRun:              ; 
  LDA #$01
  STA reqdraw_run
  RTS
requestUpdateName:             ; 
  LDA #$01
  STA reqdraw_name
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
  BEQ @done
  BCC @inc
  DEC ui_health
  ; request redraw
  LDA #$01
  STA reqdraw_hp
  RTS
@inc:                          ; 
  INC ui_health
  ; request redraw
  LDA #$01
  STA reqdraw_hp
@done:                         ; 
  RTS

;;

interpolateShield:             ; 
  LDA ui_shield                ; follower x
  CMP shield                   ; sprite x
  BEQ @done
  BCC @inc
  DEC ui_shield
  ; request redraw
  LDA #$01
  STA reqdraw_sp
  RTS
@inc:                          ; 
  INC ui_shield
  ; request redraw
  LDA #$01
  STA reqdraw_sp
@done:                         ; 
  RTS

;; check for updates required

updateClient:                  ; 
  ; animate cursor
checkReqCursor:                ; TODO: not sure if the cursor should take a render frame..
  LDA reqdraw_cursor
  CMP #$00
  BEQ checkReqName
  JSR updateCursor
  LDA #$00
  STA reqdraw_cursor
  INC reqdraws
  RTS
checkReqName:                  ; TODO: not sure if the cursor should take a render frame..
  LDA reqdraw_name
  CMP #$00
  BEQ checkReqCard1
  JSR updateName
  LDA #$00
  STA reqdraw_name
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
  BEQ checkReqRun
  JSR updateExperience
  JSR updateExperienceBar
  LDA #$00
  STA reqdraw_xp
  INC reqdraws
  RTS
checkReqRun:                   ; 
  LDA reqdraw_run
  CMP #$00
  BEQ checkReqDialog
  JSR updateRun
  LDA #$00
  STA reqdraw_run
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
  LDX cursor
  LDA cursor_positions, x
  STA $0203                    ; set tile.x pos
  CLC
  ADC #$08
  STA $0207                    ; set tile.x pos
  RTS

;;

updateName:                    ; 
  LDA PPUSTATUS
  LDA #$21
  STA PPUADDR
  LDA #$43
  STA PPUADDR
  LDX #$00
  JSR renderStop
@loop:                         ; 
  LDY #$01                     ; load card id
  JSR loadCardName
  STA PPUDATA
  INX
  CPX #$10
  BNE @loop
  JSR renderStart
  RTS

;;

updateRun:                     ; 
  LDA PPUCTRL                  ; read PPU status to reset the high/low latch
  JSR renderStop
  LDA can_run
  CMP #$01
  BNE updateRunHide
updateRunShow:                 ; RUN: $1c,$1f,$18
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$18
  STA PPUADDR                  ; write the low byte
  LDA #$1C                     ; R
  STA PPUDATA
  LDA #$1F                     ; U
  STA PPUDATA
  LDA #$18                     ; N
  STA PPUDATA
  JSR renderStart
  RTS
updateRunHide:                 ; 
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$18
  STA PPUADDR                  ; write the low byte
  LDA #$00                     ; R
  STA PPUDATA
  STA PPUDATA
  STA PPUDATA
  JSR renderStart
  RTS

;; health value

updateHealth:                  ; 
  LDA PPUCTRL                  ; read PPU status to reset the high/low latch
  LDX #$00                     ; Not quite sure why this is needed, but breaks otherwise
  JSR renderStop
updateHealthDigit1:            ; 
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$07
  STA PPUADDR                  ; write the low byte
  LDX ui_health
  LDA number_high, x
  STA PPUDATA
updateHealthDigit2:            ; 
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$08
  STA PPUADDR                  ; write the low byte
  LDX ui_health
  LDA number_low, x
  STA PPUDATA
updatePotionSickness:          ; 
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$05
  STA PPUADDR                  ; write the low byte
  LDA potion_sickness
  CMP #$01
  BNE updateSicknessFalse
updateSicknessTrue:            ; 
  LDA #$3F
  STA PPUDATA
  JSR updateHealthDone
updateSicknessFalse:           ; 
  LDA #$00
  STA PPUDATA
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
@loop:                         ; 
  LDA #$20
  STA PPUADDR                  ; write the high byte
  LDA healthbaroffset, x
  STA PPUADDR                  ; write the low byte
  LDA progressbar, y           ; regA has sprite id
  INY
  STA PPUDATA
  INX
  CPX #$06
  BNE @loop
  JSR renderStart
  RTS

;; shield value

updateShield:                  ; 
  LDA PPUCTRL                  ; read PPU status to reset the high/low latch
  LDX #$00                     ; Not quite sure why this is needed, but breaks otherwise
  JSR renderStop
updateShieldDigit1:            ; 
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$0E
  STA PPUADDR                  ; write the low byte
  LDX ui_shield
  LDA number_high, x
  STA PPUDATA
updateShieldDigit2:            ; 
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$0F
  STA PPUADDR                  ; write the low byte
  LDX ui_shield
  LDA number_low, x
  STA PPUDATA
updateShieldDurabilityDigit1:  ; 
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$0C
  STA PPUADDR                  ; write the low byte
  LDX shield_durability
  LDA card_glyphs, x
  STA PPUDATA
  JSR renderStart
  RTS

;; shield bar

updateShieldBar:               ; 
  LDX #$00
  LDY ui_shield
  LDA shieldbarpos, y          ; regA has sprite offset
  TAY                          ; regY has sprite offset
  JSR renderStop
@loop:                         ; 
  LDA #$20
  STA PPUADDR                  ; write the high byte
  LDA shieldbaroffset, x
  STA PPUADDR                  ; write the low byte
  LDA progressbar, y           ; regA has sprite id
  INY
  STA PPUDATA
  INX
  CPX #$06
  BNE @loop
  JSR renderStart
  RTS

;; experience value

updateExperience:              ; 
  LDA PPUCTRL                  ; read PPU status to reset the high/low latch
  LDX #$00                     ; Not quite sure why this is needed, but breaks otherwise
  JSR renderStop
updateExperienceDigit1:        ; 
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$15
  STA PPUADDR                  ; write the low byte
  LDX experience
  LDA number_high, x
  STA PPUDATA
updateExperienceDigit2:        ; 
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$16
  STA PPUADDR                  ; write the low byte
  LDX experience
  LDA number_low, x
  STA PPUDATA
  JSR renderStart
  RTS

;; experience bar

updateExperienceBar:           ; 
  LDX #$00
  LDY experience
  LDA experiencebarpos, y      ; regA has sprite offset
  TAY                          ; regY has sprite offset
  JSR renderStop
@loop:                         ; 
  LDA #$20
  STA PPUADDR                  ; write the high byte
  LDA experiencebaroffset, x
  STA PPUADDR                  ; write the low byte
  LDA progressbar, y           ; regA has sprite id
  INY
  STA PPUDATA
  INX
  CPX #$06
  BNE @loop
  JSR renderStart
  RTS

;; to merge into a single routine

updateCard1:                   ; 
  LDA #$00
  LDX #$00
  JSR renderStop
@loop:                         ; 
  LDA card1pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card1pos_low, x
  STA PPUADDR                  ; write the low byte
  ; load card in regY
  LDY card1
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA PPUDATA                  ; set tile.x pos
  INX
  CPX #$36
  BNE @loop
  JSR renderStart
  RTS

;;

updateCard2:                   ; 
  LDA #$00
  LDX #$00
  JSR renderStop
@loop:                         ; 
  LDA card1pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card2pos_low, x
  STA PPUADDR                  ; write the low byte
  ; load card in regY
  LDY card2
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA PPUDATA                  ; set tile.x pos
  INX
  CPX #$36
  BNE @loop
  JSR renderStart
  RTS

;;

updateCard3:                   ; 
  LDA #$00
  LDX #$00
  JSR renderStop
@loop:                         ; 
  LDA card3pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card3pos_low, x
  STA PPUADDR                  ; write the low byte
  ; load card in regY
  LDY card3
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA PPUDATA                  ; set tile.x pos
  INX
  CPX #$36
  BNE @loop
  JSR renderStart
  RTS

;;

updateCard4:                   ; 
  LDA #$00
  LDX #$00
  JSR renderStop
@loop:                         ; 
  LDA card3pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card4pos_low, x
  STA PPUADDR                  ; write the low byte
  ; load card in regY
  LDY card4
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA PPUDATA                  ; set tile.x pos
  INX
  CPX #$36
  BNE @loop
  JSR renderStart
  RTS

;; dialog

updateDialog:                  ; 
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$03
  STA PPUADDR
  LDX #$00
  JSR renderStop
@loop:                         ; 
  LDY dialog_id
  JSR loadDialog
  STA PPUDATA
  INX
  CPX #$18
  BNE @loop
  JSR renderStart
  RTS

;;

; Form a 16-bit address contained in the given location, AND the one 
; following.  Add to that address the contents of the Y register.  
; Fetch the value stored at that address.
; 
;   LDA ($B4),Y  where Y contains 6
;   
; If $B4 contains $EE AND $B5 contains $12 then the value at memory 
; location $12EE + Y (6) = $12F4 is fetched AND put in the accumulator.

;; dialog loader

loadDialog:                    ; (x:tile_id, y:dialog_id)
  ; find dialog offset
  LDA dialogs_offset_low,y
  STA dialogs_low
  LDA dialogs_offset_high,y
  STA dialogs_high
  ; add y + x registers
  TYA
  STX dialogs_temp
  CLC
  ADC dialogs_temp
  TAY
  ; load dialog sprite
  LDA (dialogs_low), y         ; load value at 16-bit address from (dialogs_low + dialogs_high) + y
  RTS

;;

loadCardName:                  ; (y:card_id)
  ; figure out y
  LDY cursor
  LDA card1, y
  TAY
  ; find name offset
  LDA card_names_offset_lb,y
  STA names_low
  LDA card_names_offset_hb,y
  STA names_high
  ; add y + x registers
  TYA
  STX names_temp
  CLC
  ADC names_temp
  TAY
  ; load dialog sprite
  LDA (names_low), y           ; load value at 16-bit address from (dialogs_low + dialogs_high) + y
  RTS

;; card sprites

loadCardSprite:                ; (x:tile_id, y:card_id)
  ; find card offset
  LDA cards_offset_low,y
  STA cards_low
  LDA cards_offset_high,y
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