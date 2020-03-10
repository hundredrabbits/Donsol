
;; NMI

NMI:                           ; 
  LDA #$00
  STA SPRADDR                  ; set the low byte (00) of the RAM address
  LDA #$02
  STA SPRDMA                   ; set the high byte (02) of the RAM address, start the transfer

;; update

  JSR tic@room
  JSR interpolateStats         ; in client

;; update client only every 16th frame

  LDA timer@renderer
  CMP #$00
  BEQ doUpdate
  DEC timer@renderer
  JMP skipUpdate
doUpdate:                      ; 
  JSR updateClient             ; in client
  LDA #$08
  STA timer@renderer
skipUpdate:                    ; 

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
  JSR flip@room                ; flipcard(x: cursor)
  JSR lock@input
@b:                            ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @select
  ; askquit: leave(TODO)
  ; dungeon: run
  JSR tryRun
  JSR lock@input
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
  JSR lock@input
@down:                         ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @left
  NOP
  JSR lock@input
@left:                         ; 
  LDA JOY1
  AND #%00000001
  BEQ @right                   ; check if button is already pressed
  JSR left@input
  JSR lock@input
@right:                        ; 
  LDA JOY1
  AND #%00000001
  BEQ @done                    ; check if button is already pressed
  JSR right@input
  JSR lock@input
@done:                         ; 
  RTI                          ; return from interrupt

;; lock

lock@input:                    ; 
  LDA #$06
  STA timer@input
  RTS

;;

right@input:                   ; 
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
  JSR update@cursor
  RTS

;;

left@input:                    ; 
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
  JSR update@cursor
  RTS