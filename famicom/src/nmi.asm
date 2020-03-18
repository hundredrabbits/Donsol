
;; nmi, ends on [RTI]

  LDA #$00
  STA SPRADDR                  ; set the low byte (00) of the RAM address
  LDA #$02
  STA SPRDMA                   ; set the high byte (02) of the RAM address, start the transfer

;;

  LDA view@game
  CMP #$01
  BEQ nmi@game

;;

nmi@splash:                    ; 
  LDA reqdraw_splash
  CMP #$01
  BNE @skip                    ; 
  JSR stop@renderer            ; display
  JSR initCursor@splash        ; setup cursor
  JSR updateCursor@splash
  JSR load@splash
  JSR addScore@splash
  JSR addNecomedre@splash
  JSR addPolycat@splash
  JSR start@renderer           ; done
  ; remove redraw flag
  LDA #$00
  STA reqdraw_splash
@skip:                         ; 
  JMP unlockJoy

;;

nmi@game:                      ; during nmi
  LDA timer@renderer
  CMP #$00
  BEQ @whenRender
  DEC timer@renderer
  JMP @done
@whenRender:                   ; 
  LDA #$02                     ; reset render timer to 2 frames
  STA timer@renderer
@beginDrawing:                 ; 
@checkReqSP:                   ; [skip]
  LDA redraws@game
  AND REQ_SP
  BEQ @checkReqHP
  LDA redraws@game
  EOR REQ_SP
  STA redraws@game
  JSR redrawShield@game
  RTI
@checkReqHP:                   ; 
  LDA redraws@game
  AND REQ_HP
  BEQ @checkName
  LDA redraws@game
  EOR REQ_HP
  STA redraws@game
  JSR redrawHealth@game
  RTI
@checkName
  LDA reqdraw_name
  CMP #$00
  BEQ @checkReqCard1
  JSR redrawName@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_name
  RTI
@checkReqCard1:                ; 
  LDA redraws@game
  AND REQ_CARD1
  BEQ @checkReqCard2
  LDA redraws@game
  EOR REQ_CARD1
  STA redraws@game
  JSR stop@renderer
  JSR redrawCard1@game
  JSR start@renderer
  RTI
@checkReqCard2:                ; 
  LDA redraws@game
  AND REQ_CARD2
  BEQ @checkReqCard3
  LDA redraws@game
  EOR REQ_CARD2
  STA redraws@game
  JSR stop@renderer
  JSR redrawCard2@game
  JSR start@renderer
  RTI
@checkReqCard3:                ; 
  LDA redraws@game
  AND REQ_CARD3
  BEQ @checkReqCard4
  LDA redraws@game
  EOR REQ_CARD3
  STA redraws@game
  JSR stop@renderer
  JSR redrawCard3@game
  JSR start@renderer
  RTI
@checkReqCard4:                ; 
  LDA redraws@game
  AND REQ_CARD4
  BEQ @checkReqXP
  LDA redraws@game
  EOR REQ_CARD4
  STA redraws@game
  JSR stop@renderer
  JSR redrawCard4@game
  JSR start@renderer
  RTI
@checkReqXP:                   ; 
  LDA redraws@game
  AND REQ_XP
  BEQ @checkReqRun
  LDA redraws@game
  EOR REQ_XP
  STA redraws@game
  JSR redrawExperience@game
  RTI
@checkReqRun:                  ; 
  LDA redraws@game
  AND REQ_RUN
  BEQ @checkReqDialog
  LDA redraws@game
  EOR REQ_RUN
  STA redraws@game
  JSR redrawRun@game
  RTI
@checkReqDialog:               ; 
  LDA reqdraw_dialog
  CMP #$00
  BEQ @done
  JSR redraw@dialog
  JSR fix@renderer
  LDA #$00
  STA reqdraw_dialog
  RTI
@done:                         ; 

;;

nmi@player:                    ; 
  LDA view@game
  CMP #$01                     ; 
  BEQ @inView
  RTS
@inView:                       ; 
; interpolate shield
  LDA spui@game                ; follower x
  CMP sp@player                ; sprite x
  BEQ @skip
  BCC @incShield
@decShield:                    ; 
  DEC spui@game
  LDA redraws@game             ; request redraw
  ORA REQ_SP
  STA redraws@game
  RTS
@incShield:                    ; 
  INC spui@game
  LDA redraws@game             ; request redraw
  ORA REQ_SP
  STA redraws@game
  RTS
@skip:                         ; 
  ; interpolate health
  LDA hpui@game                ; follower x
  CMP hp@player                ; sprite x
  BEQ @done
  BCC @incHealth
@decHealth:                    ; 
  DEC hpui@game
  LDA redraws@game             ; request redraw
  ORA REQ_HP
  STA redraws@game
  RTS
@incHealth:                    ; 
  INC hpui@game
  LDA redraws@game             ; request redraw
  ORA REQ_HP
  STA redraws@game
  RTS
@done:                         ; 
  RTS

;;

nmi@room:                      ; update from the nmi
  LDA view@game
  CMP #$01                     ; 
  BEQ @inView
  RTS
@inView:                       ; 
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
  JSR updateBuffers@room       ; update buffers
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
  JSR enter@room
@done:                         ; 
  RTS

;; run input timer

unlockJoy:                     ; 
  LDA timer@input              ; set in main
  CMP #$00
  BEQ @done
  DEC timer@input              ; timer is locked
  RTI
@done:                         ; 

;;

readJoy:                       ; 
  LDA #$01
  STA JOY1
  STA buttons
  LSR a
  STA JOY1
@loop:                         ; 
  LDA JOY1
  LSR a
  ROL buttons
  BCC @loop
@trigger
  LDA buttons
  CMP #$00
  BEQ @done
  LDA #$04                     ; timer length
  STA timer@input
  LDA buttons
  STA last@input
@done:                         ; 
  RTI