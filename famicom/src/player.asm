
;; player

reset@player:                  ; 
  LDA #$15
  STA hp@player
  STA hpui@game
  LDA #$00
  STA sp@player
  STA dp@player
  STA sickness@player
  RTS

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

addSickness@player:            ; 
  LDA #$01
  STA sickness@player
  RTS

;;

removeSickness@player:         ; 
  LDA #$00
  STA sickness@player
  RTS

;;

;; running

loadRun@player:                ; () -> a:canRun
  ; check if player is alive
  LDA hp@player
  CMP #$00
  BEQ @disableRun
  ; 
  LDA difficulty@player
  CMP #$00
  BEQ @Easy
  CMP #$01
  BEQ @Normal
  CMP #$02
  BEQ @Hard
@Easy:                         ; RULE | can escape if when no monsters present or when has not escaped before
  JSR loadEnemiesLeft@room
  STX $40
  CPX #$00
  BEQ @enableRun               ; when monsters left
  LDA has_run@player
  CMP #$01
  BEQ @disableRun              ; when has not escaped
  JSR @enableRun
  RTS
@Normal:                       ; RULE | can escape when has not escaped before
  LDA has_run@player
  CMP #$01
  BEQ @disableRun              ; when has not escaped
  JSR @enableRun
  RTS
@Hard:                         ; RULE | can escape if there are no monsters present
  JSR loadEnemiesLeft@room
  CPX #$00
  BNE @disableRun              ; when no monsters present
  JSR @enableRun
  RTS
@enableRun:                    ; 
  LDA #$01
  RTS
@disableRun
  LDA #$00
  RTS

;;

updateExperience@player:       ; () -> a:xp
  JSR loadCardsLeft@room       ; load cards left, stores counts in x
  STX id@temp
  LDA #$36                     ; cards max
  SEC
  SBC length@deck              ; minus length
  SBC id@temp                  ; minus cards left
  STA xp@player                ; load xp AND update high score
  RTS

;;

run@player:                    ; 
  LDA hp@player                ; check if player is alive
  CMP #$00
  BEQ @onDead                  ; 
  LDA xp@player                ; when alive, check for victory
  CMP #$36
  BEQ @onVictory
  JSR loadRun@player           ; load canRun in regA when alive, check for escape
  CMP #$01
  BEQ @onEscape
  LDA #$04                     ; dialog: cannot_run when unable, display dialog
  JSR show@dialog
  RTS
@onEscape:                     ; 
  JSR returnCards@room         ; draw cards for next room
  JSR enter@room
  LDA #$01                     ; record running
  STA has_run@player
  LDA #$0C                     ; dialog:run
  JSR show@dialog
  RTS
@onVictory:                    ; 
  LDA #$00                     ; dialog:clear
  JSR show@dialog
  JSR show@splash
  RTS
@onDead:                       ; 
  JSR restart@game
  RTS                          ; 

;;

clampHealth@player:            ; 
  LDA hp@player
  CMP #$15
  BCC @done
  LDA #$15
  STA hp@player
@done:                         ; 
  RTS