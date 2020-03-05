
;; Setup

;; game start

GameStart:                     ; 
  ; reset health($15 = 21)
  LDA #$15
  STA health
  ; reset controls
  LDA #$00
  STA arrow_left_pressed
  STA arrow_right_pressed
  STA experience
  STA cursor_pos
  LDA #$01
  STA can_run 
  ; tests
  ; JSR runTests
  ; table
  ; JSR drawHand1
  ;
  ; JSR requestUpdateWipe
  ; JSR requestUpdateStats
  ; JSR requestUpdateCursor
  ; JSR requestUpdateCards
  JSR LoadBackground
  JSR LoadPalettes
  JSR LoadAttributes

;; Enable Renderer

EnableSprites:                 ; 
  LDA #%10010000               ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110               ; enable sprites, enable background, no clipping on left side
  STA $2001
  LDA #$00                     ; No background scrolling
  STA $2006
  STA $2006
  STA $2005
  STA $2005

;; jump back to Forever, infinite loop

Forever:                       ; 
  JMP Forever                 

;; background

LoadBackground:                ; 
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006
  LDX #$00
  LDY #$00
LoadBackgroundLoop:            ; 
  LDA #$10
  STA $2007
  INY
  CPY #$00
  BNE LoadBackgroundLoop
  INX
  CPX #$04
  BNE LoadBackgroundLoop
  RTS

;; Palettes

LoadPalettes:                  ; 
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

LoadAttributes:                ; 
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