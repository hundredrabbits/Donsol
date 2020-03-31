
;; player

reset@player:                  ; 
  LDA #$15
  STA hp@player
  STA hpui@game
  LDA #$00
  STA sp@player
  STA spui@game
  STA dp@player
  STA sickness@player
  STA has_run@player
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
  BEQ @easy
  CMP #$01
  BEQ @normal
  CMP #$02
  BEQ @hard
  CMP #$03
  BEQ @special
@easy:                         ; RULE | can escape if when no monsters present or when has not escaped before
  JSR loadEnemiesLeft@room
  CPX #$00
  BEQ @enableRun               ; when monsters left
  LDA has_run@player
  CMP #$01
  BEQ @disableRun              ; when has not escaped
  JSR @enableRun
  RTS
@normal:                       ; RULE | can escape when has not escaped before
  LDA has_run@player
  CMP #$01
  BEQ @disableRun              ; when has not escaped
  JSR @enableRun
  RTS
@hard:                         ; RULE | can escape if there are no monsters present
  JSR loadEnemiesLeft@room
  CPX #$00
  BNE @disableRun              ; when no monsters present
  JSR @enableRun
  RTS
@special:                      ; RULE | can escape if not injured
  LDA hp@player
  CMP #$15
  BNE @disableRun              ; when hp is not full
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