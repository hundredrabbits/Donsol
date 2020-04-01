
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

;;

BUTTON_RIGHT        .equ #$01
BUTTON_LEFT         .equ #$02
BUTTON_DOWN         .equ #$04
BUTTON_UP           .equ #$08
BUTTON_START        .equ #$10
BUTTON_SELECT       .equ #$20
BUTTON_B            .equ #$40
BUTTON_A            .equ #$80

;; redraw flags

REQ_HP              .equ #%00000001
REQ_SP              .equ #%00000010
REQ_XP              .equ #%00000100
REQ_RUN             .equ #%00001000
REQ_CARD1           .equ #%00010000
REQ_CARD2           .equ #%00100000
REQ_CARD3           .equ #%01000000
REQ_CARD4           .equ #%10000000

;; sprite buffers

card1@buffers       .equ $0300
card2@buffers       .equ $0340
card3@buffers       .equ $0380
card4@buffers       .equ $03c0

;;

  .enum $0000    

;;

hp@player               .dsb 1 ; health points
sp@player               .dsb 1 ; shield points
dp@player               .dsb 1 ; durability points(max $16)
xp@player               .dsb 1
difficulty@player       .dsb 1
sickness@player         .dsb 1
has_run@player          .dsb 1
length@deck             .dsb 1 ; deck
hand@deck               .dsb 1
seed1@deck              .dsb 1 ; The seed for the random shuffle(nmi)
seed2@deck              .dsb 1 ; The seed for the random shuffle(main)
count@tests             .dsb 1 ; tests
down@input              .dsb 1
last@input              .dsb 1
next@input              .dsb 1
card1@room              .dsb 1
card2@room              .dsb 1
card3@room              .dsb 1
card4@room              .dsb 1
timer@room              .dsb 1
auto@room               .dsb 1
id@dialog               .dsb 1 ; dialog
cursor@game             .dsb 1
view@game               .dsb 1 ; display which mode
hpui@game               .dsb 1
spui@game               .dsb 1
redraws@game            .dsb 1
cursor@splash           .dsb 1
highscore@splash        .dsb 1 ; keep highscore
difficulty@splash       .dsb 1 ; keep difficulty in highscore
lb@temp                 .dsb 1 ; utils
hb@temp                 .dsb 1
id@temp                 .dsb 1
damages@player          .dsb 1 ; TODO: check if necessary?

;; TODO | cleanup

card_last               .dsb 1
card_last_type          .dsb 1
card_last_value         .dsb 1
; TODO | merge remaining flags
reqdraw_game            .dsb 1
reqdraw_splash          .dsb 1
reqdraw_cursor          .dsb 1
reqdraw_dialog          .dsb 1
reqdraw_name            .dsb 1

;;

  .ende