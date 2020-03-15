
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
PPUSTATUS           .equ $2002 ; Using BIT PPUSTATUS preserves the previous contents of A.
SPRADDR             .equ $2003
PPUSCROLL           .equ $2005
PPUADDR             .equ $2006
PPUDATA             .equ $2007
SPRDMA              .equ $4014
SNDCHN              .equ $4015
JOY1                .equ $4016
JOY2                .equ $4017

;; buffers

card1@buffers       .equ $0300
card2@buffers       .equ $0340
card3@buffers       .equ $0380
card4@buffers       .equ $03c0

;;

BUTTON_A            .equ #$10
BUTTON_B            .equ #$11
BUTTON_SELECT       .equ #$12
BUTTON_START        .equ #$13
BUTTON_UP           .equ #$14
BUTTON_DOWN         .equ #$15
BUTTON_LEFT         .equ #$16
BUTTON_RIGHT        .equ #$17

;;

  .enum $0000    

;;

hp@player               .dsb 1 ; health points
sp@player               .dsb 1 ; shield points
dp@player               .dsb 1 ; durability points(max $16)
xp@player               .dsb 1
damages@player          .dsb 1 ; TODO: check if necessary?
difficulty@player       .dsb 1
sickness@player         .dsb 1
has_run@player          .dsb 1
length@deck             .dsb 1 ; deck
hand@deck               .dsb 1
seed@deck               .dsb 1 ; The seed for the random shuffle
count@tests             .dsb 1 ; tests
timer@room              .dsb 1 ; room
card1@room              .dsb 1
card2@room              .dsb 1
card3@room              .dsb 1
card4@room              .dsb 1
timer@input             .dsb 1 ; input
last@input              .dsb 1
id@dialog               .dsb 1 ; dialog
cursor@game             .dsb 1
view@game               .dsb 1 ; display which mode
cursor@splash           .dsb 1
highscore@splash        .dsb 1 ; keep highscore
lb@temp                 .dsb 1 ; utils
hb@temp                 .dsb 1
id@temp                 .dsb 1
timer@renderer          .dsb 1
; misc
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
reqdraw_score           .dsb 1

;;

  .ende