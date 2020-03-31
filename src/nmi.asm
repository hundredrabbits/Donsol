
;; nmi

  LDA #$00
  STA SPRADDR                  ; set the low byte (00) of the RAM address
  LDA #$02
  STA SPRDMA                   ; set the high byte (02) of the RAM address, start the transfer

;; detect joy

readJoy:                       ; [skip]
  LDA #$01
  STA JOY1                     ; start reading
  STA down@input
  LSR a
  STA JOY1
@loop:                         ; 
  LDA JOY1
  LSR a
  ROL down@input
  BCC @loop

;;

saveJoy:                       ; [skip]
  LDA down@input
  CMP last@input
  BEQ @done
  STA last@input
  CMP #$00
  BEQ @done
  STA next@input
@done:                         ; 

;; route screens

sendView:                      ; 
  LDX view@game
  CPX #$00
  BNE @game
@splash:                       ; 
  JSR redrawScreen@splash
  JSR redrawCursor@splash
  RTI
@game:                         ; 
  JSR nmi@player
  JSR nmi@game                 ; in client
  JSR nmi@room
  RTI