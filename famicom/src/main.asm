  JSR LoadBackground
  JSR LoadPalettes
  JSR LoadAttributes
  JSR GameStart

EnableSprites:
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001
  
  LDA #$00         ; No background scrolling
  STA $2006
  STA $2006
  STA $2005
  STA $2005

Forever:
  JMP Forever     ;jump back to Forever, infinite loop

LoadBackground:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #<background ; Loading the #LOW(var) byte in asm6
  STA pointerBackgroundLowByte
  LDA #>background ; Loading the #HIGH(var) byte in asm6
  STA pointerBackgroundHighByte

  LDX #$00
  LDY #$00
LoadBackgroundLoop:
  LDA (pointerBackgroundLowByte), y
  STA $2007
  INY
  CPY #$00
  BNE LoadBackgroundLoop
  INC pointerBackgroundHighByte
  INX
  CPX #$04
  BNE LoadBackgroundLoop
  RTS

LoadPalettes:
  LDA $2002
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006

  LDX #$00
LoadPalettesLoop:
  LDA palettes, x
  STA $2007
  INX
  CPX #$20
  BNE LoadPalettesLoop
  RTS

LoadAttributes:
  LDA $2002
  LDA #$23
  STA $2006
  LDA #$C0
  STA $2006
  LDX #$00
LoadAttributesLoop:
  LDA attributes, x
  STA $2007
  INX
  CPX #$40
  BNE LoadAttributesLoop
  RTS

GameStart:
  ; reset health(default 21)
  LDA #21
  STA health_max
  LDA health_max
  STA health
  ; reset controls
  LDA #$00
  STA arrow_left_pressed
  STA arrow_right_pressed
  RTS



NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016       ; tell both the controllers to latch buttons

ReadA: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadADone
  NOP
ReadADone:        ; handling this button is done
  
ReadB: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadBDone
  NOP
ReadBDone:        ; handling this button is done

ReadSel: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadSelDone 
  NOP
ReadSelDone:        ; handling this button is done

ReadStart: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadStartDone 
  NOP
ReadStartDone:        ; handling this button is done

ReadUp: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadUpDone 
  NOP
ReadUpDone:        ; handling this button is done

ReadDown: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadDownDone 
  NOP
ReadDownDone:        ; handling this button is done

ReadLeft: 
  LDA $4016
  AND #%00000001
  BEQ ReadLeftRelease  ; check if button is already pressed
  LDA arrow_left_pressed
  CMP #$01
  BEQ ReadLeftDone
  JSR selectPrevCard ; record press
  LDA #$01
  STA arrow_left_pressed 
  JMP ReadLeftDone
ReadLeftRelease: ; record release
  LDA #$00
  STA arrow_left_pressed 
ReadLeftDone:

ReadRight: 
  LDA $4016
  AND #%00000001
  BEQ ReadRightRelease ; check if button is already pressed
  LDA arrow_right_pressed
  CMP #$01
  BEQ ReadRightDone
  JSR selectNextCard ; record press
  LDA #$01
  STA arrow_right_pressed 
  JMP ReadRightDone
ReadRightRelease: ; record release
  LDA #$00
  STA arrow_right_pressed 
ReadRightDone:
  
  RTI             ; return from interrupt
  
; selection

selectNextCard:
  LDA ui_selection
  CMP #$03
  BEQ selectNextAround
  INC ui_selection
  JMP selectNextDone
selectNextAround:
  LDA #$00
  STA ui_selection
selectNextDone:
  RTS

selectPrevCard:
  LDA ui_selection
  CMP #$00
  BEQ selectPrevAround
  DEC ui_selection
  JMP selectPrevDone
selectPrevAround:
  LDA #$03
  STA ui_selection
selectPrevDone:
  RTS