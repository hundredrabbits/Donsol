
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
  STA lb@temp
  LDA dialogs_offset_high,y
  STA hb@temp
  ; add y + x registers
  TYA
  STX id@temp
  CLC
  ADC id@temp
  TAY
  ; load dialog sprite
  LDA (lb@temp), y             ; load value at 16-bit address from (lb@temp + hb@temp) + y
  RTS