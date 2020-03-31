
;; splash

nmi@splash:                    ; during nmi
  LDA view@game
  CMP #$00
  BNE @done
  ; when in view
@checkSplash:                  ; 
  LDA reqdraw_splash
  CMP #$01
  BNE @checkCursor
  JSR redrawScreen@splash
  RTS
@checkCursor:                  ; 
  LDA reqdraw_cursor
  CMP #$01
  BNE @done
  JSR redrawCursor@splash
  RTS
@done:                         ; 
  RTS

;; request redraw flags for the splash

show@splash:                   ; 
  LDA #$00
  STA view@game                ; set view
  LDA #$01
  STA reqdraw_splash
  STA reqdraw_cursor
  RTS

;;

redrawCursor@splash:           ; 
  ; remove flag
  LDA #$00
  STA reqdraw_cursor
  ; setup
  LDA #$C8
  STA $0200                    ; (part1)set tile.y pos
  LDA #$12
  STA $0201                    ; (part1)set tile.id
  LDA #$00
  STA $0202                    ; (part1)set tile.attribute[off]
  ; 
  LDX cursor@splash
  LDA selections@splash, x
  STA $0203                    ; set tile.x pos
  JSR sprites@renderer
@done:                         ; 
  RTS

;;

redrawScreen@splash:           ; 
  ; remove flag
  LDA #$00
  STA reqdraw_splash
  ; when needs redraw
  JSR stop@renderer
  JSR load@splash
  JSR loadAttributes@splash
  JSR addScore@splash
  JSR addNecomedre@splash
  JSR addPolycat@splash
  JSR start@renderer
@done
  RTS

;;

;; load background table

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

;; load attribute table

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
  LDA difficulty@splash
  CMP #$00
  BEQ @skip
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
  LDA difficulty@splash
  CMP #$00
  BEQ @skip
  CMP #$01
  BEQ @skip
  BIT PPUSTATUS                ; draw score on splash
  ; head
  LDA #$22
  STA PPUADDR
  LDA #$77
  STA PPUADDR
  LDA #$80
  STA PPUDATA
  ; torso
  LDA #$22
  STA PPUADDR
  LDA #$98
  STA PPUADDR
  LDA #$94
  STA PPUDATA
  ; legs
  LDA #$22
  STA PPUADDR
  LDA #$97
  STA PPUADDR
  LDA #$84
  STA PPUDATA
@skip:                         ; 
  RTS