
;; splash | holds the highscore count

show@splash:                   ; 
  ; set splash mode
  LDA #$00
  STA view@game
  ; setup cursor
  JSR initCursor@splash
  JSR updateCursor@splash
  ; display
  JSR stop@renderer
  JSR load@splash
  JSR redrawScore@splash
  JSR loadAttributes@splash
  JSR start@renderer
  RTS

;;

load@splash:                   ; 
  BIT PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDA #<data@splash
  STA lb@temp
  LDA #>data@splash
  STA hb@temp
  LDX #$00
  LDY #$00
@loop:                         ; 
  LDA (lb@temp), y
  STA PPUDATA
  INY
  CPY #$00
  BNE @loop
  INC hb@temp
  INX
  CPX #$04
  BNE @loop
  RTS

;;

loadAttributes@splash:         ; 
  BIT PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C0
  STA PPUADDR
  LDX #$00
@loop:                         ; 
  LDA attributes@splash, x
  STA PPUDATA
  INX
  CPX #$40
  BNE @loop
  RTS

;;

selectNext@splash:             ; 
  LDA cursor@splash
  CMP #$02
  BEQ @wrap
  INC cursor@splash
  JMP @done
@wrap:                         ; 
  LDA #$00
  STA cursor@splash
@done:                         ; 
  JSR updateCursor@splash
  RTS

;;

selectPrev@splash:             ; 
  LDA cursor@splash
  CMP #$00
  BEQ @wrap
  DEC cursor@splash
  JMP @done
@wrap:                         ; 
  LDA #$02
  STA cursor@splash
@done:                         ; 
  JSR updateCursor@splash
  RTS

;;

initCursor@splash:             ; 
  LDA #$C8
  STA $0200                    ; (part1)set tile.y pos
  LDA #$12
  STA $0201                    ; (part1)set tile.id
  LDA #$88
  STA $0203                    ; (part1)set tile.x pos
  ; off everything else
  LDA #$00
  STA $0202                    ; (part1)set tile.attribute
  STA $0204                    ; (part2)set tile.y pos
  STA $0205                    ; (part2)set tile.id
  STA $0206                    ; (part2)set tile.attribute
  STA $0207                    ; (part2)set tile.x pos
  RTS

;;

updateCursor@splash:           ; 
  LDX cursor@splash
  LDA selections@splash, x
  STA $0203                    ; set tile.x pos
  CLC
  ADC #$08
  STA $0207                    ; set tile.x pos
  RTS

;;

redrawScore@splash:            ; 
  BIT PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$EF
  STA PPUADDR
  LDX #$00
  ; digit 1
  LDX highscore@splash
  LDA number_high, x
  STA PPUDATA
  ; digit 2
  LDX highscore@splash
  LDA number_low, x
  STA PPUDATA
  RTS

;;

updateScore@splash:            ; 
  ; load xp
  LDA xp@player
  CMP highscore@splash
  BCC @done
  STA highscore@splash
@done:                         ; 
  RTS