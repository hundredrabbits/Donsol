  include "src/head.asm"

;; Begin

  .org $C000

;; RESET

RESET:                         ; 
  SEI                          ; disable IRQs
  CLD                          ; disable decimal mode
  LDX #$40
  STX JOY2                     ; disable APU frame IRQ
  LDX #$FF
  TXS                          ; Set up stack
  INX                          ; now X = 0
  STX PPUCTRL                  ; disable NMI
  STX PPUMASK                  ; disable rendering
  STX $4010                    ; disable DMC IRQs
@vwait1:                       ; First wait for vblank to make sure PPU is ready
  BIT PPUSTATUS
  BPL @vwait1
@clear:                        ; 
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0200, x                 ; move all sprites off screen
  INX
  BNE @clear
@vwait2:                       ; Second wait for vblank, PPU is ready after this
  BIT PPUSTATUS
  BPL @vwait2

;; Init

  ; Load Palettes
  BIT PPUSTATUS
  LDA #$3F
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00
@loop:                         ; 
  LDA palettes, x
  STA PPUDATA
  INX
  CPX #$20
  BNE @loop
  ; show splash
  JSR show@splash

;; Run tests

  ; JSR run@tests

;; jump back to Forever, infinite loop

Forever:                       ; 
  JMP Forever

;; NMI

NMI:                           ; 
  LDA #$00
  STA SPRADDR                  ; set the low byte (00) of the RAM address
  LDA #$02
  STA SPRDMA                   ; set the high byte (02) of the RAM address, start the transfer

;; if input, just do that

@input:                        ; 
  LDA last@input
  CMP #$00
  BEQ @frame
  JSR update@input
  RTI

;;render frame & timers

@frame:                        ; 
  JSR update@room
  JSR interpolateStats         ; in client
  JSR update@client            ; in client

;; increment random seed in splash

  LDA view@game
  CMP #$00
  BNE @locked
  INC seed@deck
@locked                        ; skip latch if input is locked
  LDA timer@input
  CMP #$00
  BEQ @latch
  DEC timer@input
  RTI

;; latch

@latch:                        ; 
  LDA #$01
  STA JOY1
  LDA #$00
  STA JOY1                     ; tell both the controllers to latch buttons
@a:                            ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @b                       ; check if button is already pressed
  LDA BUTTON_A
  STA last@input
@b:                            ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @select
  LDA BUTTON_B
  STA last@input
@select:                       ; 
  LDA JOY1
  AND #%00000001
  BEQ @start
  LDA BUTTON_SELECT
  STA last@input
@start:                        ; 
  LDA JOY1
  AND #%00000001
  BEQ @up
  LDA BUTTON_START
  STA last@input
@up:                           ; 
  LDA JOY1
  AND #%00000001
  BEQ @down
  NOP                          ; unused/disabled in Donsol
@down:                         ; 
  LDA JOY1
  AND #%00000001
  BEQ @left
  NOP                          ; unused/disabled in Donsol
@left:                         ; 
  LDA JOY1
  AND #%00000001
  BEQ @right
  LDA BUTTON_LEFT
  STA last@input
@right:                        ; 
  LDA JOY1
  AND #%00000001
  BEQ @done
  LDA BUTTON_RIGHT
  STA last@input
@done:                         ; 
  RTI                          ; return from interrupt

;; includes

  include "src/splash.asm"
  include "src/game.asm"
  include "src/input.asm"
  include "src/core.asm"
  include "src/deck.asm"
  include "src/player.asm"
  include "src/room.asm"
  include "src/client.asm"
  include "src/dialog.asm"
  include "src/tests.asm"
  include "src/tables.asm"

;; vectors

  .pad $FFFA
  .dw NMI
  .dw RESET
  .dw 0

;; include sprites

  .incbin "src/sprite.chr"