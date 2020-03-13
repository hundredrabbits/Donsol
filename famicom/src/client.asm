
;; client

requestUpdateStats:            ; 
  LDA #$01
  STA reqdraw_hp
  STA reqdraw_sp
  STA reqdraw_xp
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
  STA reqdraw_card2
  STA reqdraw_card3
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
  CMP hp@player                ; sprite x
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
  CMP sp@player                ; sprite x
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

update@client:                 ; during nmi
  ; draw name
  LDA reqdraw_name
  CMP #$00
  BEQ @checkReqCard1
  JSR updateName
  LDA #$00
  STA reqdraw_name
  INC reqdraws
  RTS
@checkReqCard1:                ; 
  LDA reqdraw_card1
  CMP #$00
  BEQ @checkReqCard2
  JSR updateCard1
  LDA #$00
  STA reqdraw_card1
  INC reqdraws
  RTS
@checkReqCard2:                ; 
  LDA reqdraw_card2
  CMP #$00
  BEQ @checkReqCard3
  JSR updateCard2
  LDA #$00
  STA reqdraw_card2
  INC reqdraws
  RTS
@checkReqCard3:                ; 
  LDA reqdraw_card3
  CMP #$00
  BEQ @checkReqCard4
  JSR updateCard3
  LDA #$00
  STA reqdraw_card3
  INC reqdraws
  RTS
@checkReqCard4:                ; 
  LDA reqdraw_card4
  CMP #$00
  BEQ @checkReqHP
  JSR updateCard4
  LDA #$00
  STA reqdraw_card4
  INC reqdraws
  RTS
@checkReqHP:                   ; 
  LDA reqdraw_hp
  CMP #$00
  BEQ @checkReqSP
  JSR updateHealth
  JSR updateHealthBar
  LDA #$00
  STA reqdraw_hp
  INC reqdraws
  RTS
@checkReqSP:                   ; 
  LDA reqdraw_sp
  CMP #$00
  BEQ @checkReqXP
  JSR updateShield
  JSR updateShieldBar
  LDA #$00
  STA reqdraw_sp
  INC reqdraws
  RTS
@checkReqXP:                   ; 
  LDA reqdraw_xp
  CMP #$00
  BEQ @checkReqRun
  JSR updateExperience
  JSR updateExperienceBar
  LDA #$00
  STA reqdraw_xp
  INC reqdraws
  RTS
@checkReqRun:                  ; 
  LDA reqdraw_run
  CMP #$00
  BEQ @checkReqDialog
  JSR updateRun
  LDA #$00
  STA reqdraw_run
  INC reqdraws
  RTS
@checkReqDialog:               ; 
  LDA reqdraw_dialog
  CMP #$00
  BEQ @checkReqScore
  JSR update@dialog
  LDA #$00
  STA reqdraw_dialog
  INC reqdraws
  RTS
@checkReqScore:                ; 
  LDA reqdraw_score
  CMP #$00
  BEQ @done
  JSR updateScore@splash
  LDA #$00
  STA reqdraw_score
  INC reqdraws
  RTS
@done:                         ; 
  RTS

;;

updateName:                    ; 
  LDA PPUSTATUS
  LDA #$21
  STA PPUADDR
  LDA #$43
  STA PPUADDR
  LDX #$00
  JSR stop@renderer
@loop:                         ; 
  LDY #$01                     ; load card id
  JSR loadCardName
  STA PPUDATA
  INX
  CPX #$10
  BNE @loop
  JSR start@renderer
  RTS

;;

updateRun:                     ; 
  LDA PPUCTRL                  ; read PPU status to reset the high/low latch
  JSR stop@renderer
  JSR loadRun@player           ; load canRun in regA
  CMP #$01
  BNE @hide
  LDA xp@player
  CMP #$00
  BEQ @hide
@show:                         ; RUN: $1c,$1f,$18
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$18
  STA PPUADDR                  ; write the low byte
  LDA #$6D                     ; Button(B)
  STA PPUDATA
  LDA #$00                     ; Blank
  STA PPUDATA
  LDA #$1C                     ; R
  STA PPUDATA
  LDA #$1F                     ; U
  STA PPUDATA
  LDA #$18                     ; N
  STA PPUDATA
  JSR start@renderer
  RTS
@hide:                         ; 
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$18
  STA PPUADDR                  ; write the low byte
  LDA #$00                     ; R
  STA PPUDATA
  STA PPUDATA
  STA PPUDATA
  STA PPUDATA
  STA PPUDATA
  JSR start@renderer
  RTS

;; health value

updateHealth:                  ; 
  LDA PPUCTRL                  ; read PPU status to reset the high/low latch
  LDX #$00                     ; Not quite sure why this is needed, but breaks otherwise
  JSR stop@renderer
  ; pos
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$07
  STA PPUADDR                  ; write the low byte
  ; digit 1
  LDX ui_health
  LDA number_high, x
  STA PPUDATA
  ; digit 2
  LDX ui_health
  LDA number_low, x
  STA PPUDATA
  ; sickness
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$05
  STA PPUADDR                  ; write the low byte
  LDA sickness@player
  CMP #$01
  BNE @false
  ; sickness icon
  LDA #$3F
  STA PPUDATA
  JSR @done
