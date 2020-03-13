
;; player

reset@player:                  ; 
  LDA #$15
  STA hp@player
  STA ui_health
  LDA #$00
  STA sp@player
  STA dp@player
  STA sickness@player
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
  LDA difficulty@player
  CMP #$00
  BEQ @Easy
  CMP #$01
  BEQ @Normal
  CMP #$02
  BEQ @Hard
@Easy:                         ; RULE | can escape if when no monsters present or when has not escaped before
  JSR enemiesLeft@room
  CMP #$00
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
  JSR enemiesLeft@room
  CMP #$00
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

run@player:                    ; 
  ; check if player is alive
  LDA hp@player
  CMP #$00
  BEQ @respawn                 ; 
  ; when alive, check for victory
  JSR loadExperience@player    ; store in a:xp
  CMP #$35
  BEQ @victory
  CMP #$36
  ; when alive
  JSR loadRun@player           ; load canRun in regA
  CMP #$01
  BNE @unable
  ; success! draw cards for next room
  JSR returnCards@room
  JSR enter@room
  ; record running
  LDA #$01
  STA has_run@player
  ; dialog:run
  LDA #$0C
  JSR show@dialog
  RTS
@victory:                      ; 
  ; dialog:run
  LDA #$00
  JSR show@dialog
  JSR show@splash
  RTS
@respawn:                      ; 
  JSR restart@game
  RTS
@unable:                       ; 
  ; dialog:cannot_run
  LDA #$04
  JSR show@dialog
  RTS

;;

loadExperience@player:         ; () -> a:xp
  ; load cards left
  JSR loadCoundCardsLeft@room  ; stores counts in x
  STX id@temp
  LDA #$36                     ; cards max
  CLC
  SBC length@deck              ; minus length
  SBC id@temp                  ; minus cards left
  RTS