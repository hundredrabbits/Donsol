
;; splash

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
  JSR loadAttributes@splash
  JSR start@renderer
  RTS

;;

load@splash:                   ; 
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006
  LDA #<data@splash
  STA lb@splash
  LDA #>data@splash
  STA hb@splash
  LDX #$00
  LDY #$00
@loop:                         ; 
  LDA (lb@splash), y
  STA $2007
  INY
  CPY #$00
  BNE @loop
  INC hb@splash
  INX
  CPX #$04
  BNE @loop
  RTS

;;

loadAttributes@splash:         ; 
  LDA PPUSTATUS
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

select@splash:                 ; 
  ; set difficulty
  LDA cursor@splash
  STA difficulty@player
  ; TODO: Set shuffle seed here
  JSR show@game
  RTS

;;

return@splash:                 ; 
  ; set difficulty
  LDA cursor@splash
  STA difficulty@player
  ; TODO: Set shuffle seed here
  JSR stop@renderer
  JSR show@game
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