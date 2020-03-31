
;; room

nmi@room:                      ; update from the nmi
  ; check if player is alive
  LDA hp@player
  CMP #$00
  BEQ @death
  ; look for unflipped cards
  LDA card1@room
  CMP #$36
  BNE @done
  LDA card2@room
  CMP #$36
  BNE @done
  LDA card3@room
  CMP #$36
  BNE @done
  LDA card4@room
  CMP #$36
  BNE @done
  ; when the room is complete
  LDA timer@room
  CMP #$00
  BEQ @proceed
  DEC timer@room
  RTS
@death:                        ; 
  LDA #$36                     ; flip all cards
  STA card1@room
  STA card2@room
  STA card3@room
  STA card4@room
  JSR updateBuffers@room       ; TODO: Should not do this during NMI?! update buffers
  RTS
@proceed:                      ; 
  ; check if game is complete
  LDA xp@player
  CMP #$36
  BNE @incomplete
  ; when dungeon is complete
  LDA #$10                     ; dialog:victory
  JSR show@dialog
  RTS
@incomplete
  ; reset ran flag
  LDA #$00
  STA has_run@player
  ; reset timer
  LDA #$30
  STA timer@room
  ; go on..
  JSR enter@room               ; TODO: Should not do this during NMI?!
@done:                         ; 
  RTS

;;

enter@room:                    ; 
  JSR pullCard@deck            ; pull card1
  LDY hand@deck
  TYA
  STA card1@room
  JSR pullCard@deck            ; pull card2
  LDY hand@deck
  TYA
  STA card2@room
  JSR pullCard@deck            ; pull card3
  LDY hand@deck
  TYA
  STA card3@room
  JSR pullCard@deck            ; pull card4
  LDY hand@deck
  TYA
  STA card4@room
  ; etcs
  JSR updateBuffers@room
  JSR updateExperience@player  ; update experience
  ; need redraws
  LDA #$01
  STA reqdraw_name
  ; new draws
  LDA #%11111111
  STA redraws@game
  RTS

;; flip card from the table, used in controls when press

tryFlip@room:                  ; 
  ;
  LDA hp@player
  CMP #$00
  BEQ @skip
  ; when player is alive
  LDX cursor@game              ; load card at cursor position
  LDA card1@room, x
  CMP #$36
  BEQ @skip
  ; when card is not flipped
  JSR flipCard@room
@skip:                         ; 
  RTS

;;

flipCard@room:                 ; (x:card_pos) ->
  TAY                          ; pick card
  JSR pickCard@deck
  LDA #$36                     ; flip card
  STA card1@room, x
@done:                         ; post flipping a card
  JSR updateBuffers@room       ; update card buffers
  JSR updateExperience@player  ; update experience
  JSR updateScore@splash
  ; need redraws
  LDA #%11111111               ; TODO | be more selective with the redraw, don't redraw all cards if not needed!
  STA redraws@game
@skip
  RTS

;; return non-flipped cards back to the end of the deck

returnCards@room:              ; 
  LDY #$00                     ; increment
@loop
  LDA card1@room, y
  CMP #$36
  BEQ @skip
  JSR returnCard@deck          ; warning: write on regX
@skip
  INY
  CPY #$04
  BNE @loop
  RTS

;; count enemy cards left in play

loadEnemiesLeft@room:          ; () -> x:count
  LDX #$00                     ; count
  LDY #$00                     ; increment
@loop
  LDA card1@room, y
  CMP #$20
  BCC @skip                    ; heart/diamonds
  CMP #$36
  BEQ @skip                    ; don't count flipped cards
  INX
@skip
  INY
  CPY #$04
  BNE @loop
  RTS

;; count cards left in play

loadCardsLeft@room:            ; () -> x:count
  LDX #$00                     ; count
  LDY #$00                     ; increment
@loop
  LDA card1@room, y
  CMP #$36
  BEQ @skip
  INX
@skip
  INY
  CPY #$04
  BNE @loop
  RTS

;; notes

; Form a 16-bit address contained in the given location, AND the one 
; following.  Add to that address the contents of the Y register.  
; Fetch the value stored at that address.
; 
;   LDA ($B4),Y  where Y contains 6
;   
; If $B4 contains $EE AND $B5 contains $12 then the value at memory 
; location $12EE + Y (6) = $12F4 is fetched AND put in the accumulator.

;;

updateBuffers@room:            ; TODO maybe turn into a loop..
  ; card 1 buffer
  LDA #$00
  STA id@temp
  LDX #$00
  LDY card1@room, x
  LDA cards_offset_low, y      ; find card offset
  STA lb@temp
  LDA cards_offset_high, y
  STA hb@temp
@loop1
  LDY id@temp
  LDA (lb@temp), y             ; load value at 16-bit address from (lb@temp + hb@temp) + y
  STA card1@buffers, y         ; store in buffer
  INC id@temp
  LDA id@temp
  CMP #$36
  BNE @loop1
  ; card 2 buffer
  LDA #$00
  STA id@temp
  LDX #$01
  LDY card1@room, x
  LDA cards_offset_low, y      ; find card offset
  STA lb@temp
  LDA cards_offset_high, y
  STA hb@temp
@loop2
  LDY id@temp
  LDA (lb@temp), y             ; load value at 16-bit address from (lb@temp + hb@temp) + y
  STA card2@buffers, y         ; store in buffer
  INC id@temp
  LDA id@temp
  CMP #$36
  BNE @loop2
  ; card 3 buffer
  LDA #$00
  STA id@temp
  LDX #$02
  LDY card1@room, x
  LDA cards_offset_low, y      ; find card offset
  STA lb@temp
  LDA cards_offset_high, y
  STA hb@temp
@loop3
  LDY id@temp
  LDA (lb@temp), y             ; load value at 16-bit address from (lb@temp + hb@temp) + y
  STA card3@buffers, y         ; store in buffer
  INC id@temp
  LDA id@temp
  CMP #$36
  BNE @loop3
  ; card 4 buffer
  LDA #$00
  STA id@temp
  LDX #$03
  LDY card1@room, x
  LDA cards_offset_low, y      ; find card offset
  STA lb@temp
  LDA cards_offset_high, y
  STA hb@temp
@loop4
  LDY id@temp
  LDA (lb@temp), y             ; load value at 16-bit address from (lb@temp + hb@temp) + y
  STA card4@buffers, y         ; store in buffer
  INC id@temp
  LDA id@temp
  CMP #$36
  BNE @loop4
  RTS