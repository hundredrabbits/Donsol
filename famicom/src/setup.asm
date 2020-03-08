
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
  ; JSR runTests
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
  LDA #$01
  STA can_run
  RTS

;; clear background

loadBackground:                ; 
  LDA $2002                    ; reset latch
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006
  LDX #$00
  LDY #$00
LoadBackgroundLoop:            ; 
  LDA #$00                     ; sprite id
  STA $2007
  INY
  CPY #$00
  BNE LoadBackgroundLoop
  INX
  CPX #$04
  BNE LoadBackgroundLoop
  RTS

;; Palettes

loadPalettes:                  ; 
  LDA $2002
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006
  LDX #$00
LoadPalettesLoop:              ; 
  LDA palettes, x
  STA $2007
  INX
  CPX #$20
  BNE LoadPalettesLoop
  RTS

;; Attributes

loadAttributes:                ; 
  LDA $2002
  LDA #$23
  STA $2006
  LDA #$C0
  STA $2006
  LDX #$00
LoadAttributesLoop:            ; 
  LDA attributes, x
  STA $2007
  INX
  CPX #$40
  BNE LoadAttributesLoop
  RTS

;; Interface

loadInterface:                 ; 
  LDA $2000                    ; read PPU status to reset the high/low latch
  ; HP H
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$03
  STA $2006                    ; write the low byte of $2000 address
  LDA #$12
  STA $2007
  ; HP P
  LDA #$1A
  STA $2007
  ; SP S
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$0A
  STA $2006                    ; write the low byte of $2000 address
  LDA #$1D
  STA $2007
  ; SP P
  LDA #$1A
  STA $2007
  ; XP X
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$11
  STA $2006                    ; write the low byte of $2000 address
  LDA #$22
  STA $2007
  ; XP P
  LDA #$1A
  STA $2007
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
  STA $2000
  LDA #%00011110               ; enable sprites, enable background, no clipping on left side
  STA $2001
  LDA #$00                     ; No background scrolling
  STA $2006
  STA $2006
  STA $2005
  STA $2005
  RTS
renderStop:                    ; 
  LDA #%10000000               ; disable NMI, sprites from Pattern Table 0
  STA $2000
  LDA #%00000000               ; disable sprites
  STA $2001
  RTS