
;; dialog

show@dialog:                   ; (a:id@dialog)
  STA id@dialog
  LDA #$01                     ; request update
  STA reqdraw_dialog
  RTS

;;

redraw@dialog:                 ; 
  BIT PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$03
  STA PPUADDR
  LDX #$00
@loop:                         ; 
  LDY id@dialog
  LDA dialogs_offset_low,y
  STA lb@temp
  LDA dialogs_offset_high,y
  STA hb@temp
  TYA
  STX id@temp
  CLC
  ADC id@temp
  TAY
  LDA (lb@temp), y             ; load value at 16-bit address from (lb@temp + hb@temp) + y
  STA PPUDATA
  INX
  CPX #$18
  BNE @loop
  RTS