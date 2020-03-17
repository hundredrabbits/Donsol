
;;

main@game:                     ; 
  LDA view@game
  CMP #$01
  BEQ @inView
  ; when is on table
  NOP                          ; do nothing
@inView
  RTS

;;

nmi@game:                      ; during nmi
  LDA view@game
  CMP #$01
  BEQ @inView
  RTS
@inView:                       ; when is on game
  LDA timer@renderer
  CMP #$00
  BEQ @whenRender
  DEC timer@renderer
  RTS
@whenRender:                   ; 
  LDA #$02                     ; reset render timer to 2 frames
  STA timer@renderer
@beginDrawing:                 ; 
@checkReqSP:                   ; [skip]
  LDA redraws@game
  AND REQ_SP
  BEQ @checkReqHP
  LDA redraws@game
  EOR REQ_SP
  STA redraws@game
  JSR redrawShield@game
  RTS
@checkReqHP:                   ; 
  LDA redraws@game
  AND REQ_HP
  BEQ @checkName
  LDA redraws@game
  EOR REQ_HP
  STA redraws@game
  JSR redrawHealth@game
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
  JSR fix@renderer
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
  ; setup cursor
  JSR initCursor@game
  JSR updateCursor@game
  ; display
  JSR stop@renderer
  JSR load@game
  JSR loadAttributes@game
  JSR restart@game
  JSR start@renderer
  RTS

;;

restart@game:                  ; 
  ; deck
  JSR init@deck
  ; JSR shuffle@deck ; TODO re-add shuffle
  JSR hack@deck                ; TODO remove
  ; player
  JSR reset@player
  JSR enter@room
  ; dialog:difficulty
  LDA #$0D
  CLC
  ADC difficulty@player        ; reflect difficulty
  JSR show@dialog
  ; reset room timer
  LDA #$30
  STA timer@room
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

selectNext@game:               ; 
  LDA cursor@game
  CMP #$03
  BEQ @wrap
  INC cursor@game
  JMP @done
@wrap:                         ; 
  LDA #$00
  STA cursor@game
@done:                         ; 
  JSR updateCursor@game
  RTS

;;

selectPrev@game:               ; 
  LDA cursor@game
  CMP #$00
  BEQ @wrap
  DEC cursor@game
  JMP @done
@wrap:                         ; 
  LDA #$03
  STA cursor@game
@done:                         ; 
  JSR updateCursor@game
  RTS

;;

initCursor@game:               ; 
  LDA #$B0                     ; cursor(left)
  STA $0200                    ; set tile.y pos
  LDA #$10
  STA $0201                    ; set tile.id
  LDA #$00
  STA $0202                    ; set tile.attribute
  LDA #$88
  STA $0203                    ; set tile.x pos
  LDA #$B0                     ; cursor(right)
  STA $0204                    ; set tile.y pos
  LDA #$11
  STA $0205                    ; set tile.id
  LDA #$00
  STA $0206                    ; set tile.attribute
  LDA #$88
  STA $0207                    ; set tile.x pos
  RTS

;;

updateCursor@game:             ; 
  LDX cursor@game
  LDA selections@game, x
  STA $0203                    ; set tile.x pos
  CLC
  ADC #$08
  STA $0207                    ; set tile.x pos
  LDA #$01                     ; request redraw
  STA reqdraw_name
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
  LDA length@deck              ; don't display the run butto on first hand
  CMP #$31                     ; deck is $36 - 4(first hand)
  BEQ @hide
  JSR loadRun@player           ; load canRun in regA
  CMP #$01
  BNE @hide
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