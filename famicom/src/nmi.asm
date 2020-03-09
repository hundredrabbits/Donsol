
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
  LDA input_timer
  CMP #$00
  BEQ LatchController
  DEC input_timer
  RTI

;; latch

LatchController:               ; 
  LDA #$01
  STA JOY1
  LDA #$00
  STA JOY1                     ; tell both the controllers to latch buttons

;; a

ReadA:                         ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ ReadADone                ; check if button is already pressed
  LDX cursor
  JSR flipCard
  JSR lockInput
ReadADone:                     ; 

;; b

ReadB:                         ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ ReadBDone
  JSR tryRun
  JSR lockInput
ReadBDone:                     ; handling this button is done

;; select

ReadSel:                       ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ ReadSelDone
  JSR drawHand2
  JSR lockInput
ReadSelDone:                   ; handling this button is done

;; start

ReadStart:                     ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ ReadStartDone
  JSR drawHand2
  JSR lockInput
ReadStartDone:                 ; handling this button is done

;; up

ReadUp:                        ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ ReadUpDone
  NOP
  JSR lockInput
ReadUpDone:                    ; handling this button is done

;; down

ReadDown:                      ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ ReadDownDone
  NOP
  JSR lockInput
ReadDownDone:                  ; handling this button is done

;; left

ReadLeft:                      ; 
  LDA JOY1
  AND #%00000001
  BEQ ReadLeftDone             ; check if button is already pressed
  JSR moveCursorLeft
  JSR lockInput
ReadLeftDone:                  ; 

;; right

ReadRight:                     ; 
  LDA JOY1
  AND #%00000001
  BEQ ReadRightDone            ; check if button is already pressed
  JSR moveCursorRight
  JSR lockInput
ReadRightDone:                 ; 

;; end nmi

  RTI                          ; return from interrupt

;; lock

lockInput:                     ; 
  LDA #$06
  STA input_timer
  RTS