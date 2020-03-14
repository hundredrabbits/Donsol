
;; room

update@room:                   ; update from the nmi
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
@proceed:                      ; 
  ; check if game is complete
  LDA xp@player
  CMP #$35
  BNE @incomplete
  ; when dungeon is complete
  LDA #$10                     ; dialog:sickness
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
  JSR enter@room
@done:                         ; 
  RTS

;;

enter@room:                    ; 
  JSR pull@deck                ; pull card1
  LDY hand@deck
  TYA
  STA card1@room
  JSR pull@deck                ; pull card2
  LDY hand@deck
  TYA
  STA card2@room
  JSR pull@deck                ; pull card3
  LDY hand@deck
  TYA
  STA card3@room
  JSR pull@deck                ; pull card4
  LDY hand@deck
  TYA
  STA card4@room
  ; etcs
  ; need redraws
  LDA #$01
  STA reqdraw_card1
  STA reqdraw_card2
  STA reqdraw_card3
  STA reqdraw_card4
  STA reqdraw_run
  STA reqdraw_hp
  STA reqdraw_sp
  STA reqdraw_xp
  STA reqdraw_name
  RTS

;; flip card from the table, used in controls when press

flip@room:                     ; (x:card_pos) ->
  LDA hp@player
  CMP #$00
  BEQ @done
  ; when player is alive
  LDA card1@room, x
  CMP #$36
  BEQ @done
  ; when card is not flipped
  TAY                          ; pick card
  JSR pickCard
  LDA #$36                     ; flip card
  STA card1@room, x
  LDA #$01                     ; request draw
  STA reqdraw_card1, x
@done:                         ; 
  ; update experience
  JSR loadExperience@player
  STA xp@player
  JSR updateScore@splash       ; update highscore
  ; need redraws
  LDA #$01
  STA reqdraw_run
  STA reqdraw_hp
  STA reqdraw_sp
  STA reqdraw_xp
  RTS

;; TODO no need to count, could just check if there is any monster left.

enemiesLeft@room:              ; () -> a:count
  LDX #$00
@card1:                        ; 
  LDY card1@room
  LDA card_enemies, y
  CMP #$01
  BNE @card2
  INX
@card2:                        ; 
  LDY card2@room
  LDA card_enemies, y
  CMP #$01
  BNE @card3
  INX
@card3:                        ; 
  LDY card3@room
  LDA card_enemies, y
  CMP #$01
  BNE @card4
  INX
@card4:                        ; 
  LDY card4@room
  LDA card_enemies, y
  CMP #$01
  BNE @done
  INX
@done:                         ; 
  TXA
  RTS

;; count cards left in play

loadCoundCardsLeft@room:       ; () -> x:count
  LDX #$04
@card1:                        ; 
  LDA card1@room
  CMP #$36
  BNE @card2
  DEX
@card2:                        ; 
  LDA card2@room
  CMP #$36
  BNE @card3
  DEX
@card3:                        ; 
  LDA card3@room
  CMP #$36
  BNE @card4
  DEX
@card4:                        ; 
  LDA card4@room
  CMP #$36
  BNE @done
  DEX
@done:                         ; 
  RTS

;; return non-flipped cards back to the end of the deck

returnCards@room:              ; 
  LDY #$00
@loop
  LDA card1@room, y
  CMP #$36
  BEQ @continue
  JSR return@deck              ; warning: write on regX
@continue
  INY
  CPY #$04
  BNE @loop
  RTS