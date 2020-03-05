
;; NMI

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer

;; update
  JSR interpolateStats
  JSR updateClient

;; skip latch if input is locked

  LDA input_lock
  CMP #$00
  BEQ LatchController
  DEC input_lock
  RTI

;; latch

LatchController:               ; 
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016                    ; tell both the controllers to latch buttons

;; a

ReadA:                         ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadADone                ; check if button is already pressed
  LDX cursor_pos
  JSR flipCard
  JSR lockInput
ReadADone:                     ; 

;; b

ReadB:                         ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadBDone
  JSR lockInput
ReadBDone:                     ; handling this button is done

;; select

ReadSel:                       ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadSelDone 
  JSR drawHand2
  JSR lockInput
ReadSelDone:                   ; handling this button is done

;; start

ReadStart:                     ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadStartDone 
  JSR drawHand2
  JSR lockInput
ReadStartDone:                 ; handling this button is done

;; up

ReadUp:                        ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadUpDone 
  NOP
  JSR lockInput
ReadUpDone:                    ; handling this button is done

;; down

ReadDown:                      ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadDownDone 
  NOP
  JSR lockInput
ReadDownDone:                  ; handling this button is done

;; left

ReadLeft:                      ; 
  LDA $4016
  AND #%00000001
  BEQ ReadLeftDone             ; check if button is already pressed
  JSR moveCursorLeft
  JSR lockInput
ReadLeftDone:                  ; 

;; right

ReadRight:                     ; 
  LDA $4016
  AND #%00000001
  BEQ ReadRightDone            ; check if button is already pressed
  JSR moveCursorRight
  JSR lockInput
ReadRightDone:                 ; 

;; end nmi

  RTI                          ; return from interrupt

;; lock

lockInput:                     ; 
  LDA #$08
  STA input_lock
  RTS