
;; iNES header

  .db  "NES", $1a              ; identification of the iNES header
  .db  1                       ; number of 16KB PRG-ROM pages
  .db  $01                     ; number of 8KB CHR-ROM pages
  .db  $70|%0001               ; mapper 7
  .dsb $09,$00                 ; clear the remaining bytes
  .fillvalue $FF               ; Sets all unused space in rom to value $FF

;; constants

PPUCTRL             .equ $2000
PPUMASK             .equ $2001
PPUSTATUS           .equ $2002
SPRADDR             .equ $2003
PPUSCROLL           .equ $2005
PPUADDR             .equ $2006
PPUDATA             .equ $2007
SPRDMA              .equ $4014
SNDCHN              .equ $4015
JOY1                .equ $4016
JOY2                .equ $4017

;;

BUTTON_A            .equ #$10
BUTTON_B            .equ #$11
BUTTON_SELECT       .equ #$12
BUTTON_START        .equ #$13
BUTTON_UP           .equ #$14
BUTTON_DOWN         .equ #$15
BUTTON_LEFT         .equ #$16
BUTTON_RIGHT        .equ #$17

;; variables

  .enum $0000                  ; Zero Page variables

;;

hp@player               .dsb 1 ; health points
sp@player               .dsb 1 ; shield points
dp@player               .dsb 1 ; defense points
xp@player               .dsb 1 ; experience points
damages@player          .dsb 1 ; TODO: check if necessary?
difficulty@player       .dsb 1
sickness@player         .dsb 1
can_run@player          .dsb 1
has_run@player          .dsb 1
timer@input             .dsb 1 ; input
last@input              .dsb 1
length@deck             .dsb 1 ; deck
hand@deck               .dsb 1
timer@room              .dsb 1 ; room
completed@room          .dsb 1
card1@room              .dsb 1
card2@room              .dsb 1
card3@room              .dsb 1
card4@room              .dsb 1
id@dialog               .dsb 1 ; dialog
timer@renderer          .dsb 1
seed@game               .dsb 1 ; The seed for the random shuffle
cursor@game             .dsb 1
ui_health               .dsb 1
ui_shield               .dsb 1
; stats
card_last               .dsb 1
card_last_type          .dsb 1
card_last_value         .dsb 1
; redraws flags
reqdraws                .dsb 1
reqdraw_hp              .dsb 1
reqdraw_sp              .dsb 1
reqdraw_xp              .dsb 1
reqdraw_card1           .dsb 1
reqdraw_card2           .dsb 1
reqdraw_card3           .dsb 1
reqdraw_card4           .dsb 1
reqdraw_dialog          .dsb 1
reqdraw_run             .dsb 1
reqdraw_name            .dsb 1
; 16-bits
lb@cards                .dsb 1
hb@cards                .dsb 1
cards_temp              .dsb 1
dialogs_low             .dsb 1
dialogs_high            .dsb 1
dialogs_temp            .dsb 1
names_low               .dsb 1
names_high              .dsb 1
names_temp              .dsb 1
count@test              .dsb 1
; splash
lb@splash               .dsb 1
hb@splash               .dsb 1
cursor@splash           .dsb 1
view@game               .dsb 1 ; display which mode

;;

  .ende

;;

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
@vwait2:                       ; Second wait for vblank, PPU is ready after this
  BIT PPUSTATUS
  BPL @vwait2
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

;; Setup

  JSR loadPalettes
  JSR show@splash
  ; tests
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
  JSR updateClient             ; in client

;; increment random seed in splash

  LDA view@game
  CMP #$00
  BNE @locked
  INC seed@game

;; skip latch if input is locked

@locked
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
include "src/tests.asm"
include "src/tables.asm"

;; vectors

  .pad $FFFA
  .dw NMI
  .dw RESET
  .dw 0

;; include sprites

  .incbin "src/sprite.chr"