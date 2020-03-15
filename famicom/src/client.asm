
;; client

redrawRun@game:                ; 
  LDA length@deck              ; don't display the run butto on first hand
  CMP #$31                     ; deck is $36 - 4(first hand)
  BEQ @hide
  JSR loadRun@player           ; load canRun in regA
  CMP #$01
  BNE @hide
@show:                         ; RUN: $1c,$1f,$18
  BIT PPUSTATUS                ; read PPU status to reset the high/low latch
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$18
  STA PPUADDR                  ; write the low byte
  LDA #$6D                     ; Button(B)
  STA PPUDATA
  LDA #$00                     ; Blank
  STA PPUDATA
  LDA #$1C                     ; R
  STA PPUDATA
  LDA #$1F                     ; U
  STA PPUDATA
  LDA #$18                     ; N
  STA PPUDATA
  RTS
@hide:                         ; 
  BIT PPUSTATUS                ; read PPU status to reset the high/low latch
  LDA #$21
  STA PPUADDR                  ; write the high byte
  LDA #$18
  STA PPUADDR                  ; write the low byte
  LDA #$00                     ; R
  STA PPUDATA
  STA PPUDATA
  STA PPUDATA
  STA PPUDATA
  STA PPUDATA
  JSR start@renderer
  RTS

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