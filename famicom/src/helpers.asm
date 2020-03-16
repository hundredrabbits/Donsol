
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

;;

main@input:                    ; run from nmi
  LDA last@input
  CMP BUTTON_A
  BEQ onA@input
  CMP BUTTON_B
  BEQ onB@input
  CMP BUTTON_SELECT
  BEQ onSELECT@input
  CMP BUTTON_START
  BEQ onSTART@input
  CMP BUTTON_LEFT
  BEQ onLEFT@input
  CMP BUTTON_RIGHT
  BEQ onRIGHT@input
  RTS

;;

nmi@input:                     ; use the nmi to decrement lock
  LDA timer@input
  CMP #$00
  BEQ @done
  DEC timer@input
@done:                         ; 
  RTS

;;

onA@input:                     ; 
  LDA view@game
  CMP #$00
  BEQ @splash
@game:                         ; 
  LDX cursor@game
  JSR flipCard@room            ; flip selected card
  JSR lock@input
  RTS
@splash:                       ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  JSR lock@input
  RTS

;;

onB@input:                     ; 
  LDA view@game
  CMP #$00
  BEQ @splash
@game:                         ; 
  JSR run@player
  JSR lock@input
  RTS
@splash:                       ; 
  LDA cursor@splash
  STA difficulty@player        ; store difficulty
  JSR show@game
  JSR lock@input
  RTS

;;

onSELECT@input:                ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR show@splash
  JSR lock@input
  RTS
@splash:                       ; 
  NOP
  RTS

;;

onSTART@input:                 ; 
  RTS

;;

onLEFT@input:                  ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR selectPrev@game
  JSR lock@input
  RTS
@splash:                       ; 
  JSR selectPrev@splash
  JSR lock@input
  RTS

;;

onRIGHT@input:                 ; 
  LDA view@game
  CMP #$00
  BEQ @splash
  JSR selectNext@game
  JSR lock@input
  RTS
@splash:                       ; 
  JSR selectNext@splash
  JSR lock@input
  RTS

;; lock

lock@input:                    ; 
  LDA #$07
  STA timer@input
  ; release
  LDA #$00
  STA last@input
  RTS