
;;

nmi@game:                      ; during nmi
  JSR interpolateStats@game
  JSR nmi@room
  LDA timer@renderer
  CMP #$00
  BEQ @whenRender
  DEC timer@renderer
  RTS
@whenRender:                   ; 
  LDA #$02                     ; reset render timer to 2 frames
  STA timer@renderer
@beginDrawing:                 ; 
@checkReqGame:                 ; 
  LDA reqdraw_game
  CMP #$00
  BEQ @checkReqSP
  JSR stop@renderer
  ; display
  JSR load@game
  JSR loadAttributes@game
  JSR start@renderer
  LDA #$00
  STA reqdraw_game
  RTS
@checkReqSP:                   ; [skip]
  LDA redraws@game
  AND REQ_SP
  BEQ @checkReqHP
  JSR redrawShield@game
  RTS
@checkReqHP:                   ; 
  LDA redraws@game
  AND REQ_HP
  BEQ @checkReqCursor
  JSR redrawHealth@game
  RTS
@checkReqCursor:               ; 
  LDA reqdraw_cursor
  CMP #$00
  BEQ @checkName
  JSR redrawCursor@game
  RTS
@checkName
  LDA reqdraw_name
  CMP #$00
  BEQ @checkReqCard1
  JSR redrawName@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_name
  RTS
@checkReqCard1:                ; 
  LDA redraws@game
  AND REQ_CARD1
  BEQ @checkReqCard2
  LDA redraws@game
  EOR REQ_CARD1
  STA redraws@game
  JSR stop@renderer
  JSR redrawCard1@game
  JSR start@renderer
  RTS
@checkReqCard2:                ; 
  LDA redraws@game
  AND REQ_CARD2
  BEQ @checkReqCard3
  LDA redraws@game
  EOR REQ_CARD2
  STA redraws@game
  JSR stop@renderer
  JSR redrawCard2@game
  JSR start@renderer
  RTS
@checkReqCard3:                ; 
  LDA redraws@game
  AND REQ_CARD3
  BEQ @checkReqCard4
  LDA redraws@game
  EOR REQ_CARD3
  STA redraws@game
  JSR stop@renderer
  JSR redrawCard3@game
  JSR start@renderer
  RTS
@checkReqCard4:                ; 
  LDA redraws@game
  AND REQ_CARD4
  BEQ @checkReqXP
  LDA redraws@game
  EOR REQ_CARD4
  STA redraws@game
  JSR stop@renderer
  JSR redrawCard4@game
  JSR start@renderer
  RTS
@checkReqXP:                   ; 
  LDA redraws@game
  AND REQ_XP
  BEQ @checkReqRun
  LDA redraws@game
  EOR REQ_XP
  STA redraws@game
  JSR redrawExperience@game
  RTS
@checkReqRun:                  ; 
  LDA redraws@game
  AND REQ_RUN
  BEQ @checkReqDialog
  LDA redraws@game
  EOR REQ_RUN
  STA redraws@game
  JSR redrawRun@game
  RTS
@checkReqDialog:               ; 
  LDA reqdraw_dialog
  CMP #$00
  BEQ @done
  JSR redraw@dialog
  JSR fix@renderer
  LDA #$00
  STA reqdraw_dialog
  RTS
@done:                         ; 
  RTS

;;

show@game:                     ; 
  ; set game mode
  LDA #$01
  STA view@game
  STA reqdraw_game
  STA reqdraw_cursor
  JSR restart@game
  RTS

;;

restart@game:                  ; 
  JSR init@deck                ; deck
  JSR shuffle@deck
  JSR reset@player             ; player
  JSR enter@room
  LDA #$0D
  CLC
  ADC difficulty@player        ; reflect difficulty
  JSR show@dialog              ; dialog:difficulty
  LDA #$30                     ; reset room timer
  STA timer@room
  ; reset uistats
  RTS

;;

load@game:                     ; 
  ; clear background
  BIT PPUSTATUS                ; reset latch
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00
  LDY #$00
