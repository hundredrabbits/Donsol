
;; NMI

NMI:                           ; 
  LDA #$00
  STA SPRADDR                  ; set the low byte (00) of the RAM address
  LDA #$02
  STA SPRDMA                   ; set the high byte (02) of the RAM address, start the transfer

;; update

  JSR checkRoomTimer           ; in core
  JSR interpolateStats         ; in client
  JSR updateClient             ; in client

;; skip latch if input is locked

checkInputLock:                ; 
  LDA timer@input
  CMP #$00
  BEQ @latch
  DEC timer@input
  RTI

;; latch

@latch:                        ; 
  LDA #$01
  STA JOY1
  LDA #$00
  STA JOY1                     ; tell both the controllers to latch buttons
@a:                            ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @b                       ; check if button is already pressed
  LDX cursor
  JSR flipCard                 ; flipcard(x: cursor)
  JSR lockInput
@b:                            ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @select
  ; askquit: leave(TODO)
  ; dungeon: run
  JSR tryRun
  JSR lockInput
@select:                       ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @start
  NOP                          ; do nothing
  JSR askQuit@game
@start:                        ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @up
  NOP                          ; do nothing
@up:                           ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @down
  NOP
  JSR lockInput
@down:                         ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @left
  NOP
  JSR lockInput
@left:                         ; 
  LDA JOY1
  AND #%00000001
  BEQ @right                   ; check if button is already pressed
  JSR moveLeft
  JSR lockInput
@right:                        ; 
  LDA JOY1
  AND #%00000001
  BEQ @done                    ; check if button is already pressed
  JSR moveRight
  JSR lockInput
@done:                         ; 
  RTI                          ; return from interrupt

;; lock

lockInput:                     ; 
  LDA #$06
  STA timer@input
  RTS

;;

moveRight:                     ; 
  LDA cursor
  CMP #$03
  BEQ @wrap
  INC cursor
  JMP @done
@wrap:                         ; 
  LDA #$00
  STA cursor
@done:                         ; 
  JSR requestUpdateName
  JSR requestUpdateCursor
  RTS

;;

moveLeft:                      ; 
  LDA cursor
  CMP #$00
  BEQ @wrap
  DEC cursor
  JMP @done
@wrap:                         ; 
  LDA #$03
  STA cursor
@done:                         ; 
  JSR requestUpdateName
  JSR requestUpdateCursor
  RTS