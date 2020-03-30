
;; nmi

  LDA #$00
  STA SPRADDR                  ; set the low byte (00) of the RAM address
  LDA #$02
  STA SPRDMA                   ; set the high byte (02) of the RAM address, start the transfer

;; input

  JSR nmi@splash
  JSR nmi@player
  JSR nmi@game                 ; in client
  JSR nmi@room

;; nmi

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