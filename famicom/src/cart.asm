
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
cursor                  .dsb 1
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
cards_low               .dsb 1
cards_high              .dsb 1
cards_temp              .dsb 1
dialogs_low             .dsb 1
dialogs_high            .dsb 1
dialogs_temp            .dsb 1
names_low               .dsb 1
names_high              .dsb 1
names_temp              .dsb 1
count@test              .dsb 1

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

  ; start drawing
  JSR loadBackground
  JSR loadPalettes
  JSR loadAttributes
  JSR setup@interface
  JSR setup@cursor
  JSR restart@game
  ; tests
  JSR run@tests
  ; render
  JSR start@renderer

;; jump back to Forever, infinite loop

Forever:                       ; 
  JMP Forever

;; NMI

NMI:                           ; 
  LDA #$00
  STA SPRADDR                  ; set the low byte (00) of the RAM address
  LDA #$02
  STA SPRDMA                   ; set the high byte (02) of the RAM address, start the transfer

;; update

  JSR tic@room
  JSR interpolateStats         ; in client
  JSR updateClient             ; in client

;; skip latch if input is locked

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
  LDX cursor
  JSR flip@room                ; flipcard(x: cursor)
  JSR lock@input
@b:                            ; 
  LDA JOY1
  AND #%00000001               ; only look at BIT 0
  BEQ @select
  ; askquit: leave(TODO)
  ; dungeon: run
  JSR tryRun
  JSR lock@input
@select:                       ; 
  LDA JOY1
  AND #%00000001
  BEQ @start
  JSR askQuit@game
@start:                        ; 
  LDA JOY1
  AND #%00000001
  BEQ @up
  NOP
@up:                           ; 
  LDA JOY1
  AND #%00000001
  BEQ @down
  NOP
@down:                         ; 
  LDA JOY1
  AND #%00000001
  BEQ @left
  NOP
@left:                         ; 
  LDA JOY1
  AND #%00000001
  BEQ @right
  JSR left@input
  JSR lock@input
@right:                        ; 
  LDA JOY1
  AND #%00000001
  BEQ @done
  JSR right@input
  JSR lock@input
@done:                         ; 
  RTI                          ; return from interrupt
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