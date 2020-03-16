
;; nmi

  LDA #$00
  STA SPRADDR                  ; set the low byte (00) of the RAM address
  LDA #$02
  STA SPRDMA                   ; set the high byte (02) of the RAM address, start the transfer

;; input

  JSR nmi@input
  JSR nmi@player
  JSR nmi@game                 ; in client
  JSR nmi@room

;; check if input timer is ready

  LDA timer@input
  CMP #$00
  BEQ @latch
  RTI

;; controllers

@latch:                        ; 
  LDA #$01
  STA JOY1
  LDA #$00
  STA JOY1                     ; tell both the controllers to latch buttons
@a:                            ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @b                       ; check if button is already pressed
  LDA BUTTON_A
  STA last@input
@b:                            ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @select
  LDA BUTTON_B
  STA last@input
@select:                       ; 
  LDA JOY1
  AND #%00000001
  BEQ @start
  LDA BUTTON_SELECT
  STA last@input
@start:                        ; 
  LDA JOY1
  AND #%00000001
  BEQ @up
  LDA BUTTON_START
  STA last@input
@up:                           ; 
  LDA JOY1
  AND #%00000001
  BEQ @down
  NOP                          ; unused/disabled in Donsol
@down:                         ; 
  LDA JOY1
  AND #%00000001
  BEQ @left
  NOP                          ; unused/disabled in Donsol
@left:                         ; 
  LDA JOY1
  AND #%00000001
  BEQ @right
  LDA BUTTON_LEFT
  STA last@input
@right:                        ; 
  LDA JOY1
  AND #%00000001
  BEQ @done
  LDA BUTTON_RIGHT
  STA last@input
@done:                         ; 