
;; player

reset@player:                  ; 
  LDA #$15
  STA health@player
  STA ui_health
  LDA #$00
  STA shield@player
  STA durability@player
  STA experience@player
  STA sickness@player
  LDA #$00
  STA can_run
  ; set difficulty
  LDA #$00
  STA difficulty@player
  RTS