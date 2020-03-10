
;; player

reset@player:                  ; 
  LDA #$15
  STA hp@player
  STA ui_health
  LDA #$00
  STA sp@player
  STA dp@player
  STA xp@player
  STA sickness@player
  LDA #$00
  STA can_run@player
  ; set difficulty
  LDA #$00
  STA difficulty@player
  RTS

;;

add_sick@player:               ; 
  LDA #$01
  STA sickness@player
  RTS

;;

remove_sick@player:            ; 
  LDA #$00
  STA sickness@player
  RTS

;;

add_xp@player:                 ; 
  INC xp@player
  LDA #$01
  STA reqdraw_xp
  RTS