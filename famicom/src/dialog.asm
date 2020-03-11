
;; dialog

show@dialog:                   ; (a:id@dialog)
  STA id@dialog
  JSR requestUpdateDialog
  RTS

;;

update@dialog:                 ; 
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$03
  STA PPUADDR
  LDX #$00
  JSR stop@renderer
@loop:                         ; 
  LDY id@dialog
  JSR load@dialog
  STA PPUDATA
  INX
  CPX #$18
  BNE @loop
  JSR start@renderer
  RTS

;;

load@dialog:                   ; (x:tile_id, y:id@dialog)
  ; find dialog offset
  LDA dialogs_offset_low,y
  STA lb@dialogs
  LDA dialogs_offset_high,y
  STA hb@dialogs
  ; add y + x registers
  TYA
  STX dialogs_temp
  CLC
  ADC dialogs_temp
  TAY
  ; load dialog sprite
  LDA (lb@dialogs), y          ; load value at 16-bit address from (lb@dialogs + hb@dialogs) + y
  RTS