
;; lock

lock@input:                    ; 
  LDA #$06
  STA timer@input
  RTS

;;

right@input:                   ; 
  LDA cursor
  CMP #$03
  BEQ @wrap
  INC cursor
  JMP @done
@wrap:                         ; 
  LDA #$00
  STA cursor
@done:                         ; 
  JSR requestUpdateName
  JSR update@cursor
  RTS

;;

left@input:                    ; 
  LDA cursor
  CMP #$00
  BEQ @wrap
  DEC cursor
  JMP @done
@wrap:                         ; 
  LDA #$03
  STA cursor
@done:                         ; 
  JSR requestUpdateName
  JSR update@cursor
  RTS