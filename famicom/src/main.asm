  JSR LoadPalettes
  JSR GameStart

DrawCursor:
  LDA #$88
  STA $0200        ; set tile.y pos
  LDA #$05
  STA $0201        ; set tile.id
  LDA #$00
  STA $0202        ; set tile.attribute
  LDA #$88
  STA $0203        ; set tile.x pos

  JSR update

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
  ; draw cards
  JSR drawCards
  JSR updateCursor
  RTS

; a -> select
; left -> select prev
; right -> select next

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
  BEQ ReadARelease  ; check if button is already pressed
  LDA a_pressed
  CMP #$01
  BEQ ReadADone
  JSR selectCard ; record press
  LDA #$01
  STA a_pressed 
  JMP ReadADone
ReadARelease: ; record release
  LDA #$00
  STA a_pressed 
ReadADone:
  
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

selectCard:
  LDX ui_selection ; load selection in X
  LDA card1, x     ; select card on table
  STA card_last    ; 
  LDX card_last
  LDA card_types, x
  STA card_last_type
  LDA card_values, x
  STA card_last_value
selectCardType:
  LDA card_types, x
  CMP #$00
  BEQ selectCardHeart
  CMP #$01
  BEQ selectCardDiamond
  CMP #$02
  BEQ selectCardSpade
  CMP #$03
  BEQ selectCardClub
  CMP #$04
  BEQ selectCardJoker
  RTS

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
  JSR updateCursor
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
  JSR updateCursor
  RTS

selectCardHeart:
  INC $40
  RTS

selectCardDiamond:
  INC $41
  RTS

selectCardSpade:
  INC $42
  RTS

selectCardClub:
  INC $43
  RTS

selectCardJoker:
  INC $44
  RTS

; cards

drawCards:
  LDA #$03   ; heart 4
  STA card1
  LDA #$11   ; diamond 5
  STA card2
  LDA #$1f   ; spades 6
  STA card3
  LDA #$2d   ; club 7
  STA card4
  RTS

; update

update:
updateCursor:
  LDX ui_selection
  LDA cursor_positions, x
  STA $0203        ; set tile.x pos
  RTS