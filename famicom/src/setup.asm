
;; Setup

GameStart:                     ; 
  JSR resetStats
  JSR drawHand1
  ; start drawing
  JSR loadBackground
  JSR loadPalettes
  JSR loadAttributes
  JSR loadInterface
  JSR loadCursor
  ; tests
  JSR runTests
  ; render
  JSR renderStop
  JSR requestUpdateStats
  JSR requestUpdateCursor
  JSR requestUpdateCards
  JSR requestUpdateRun
  JSR renderStart
  ; dialog
  LDA #$04
  STA dialog_id
  JSR requestUpdateDialog

;; jump back to Forever, infinite loop

Forever:                       ; 
  JMP Forever

;; reset stats

resetStats:                    ; 
  LDA #$15
  STA health
  STA ui_health
  LDA #$00
  STA shield
  STA shield_durability
  STA experience
  STA potion_sickness
  LDA #$00
  STA can_run
  RTS

;; clear background

loadBackground:                ; 
  LDA PPUSTATUS                ; reset latch
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
  RTS

;; Palettes

loadPalettes:                  ; 
  LDA PPUSTATUS
  LDA #$3F
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00
@loop:                         ; 
  LDA palettes, x
  STA PPUDATA
  INX
  CPX #$20
  BNE @loop
  RTS

;; Attributes

loadAttributes:                ; 
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C0
  STA PPUADDR
  LDX #$00
@loop:                         ; 
  LDA attributes, x
  STA PPUDATA
  INX
  CPX #$40
  BNE @loop
  RTS

;; Interface

loadInterface:                 ; 
  LDA PPUCTRL                  ; read PPU status to reset the high/low latch
  ; HP H
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$03
  STA PPUADDR                  ; write the low byte
  LDA #$12
  STA PPUDATA
  ; HP P
  LDA #$1A
  STA PPUDATA
  ; SP S
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$0A
  STA PPUADDR                  ; write the low byte
  LDA #$1D
  STA PPUDATA
  ; SP P
  LDA #$1A
  STA PPUDATA
  ; XP X
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$11
  STA PPUADDR                  ; write the low byte
  LDA #$22
  STA PPUDATA
  ; XP P
  LDA #$1A
  STA PPUDATA
  RTS

;; Cursor

loadCursor:                    ; 
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

;; renderer

renderStart:                   ; 
  LDA #%10010000               ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA PPUCTRL
  LDA #%00011110               ; enable sprites, enable background, no clipping on left side
  STA PPUMASK
  LDA #$00                     ; No background scrolling
  STA PPUADDR
  STA PPUADDR
  STA PPUSCROLL
  STA PPUSCROLL
  RTS

;;

renderStop:                    ; 
  LDA #%10000000               ; disable NMI, sprites from Pattern Table 0
  STA PPUCTRL
  LDA #%00000000               ; disable sprites
  STA PPUMASK
  RTS