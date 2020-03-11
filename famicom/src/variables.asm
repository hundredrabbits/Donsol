
;; variables

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
view@game               .dsb 1 ; display which mode
lb@splash               .dsb 1 ; splash
hb@splash               .dsb 1
cursor@splash           .dsb 1
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
; 16-bits
lb@cards                .dsb 1
hb@cards                .dsb 1
lb@dialogs              .dsb 1
hb@dialogs              .dsb 1
cards_temp              .dsb 1
dialogs_temp            .dsb 1
names_low               .dsb 1
names_high              .dsb 1
names_temp              .dsb 1
count@test              .dsb 1