
;; splash | holds the highscore count

main@splash:                   ; 
  LDA view@game
  CMP #$00
  BNE @done
  ; when is on splash
  INC seed@deck                ; increment random seed
@done:                         ; 
  RTS

;;

show@splash:                   ; 
  LDA #$00                     ; set splash mode
  STA view@game
  JSR initCursor@splash        ; setup cursor
  JSR updateCursor@splash
  JSR stop@renderer            ; display
  JSR load@splash
  JSR loadAttributes@splash
  JSR addScore@splash
  JSR addNecomedre@splash
  JSR start@renderer           ; done
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
  LDA #$00
  STA $0202                    ; (part1)set tile.attribute[off]
  STA $0204                    ; (part2)set tile.y pos[off]
  STA $0205                    ; (part2)set tile.id[off]
  STA $0206                    ; (part2)set tile.attribute[off]
  STA $0207                    ; (part2)set tile.x pos[off]
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

updateScore@splash:            ; 
  LDA xp@player                ; load xp
  CMP highscore@splash
  BCC @done
  STA highscore@splash
@done:                         ; 
  RTS

;;

addScore@splash:               ; 
  BIT PPUSTATUS                ; draw score on splash
  LDA #$20
  STA PPUADDR
  LDA #$EF
  STA PPUADDR
  LDX #$00
  LDX highscore@splash         ; digit 1
  LDA number_high, x
  STA PPUDATA
  LDA number_low, x
  STA PPUDATA
  RTS

;;

addNecomedre@splash:           ; $6a,$6b,$6e
  LDA highscore@splash
  CMP #$36
  BNE @skip
  BIT PPUSTATUS                ; draw score on splash
  ; head
  LDA #$22
  STA PPUADDR
  LDA #$48
  STA PPUADDR
  LDA #$6A
  STA PPUDATA
  ; torso
  LDA #$22
  STA PPUADDR
  LDA #$68
  STA PPUADDR
  LDA #$6B
  STA PPUDATA
  ; legs
  LDA #$22
  STA PPUADDR
  LDA #$88
  STA PPUADDR
  LDA #$6E
  STA PPUDATA
@skip:                         ; 
  RTS

;;

addPolycat@splash:             ; $6a,$6b,$6e
  LDA highscore@splash
  CMP #$36
  BNE @skip
  BIT PPUSTATUS                ; draw score on splash
  ; head
  LDA #$22
  STA PPUADDR
  LDA #$48
  STA PPUADDR
  LDA #$6A
  STA PPUDATA
  ; torso
  LDA #$22
  STA PPUADDR
  LDA #$68
  STA PPUADDR
  LDA #$6B
  STA PPUDATA
  ; legs
  LDA #$22
  STA PPUADDR
  LDA #$88
  STA PPUADDR
  LDA #$6E
  STA PPUDATA
@skip:                         ; 
  RTS

;;

  ; .db $80,$00
  ; .db $84,$94