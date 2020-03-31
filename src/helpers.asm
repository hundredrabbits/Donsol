
;; client

;; renderer

start@renderer:                ; 
  LDA #%10010000               ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA PPUCTRL
  LDA #%00011000               ; enable sprites, enable background, no clipping on left side
  STA PPUMASK
  LDA #$00                     ; No background scrolling
  STA PPUADDR
  STA PPUADDR
  STA PPUSCROLL
  STA PPUSCROLL
  RTS

;;

stop@renderer:                 ; 
  LDA #%10000000               ; disable NMI, sprites from Pattern Table 0
  STA PPUCTRL
  LDA #%00000000               ; disable sprites
  STA PPUMASK
  RTS

;;

fix@renderer:                  ; 
  BIT PPUSTATUS
  LDA #$00                     ; No background scrolling
  STA PPUADDR
  STA PPUADDR
  STA PPUSCROLL
  STA PPUSCROLL
  RTS

;;

sprites@renderer:              ; TODO: figure out why this is needed..
  LDA #$00
  STA SPRADDR                  ; set the low byte (00) of the RAM address
  LDA #$02
  STA SPRDMA                   ; set the high byte (02) of the RAM address, start the transfer
  RTS

;;

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