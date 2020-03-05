
;; NMI

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer
  JSR updateClient
LatchController:               ; 
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016                    ; tell both the controllers to latch buttons
ReadA:                         ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadARelease             ; check if button is already pressed
  LDA a_pressed
  CMP #$01
  BEQ ReadADone
  LDX cursor_pos
  JSR flipCard
  LDA #$01
  STA a_pressed 
  JMP ReadADone
ReadARelease:                  ; record release
  LDA #$00
  STA a_pressed 
ReadADone:                     ; 
ReadB:                         ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadBDone
  NOP
ReadBDone:                     ; handling this button is done
ReadSel:                       ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadSelDone 
  JSR drawHand2
ReadSelDone:                   ; handling this button is done
ReadStart:                     ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadStartDone 
  JSR drawHand2
ReadStartDone:                 ; handling this button is done
ReadUp:                        ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadUpDone 
  NOP
ReadUpDone:                    ; handling this button is done
ReadDown:                      ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadDownDone 
  NOP
ReadDownDone:                  ; handling this button is done
ReadLeft:                      ; 
  LDA $4016
  AND #%00000001
  BEQ ReadLeftRelease          ; check if button is already pressed
  LDA arrow_left_pressed
  CMP #$01
  BEQ ReadLeftDone
  JSR moveCursorLeft           ; record press
  LDA #$01
  STA arrow_left_pressed 
  JMP ReadLeftDone
ReadLeftRelease:               ; record release
  LDA #$00
  STA arrow_left_pressed 
ReadLeftDone:                  ; 
ReadRight:                     ; 
  LDA $4016
  AND #%00000001
  BEQ ReadRightRelease         ; check if button is already pressed
  LDA arrow_right_pressed
  CMP #$01
  BEQ ReadRightDone
  JSR moveCursorRight          ; record press
  LDA #$01
  STA arrow_right_pressed 
  JMP ReadRightDone
ReadRightRelease:              ; record release
  LDA #$00
  STA arrow_right_pressed 
ReadRightDone:                 ; 
  RTI                          ; return from interrupt