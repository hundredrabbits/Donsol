
;; client

;; check for updates required

nmi@client:                    ; during nmi
  LDA timer@renderer
  CMP #$00
  BEQ @allowed
  DEC timer@renderer
  RTS
@allowed:                      ; 
  LDA #$10
  STA timer@renderer
@beginDrawing:                 ; 
  ; draw name
  LDA reqdraw_name
  CMP #$00
  BEQ @checkReqCard1
  JSR redrawName@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_name
  INC reqdraws
  RTS
@checkReqCard1:                ; 
  LDA reqdraw_card1
  CMP #$00
  BEQ @checkReqCard2
  ; JSR stop@renderer
  JSR redrawCard1@game
  ; JSR start@renderer
  JSR fix@renderer
  LDA #$00
  STA reqdraw_card1
  INC reqdraws
  RTS
@checkReqCard2:                ; 
  LDA reqdraw_card2
  CMP #$00
  BEQ @checkReqCard3
  ; JSR stop@renderer
  JSR redrawCard2@game
  ; JSR start@renderer
  JSR fix@renderer
  LDA #$00
  STA reqdraw_card2
  INC reqdraws
  RTS
@checkReqCard3:                ; 
  LDA reqdraw_card3
  CMP #$00
  BEQ @checkReqCard4
  JSR stop@renderer
  JSR redrawCard3@game
  JSR start@renderer
  LDA #$00
  STA reqdraw_card3
  INC reqdraws
  RTS
@checkReqCard4:                ; 
  LDA reqdraw_card4
  CMP #$00
  BEQ @checkReqHP
  JSR stop@renderer
  JSR redrawCard4@game
  JSR start@renderer
  LDA #$00
  STA reqdraw_card4
  INC reqdraws
  RTS
@checkReqHP:                   ; 
  LDA reqdraw_hp
  CMP #$00
  BEQ @checkReqSP
  JSR redrawHealth@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_hp
  INC reqdraws
  RTS
@checkReqSP:                   ; 
  LDA reqdraw_sp
  CMP #$00
  BEQ @checkReqXP
  JSR redrawShield@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_sp
  INC reqdraws
  RTS
@checkReqXP:                   ; 
  LDA reqdraw_xp
  CMP #$00
  BEQ @checkReqRun
  JSR redrawExperience@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_xp
  INC reqdraws
  RTS
@checkReqRun:                  ; 
  LDA reqdraw_run
  CMP #$00
  BEQ @checkReqDialog
  JSR redrawRun@game
  JSR fix@renderer
  LDA #$00
  STA reqdraw_run
  INC reqdraws
  RTS
@checkReqDialog:               ; 
  LDA reqdraw_dialog
  CMP #$00
  BEQ @checkReqScore
  JSR redraw@dialog
  JSR fix@renderer
  LDA #$00
  STA reqdraw_dialog
  INC reqdraws
  RTS
@checkReqScore:                ; 
  LDA reqdraw_score
  CMP #$00
  BEQ @done
  JSR redrawScore@splash
  JSR fix@renderer
  LDA #$00
  STA reqdraw_score
  INC reqdraws
  RTS
@done:                         ; 
  RTS

;;

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