@loop:                         ; 
  LDA #$00                     ; sprite id
  STA PPUDATA
  INY
  CPY #$00
  BNE @loop
  INX
  CPX #$04
  BNE @loop
@interface:                    ; 
  BIT PPUSTATUS                ; read PPU status to reset the high/low latch
  LDA #$21                     ; HP H
  STA PPUADDR                  ; write the high byte
  LDA #$03
  STA PPUADDR                  ; write the low byte
  LDA #$12
  STA PPUDATA
  LDA #$1A                     ; HP P
  STA PPUDATA
  LDA #$21                     ; SP S
  STA PPUADDR                  ; write the high byte
  LDA #$0A
  STA PPUADDR                  ; write the low byte
  LDA #$1D
  STA PPUDATA
  LDA #$1A                     ; SP P
  STA PPUDATA
  LDA #$21                     ; XP X
  STA PPUADDR                  ; write the high byte
  LDA #$11
  STA PPUADDR                  ; write the low byte
  LDA #$22
  STA PPUDATA
  LDA #$1A                     ; XP P
  STA PPUDATA
  RTS

;;

interpolateStats@game:         ; 
  LDA spui@game                ; 
  CMP sp@player                ; sprite x
  BEQ @skip
  BCC @incShield
  DEC spui@game                ; when less
  JMP @redrawShield
@incShield:                    ; 
  INC spui@game
@redrawShield:                 ; 
  LDA redraws@game             ; request redraw
  ORA REQ_SP
  STA redraws@game
  RTS
@skip:                         ; 
  LDA hpui@game                ; interpolate health
  CMP hp@player                ; sprite x
  BEQ @done
  BCC @incHealth
  DEC hpui@game
  JMP @redrawHealth
@incHealth:                    ; 
  INC hpui@game
@redrawHealth:                 ; 
  LDA redraws@game             ; request redraw
  ORA REQ_HP
  STA redraws@game
@done:                         ; 
  RTS

;;

redrawCursor@game:             ; 
  ; remove flag
  LDA #$00
  STA reqdraw_cursor
  ; setup
  LDA #$B0
  STA $0200                    ; (part1)set tile.y pos
  LDA #$13
  STA $0201                    ; (part1)set tile.id
  LDA #$00
  STA $0202                    ; (part1)set tile.attribute[off]
  ;
  LDX cursor@game
  LDA selections@game, x
  STA $0203                    ; set tile.x pos
  ;
  LDA #$01                     ; request redraw
  JSR sprites@renderer
  STA reqdraw_name
@done:                         ; 
  RTS

;;

loadAttributes@game:           ; 
  BIT PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C0
  STA PPUADDR
  LDX #$00
@loop:                         ; 
  LDA attributes@game, x
  STA PPUDATA
  INX
  CPX #$40
  BNE @loop
  RTS

;; redraw

redrawHealth@game:             ; 
  ; remove flag
  LDA redraws@game
  EOR REQ_HP
  STA redraws@game
  ;
  LDY hpui@game
  BIT PPUSTATUS                ; read PPU status to reset the high/low latch
  ; pos
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$07
  STA PPUADDR                  ; write the low byte
  ; digits
  LDA number_high, y
  STA PPUDATA
  LDA number_low, y
  STA PPUDATA
  ; progress bar
  LDA healthbarpos, y          ; regA has sprite offset
  TAY                          ; regY has sprite offset
  LDX #$00
@loop:                         ; 
  LDA #$20
  STA PPUADDR                  ; write the high byte
  LDA healthbaroffset, x
  STA PPUADDR                  ; write the low byte
  LDA progressbar, y           ; regA has sprite id
  STA PPUDATA
  INY
  INX
  CPX #$06
  BNE @loop
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
  JSR fix@renderer
  RTS

;; shield value

redrawShield@game:             ; 
  ; remove flag
  LDA redraws@game
  EOR REQ_SP
  STA redraws@game
  ; 
  LDY spui@game
  BIT PPUSTATUS                ; read PPU status to reset the high/low latch
  ; pos
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$0E
  STA PPUADDR                  ; write the low byte
  ; digit 1
  LDA number_high, y
  STA PPUDATA
  LDA number_low, y
  STA PPUDATA
  ; 
  LDA shieldbarpos, y          ; regA has sprite offset
  TAY                          ; regY has sprite offset
  LDX #$00
