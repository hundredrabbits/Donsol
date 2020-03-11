
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
  JSR init@deck
  JSR shuffle@deck
  JSR reset@player
  JSR enter@room
  JSR requestUpdateStats
  JSR requestUpdateName
  ; set enter dialog
  LDA #$04
  JSR show@dialog
  ; reset room timer
  LDA #$30
  STA timer@room
  RTS

;;

load@game:                     ; 
  ; clear background
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
@interface:                    ; 
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
  RTS

;;

loadAttributes@game:           ; 
  LDA PPUSTATUS
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

;; test

somethingUsed:                 ; 
  RTS