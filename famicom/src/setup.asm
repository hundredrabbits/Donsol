
;; Setup

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

;; Interface

createInterface:               ; 
  LDA $2000                    ; read PPU status to reset the high/low latch
  ; HP H
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$03
  STA $2006                    ; write the low byte of $2000 address
  LDA #$12
  STA $2007  
  ; HP P
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$04
  STA $2006                    ; write the low byte of $2000 address
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
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$0B
  STA $2006                    ; write the low byte of $2000 address
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
  LDA #$21
  STA $2006                    ; write the high byte of $2000 address
  LDA #$12
  STA $2006                    ; write the low byte of $2000 address
  LDA #$1A
  STA $2007  
  ; fix
  LDA #$00                     ; No background scrolling
  STA $2005
  STA $2005

;; Cursor

CreateCursor:                  ; 
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