@false:                        ; 
  LDA #$00
  STA PPUDATA
@done:                         ; 
  JSR stop@renderer
  RTS

;; health bar

updateHealthBar:               ; 
  LDX #$00
  LDY ui_health
  LDA healthbarpos, y          ; regA has sprite offset
  TAY                          ; regY has sprite offset
  JSR stop@renderer
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
  JSR start@renderer
  RTS

;; shield value

updateShield:                  ; 
  LDA PPUCTRL                  ; read PPU status to reset the high/low latch
  LDX #$00                     ; Not quite sure why this is needed, but breaks otherwise
  JSR stop@renderer
  ; pos
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$0E
  STA PPUADDR                  ; write the low byte
  ; digit 1
  LDX ui_shield
  LDA number_high, x
  STA PPUDATA
  ; digit 2
  LDX ui_shield
  LDA number_low, x
  STA PPUDATA
  ; durability
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$0C
  STA PPUADDR                  ; write the low byte
  LDX dp@player
  LDA card_glyphs, x
  STA PPUDATA
  JSR start@renderer
  RTS

;; shield bar

updateShieldBar:               ; 
  LDX #$00
  LDY ui_shield
  LDA shieldbarpos, y          ; regA has sprite offset
  TAY                          ; regY has sprite offset
  JSR stop@renderer
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
  JSR start@renderer
  RTS

;; experience value

updateExperience:              ; 
  LDA PPUCTRL                  ; read PPU status to reset the high/low latch
  LDX #$00                     ; Not quite sure why this is needed, but breaks otherwise
  JSR stop@renderer
  ; pos
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$15
  STA PPUADDR                  ; write the low byte
  ; digit 1
  LDX xp@player
  LDA number_high, x
  STA PPUDATA
  ; digit 2
  LDX xp@player
  LDA number_low, x
  STA PPUDATA
  JSR start@renderer
  RTS

;; experience bar

updateExperienceBar:           ; 
  LDX #$00
  LDY xp@player
  LDA experiencebarpos, y      ; regA has sprite offset
  TAY                          ; regY has sprite offset
  JSR stop@renderer
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
  JSR start@renderer
  RTS

;; to merge into a single routine

updateCard1:                   ; 
  LDA #$00
  LDX #$00
  JSR stop@renderer
@loop:                         ; 
  LDA card1pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card1pos_low, x
  STA PPUADDR                  ; write the low byte
  ; load card in regY
  LDY card1@room
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA PPUDATA                  ; set tile.x pos
  INX
  CPX #$36
  BNE @loop
  JSR start@renderer
  RTS

;;

updateCard2:                   ; 
  LDA #$00
  LDX #$00
  JSR stop@renderer
@loop:                         ; 
  LDA card1pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card2pos_low, x
  STA PPUADDR                  ; write the low byte
  ; load card in regY
  LDY card2@room
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA PPUDATA                  ; set tile.x pos
  INX
  CPX #$36
  BNE @loop
  JSR start@renderer
  RTS

;;

updateCard3:                   ; 
  LDA #$00
  LDX #$00
  JSR stop@renderer
@loop:                         ; 
  LDA card3pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card3pos_low, x
  STA PPUADDR                  ; write the low byte
  ; load card in regY
  LDY card3@room
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA PPUDATA                  ; set tile.x pos
  INX
  CPX #$36
  BNE @loop
  JSR start@renderer
  RTS

;;

updateCard4:                   ; 
  LDA #$00
  LDX #$00
  JSR stop@renderer
@loop:                         ; 
  LDA card3pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card4pos_low, x
  STA PPUADDR                  ; write the low byte
  ; load card in regY
  LDY card4@room
  JSR loadCardSprite           ; require regX(tile) regY(card_id)
  STA PPUDATA                  ; set tile.x pos
  INX
  CPX #$36
  BNE @loop
  JSR start@renderer
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

;;

loadCardName:                  ; (y:card_id)
  ; figure out y
  LDY cursor@game
  LDA card1@room, y
  TAY
  ; find name offset
  LDA card_names_offset_lb,y
  STA lb@temp
  LDA card_names_offset_hb,y
  STA hb@temp
  ; add y + x registers
  TYA
  STX id@temp
  CLC
  ADC id@temp
  TAY
  ; load dialog sprite
  LDA (lb@temp), y             ; load value at 16-bit address from (lb@temp + hb@temp) + y
  RTS

;; card sprites

loadCardSprite:                ; (x:tile_id, y:card_id)
  ; find card offset
  LDA cards_offset_low,y
  STA lb@temp
  LDA cards_offset_high,y
  STA hb@temp
  ; add y + x registers
  TYA
  STX id@temp
  CLC
  ADC id@temp
  TAY
  ; load card sprite
  LDA (lb@temp), y             ; load value at 16-bit address from (lb@temp + hb@temp) + y
  RTS