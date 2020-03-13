
;; client

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
  JSR redrawName@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_name
  INC reqdraws
  RTS
@checkReqCard1:                ; 
  LDA reqdraw_card1
  CMP #$00
  BEQ @checkReqCard2
  JSR stop@renderer
  JSR updateCard1
  JSR start@renderer
  LDA #$00
  STA reqdraw_card1
  INC reqdraws
  RTS
@checkReqCard2:                ; 
  LDA reqdraw_card2
  CMP #$00
  BEQ @checkReqCard3
  JSR stop@renderer
  JSR updateCard2
  JSR start@renderer
  LDA #$00
  STA reqdraw_card2
  INC reqdraws
  RTS
@checkReqCard3:                ; 
  LDA reqdraw_card3
  CMP #$00
  BEQ @checkReqCard4
  JSR stop@renderer
  JSR updateCard3
  JSR start@renderer
  LDA #$00
  STA reqdraw_card3
  INC reqdraws
  RTS
@checkReqCard4:                ; 
  LDA reqdraw_card4
  CMP #$00
  BEQ @checkReqHP
  JSR stop@renderer
  JSR updateCard4
  JSR start@renderer
  LDA #$00
  STA reqdraw_card4
  INC reqdraws
  RTS
@checkReqHP:                   ; 
  LDA reqdraw_hp
  CMP #$00
  BEQ @checkReqSP
  JSR redrawHealth@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_hp
  INC reqdraws
  RTS
@checkReqSP:                   ; 
  LDA reqdraw_sp
  CMP #$00
  BEQ @checkReqXP
  JSR redrawShield@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_sp
  INC reqdraws
  RTS
@checkReqXP:                   ; 
  LDA reqdraw_xp
  CMP #$00
  BEQ @checkReqRun
  JSR redrawExperience@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_xp
  INC reqdraws
  RTS
@checkReqRun:                  ; 
  LDA reqdraw_run
  CMP #$00
  BEQ @checkReqDialog
  JSR redrawRun@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_run
  INC reqdraws
  RTS
@checkReqDialog:               ; 
  LDA reqdraw_dialog
  CMP #$00
  BEQ @checkReqScore
  JSR redraw@dialog
  JSR fix@renderer
  LDA #$00
  STA reqdraw_dialog
  INC reqdraws
  RTS
@checkReqScore:                ; 
  LDA reqdraw_score
  CMP #$00
  BEQ @done
  JSR redrawScore@splash
  JSR fix@renderer
  LDA #$00
  STA reqdraw_score
  INC reqdraws
  RTS
@done:                         ; 
  RTS

;;

redrawRun@game:                ; 
  JSR loadRun@player           ; load canRun in regA
  CMP #$01
  BNE @hide
  LDA length@deck              ; don't display the run butto on first hand
  CMP #$31                     ; deck is $36 - 4(first hand)
  BEQ @hide
@show:                         ; RUN: $1c,$1f,$18
  BIT PPUSTATUS                ; read PPU status to reset the high/low latch
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
  RTS
@hide:                         ; 
  BIT PPUSTATUS                ; read PPU status to reset the high/low latch
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

;; to merge into a single routine

updateCard1:                   ; 
  LDA #$00
  LDX #$00
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
  RTS

;;

updateCard2:                   ; 
  LDA #$00
  LDX #$00
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
  RTS

;;

updateCard3:                   ; 
  LDA #$00
  LDX #$00
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
  RTS

;;

updateCard4:                   ; 
  LDA #$00
  LDX #$00
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

;; renderer

start@renderer:                ; 
  LDA #%10010000               ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA PPUCTRL
  LDA #%00011000               ; enable sprites, enable background, no clipping on left side
  STA PPUMASK
  LDA #$00                     ; No background scrolling
  STA PPUADDR
  STA PPUADDR
  STA PPUSCROLL
  STA PPUSCROLL
  RTS

;;

stop@renderer:                 ; 
  LDA #%10000000               ; disable NMI, sprites from Pattern Table 0
  STA PPUCTRL
  LDA #%00000000               ; disable sprites
  STA PPUMASK
  RTS

;;

fix@renderer:                  ; 
  BIT PPUSTATUS
  LDA #$00                     ; No background scrolling
  STA PPUADDR
  STA PPUADDR
  STA PPUSCROLL
  STA PPUSCROLL
  RTS