@loop:                         ; 
  LDA #$20
  STA PPUADDR                  ; write the high byte
  LDA shieldbaroffset, x
  STA PPUADDR                  ; write the low byte
  LDA progressbar, y           ; regA has sprite id
  STA PPUDATA
  INY
  INX
  CPX #$06
  BNE @loop
  ; durability
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$0C
  STA PPUADDR                  ; write the low byte
  LDX dp@player
  LDA card_glyphs, x
  STA PPUDATA
  JSR fix@renderer
  RTS

;; experience value

redrawExperience@game:         ; 
  LDY xp@player
  BIT PPUSTATUS                ; read PPU status to reset the high/low latch
  ; pos
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$15
  STA PPUADDR                  ; write the low byte
  ; load xp in y
  LDA number_high, y           ; digit 1
  STA PPUDATA
  LDA number_low, y            ; digit 2
  STA PPUDATA
  ; progress bar
  LDA experiencebarpos, y      ; regA has sprite offset
  TAY                          ; regY has sprite offset
  LDX #$00
@loop:                         ; 
  LDA #$20
  STA PPUADDR                  ; write the high byte
  LDA experiencebaroffset, x
  STA PPUADDR                  ; write the low byte
  LDA progressbar, y           ; regA has sprite id
  STA PPUDATA
  INY
  INX
  CPX #$06
  BNE @loop
  JSR fix@renderer
  RTS

;;

redrawRun@game:                ; 
  JSR stop@renderer
  LDA length@deck              ; don't display the run butto on first hand
  CMP #$31                     ; deck is $36 - 4(first hand)
  BEQ @hide
  JSR loadRun@player           ; load canRun in regA
  CMP #$01
  BNE @hide
  LDA length@deck              ; Can't run the last room
  CMP #$00
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
  JSR start@renderer
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

;;

redrawName@game:               ; 
  BIT PPUSTATUS
  LDA #$21
  STA PPUADDR
  LDA #$43
  STA PPUADDR
  LDX #$00
@loop:                         ; 
  LDY #$01                     ; load card id
  ; load card name
  LDY cursor@game
  LDA card1@room, y
  TAY
  LDA card_names_offset_lb,y
  STA lb@temp
  LDA card_names_offset_hb,y
  STA hb@temp
  TYA
  STX id@temp
  CLC
  ADC id@temp
  TAY
  LDA (lb@temp), y             ; load value at 16-bit address from (lb@temp + hb@temp) + y
  ; draw sprite
  STA PPUDATA
  INX
  CPX #$10
  BNE @loop
  RTS

;; to merge into a single routine

redrawCard1@game:              ; 
  LDX #$00
@loop:                         ; 
  LDA card1pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card1pos_low, x
  STA PPUADDR                  ; write the low byte
  LDA card1@buffers, x
  STA PPUDATA                  ; set tile.x pos
  INX
  CPX #$36
  BNE @loop
  RTS

;;

redrawCard2@game:              ; 
  LDX #$00
@loop:                         ; 
  LDA card1pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card2pos_low, x
  STA PPUADDR                  ; write the low byte
  LDA card2@buffers, x
  STA PPUDATA
  INX
  CPX #$36
  BNE @loop
  RTS

;;

redrawCard3@game:              ; 
  LDX #$00
@loop:                         ; 
  LDA card3pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card3pos_low, x
  STA PPUADDR                  ; write the low byte
  LDA card3@buffers, x
  STA PPUDATA
  INX
  CPX #$36
  BNE @loop
  RTS

;;

redrawCard4@game:              ; 
  LDA #$00
  LDX #$00
@loop:                         ; 
  LDA card3pos_high, x
  STA PPUADDR                  ; write the high byte
  LDA card4pos_low, x
  STA PPUADDR                  ; write the low byte
  LDA card4@buffers, x
  STA PPUDATA
  INX
  CPX #$36
  BNE @loop
  RTS