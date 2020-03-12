
;; TABLES

  .org $E000

;; $30 -> white | $15 -> red | $3A -> cyan | $2D -> dark grey

palettes:                      ; 
  .db $0F,$15,$2D,$30, $0F,$3A,$15,$30, $13,$2D,$3A,$30, $0F,$3A,$30,$30; background
  .db $0F,$15,$2D,$30, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F; sprites

;; Attributes

attributes@game:               ; 
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %11000000, %11110000, %10100000, %10100000, %00000000, %00000000
  .db %00000000, %00000100, %00000001, %00001011, %00000000, %00001111, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000

;; Cursor

selections@game:               ; 
  .db $28,$60,$98,$d0

;; Number Positions

number_high:                   ; 
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02
  .db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03
  .db $04,$04,$04,$04,$04,$04,$04,$04,$04,$04
  .db $05,$05,$05,$05,$05,$05,$05,$05,$05,$05
number_low:                    ; 
  .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a
  .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a
  .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a
  .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a
  .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a

;; Progress Bars

progressbar:                   ; 
  .db $60,$61,$61,$61,$61,$62  ; $00
  .db $67,$61,$61,$61,$61,$62  ; $06
  .db $64,$63,$61,$61,$61,$62  ; $0c
  .db $64,$65,$63,$61,$61,$62  ; $12
  .db $64,$65,$65,$63,$61,$62  ; $18
  .db $64,$65,$65,$65,$63,$62  ; $1E
  .db $64,$65,$65,$65,$65,$66  ; $24
healthbaroffset:               ; 
  .db $c3,$c4,$c5,$c6,$c7,$c8,$c9
healthbarpos:                  ; 
  .db $00,$06,$06,$06,$06,$0c,$0c,$0c,$0c,$12,$12
  .db $12,$12,$18,$18,$18,$18,$1E,$1E,$1E,$1E,$24
shieldbaroffset:               ; 
  .db $ca,$cb,$cc,$cd,$ce,$cf,$d0
shieldbarpos:                  ; 
  .db $00,$06,$06,$0c,$0c,$12
  .db $12,$18,$18,$1E,$1E,$24
experiencebaroffset:           ; 
  .db $d1,$d2,$d3,$d4,$d5,$d6,$d7
experiencebarpos:              ; 
  .db $00,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
  .db $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$12
  .db $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$18,$18
  .db $18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$1E,$1E,$1E
  .db $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$24

;; Cards

card_types:                    ; 
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; hearts
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01; diamonds
  .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02; spades
  .db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03; clovers
  .db $04,$04,$05              ; joker
card_values:                   ; 
  .db $0b,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0b,$0b; heart
  .db $0b,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0b,$0b; diamonds
  .db $11,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0d,$0f; spades
  .db $11,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0d,$0f; clovers
  .db $15,$15,$00              ; joker
card_enemies:                  ; 
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; heart
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; diamonds
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01; spades
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01; clovers
  .db $01,$01,$00              ; joker
card_glyphs:                   ; 
  .db $00,$02,$03,$04,$05,$06,$07,$08,$09,$0a
  .db $22,$14,$20,$1b,$00,$15,$08,$0b,$00,$00
  .db $00,$0e,$00

;; Card Positions

card1pos_high:                 ; 
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
card1pos_low:                  ; 
  .db $83,$84,$85,$86,$87,$88
  .db $a3,$a4,$a5,$a6,$a7,$a8
  .db $c3,$c4,$c5,$c6,$c7,$c8
  .db $e3,$e4,$e5,$e6,$e7,$e8
  .db $03,$04,$05,$06,$07,$08
  .db $23,$24,$25,$26,$27,$28
  .db $43,$44,$45,$46,$47,$48
  .db $63,$64,$65,$66,$67,$68
  .db $83,$84,$85,$86,$87,$88
card2pos_low:                  ; 
  .db $8a,$8b,$8c,$8d,$8e,$8f
  .db $aa,$ab,$ac,$ad,$ae,$af
  .db $ca,$cb,$cc,$cd,$ce,$cf
  .db $ea,$eb,$ec,$ed,$ee,$ef
  .db $0a,$0b,$0c,$0d,$0e,$0f
  .db $2a,$2b,$2c,$2d,$2e,$2f
  .db $4a,$4b,$4c,$4d,$4e,$4f
  .db $6a,$6b,$6c,$6d,$6e,$6f
  .db $8a,$8b,$8c,$8d,$8e,$8f
card3pos_high:                 ; 
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
card3pos_low:                  ; 
  .db $91,$92,$93,$94,$95,$96
  .db $b1,$b2,$b3,$b4,$b5,$b6
  .db $d1,$d2,$d3,$d4,$d5,$d6
  .db $f1,$f2,$f3,$f4,$f5,$f6
  .db $11,$12,$13,$14,$15,$16
  .db $31,$32,$33,$34,$35,$36
  .db $51,$52,$53,$54,$55,$56
  .db $71,$72,$73,$74,$75,$76
  .db $91,$92,$93,$94,$95,$96
card4pos_low:                  ; 
  .db $98,$99,$9a,$9b,$9c,$9d
  .db $b8,$b9,$ba,$bb,$bc,$bd
  .db $d8,$d9,$da,$db,$dc,$dd
  .db $f8,$f9,$fa,$fb,$fc,$fd
  .db $18,$19,$1a,$1b,$1c,$1d
  .db $38,$39,$3a,$3b,$3c,$3d
  .db $58,$59,$5a,$5b,$5c,$5d
  .db $78,$79,$7a,$7b,$7c,$7d
  .db $98,$99,$9a,$9b,$9c,$9d

;; Dialog

dialogs:                       ; [skip]
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; clear 00
  .db $23,$33,$39,$00,$2a,$29,$29,$30,$00,$37,$2d,$27,$2f,$69,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; sickness 01
  .db $23,$33,$39,$36,$00,$37,$2c,$2d,$29,$30,$28,$00,$26,$36,$33,$2f,$29,$68,$00,$00,$00,$00,$00,$00; shieldbreak 02
  .db $23,$33,$39,$00,$28,$2d,$29,$28,$69,$00,$6d,$00,$1e,$36,$3d,$00,$25,$2b,$25,$2d,$32,$69,$00,$00; death 03
  .db $21,$29,$30,$27,$33,$31,$29,$00,$6c,$00,$1d,$29,$30,$29,$27,$38,$00,$27,$25,$36,$28,$69,$00,$00; enterdungeon 04
  .db $23,$33,$39,$00,$2a,$33,$39,$32,$28,$00,$25,$00,$37,$2c,$2d,$29,$30,$28,$69,$00,$00,$00,$00,$00; shield 05
  .db $23,$33,$39,$00,$28,$36,$25,$32,$2f,$00,$25,$00,$34,$33,$38,$2d,$33,$32,$69,$00,$00,$00,$00,$00; potion 06
  .db $23,$33,$39,$00,$3b,$25,$37,$38,$29,$28,$00,$25,$00,$34,$33,$38,$2d,$33,$32,$68,$00,$00,$00,$00; wastedpotion 07
  .db $19,$3b,$68,$00,$23,$33,$39,$00,$32,$29,$29,$28,$00,$25,$00,$37,$2c,$2d,$29,$30,$28,$69,$00,$00; unshielded 08
  .db $23,$33,$39,$00,$29,$32,$38,$29,$36,$29,$28,$00,$38,$2c,$29,$00,$36,$33,$33,$31,$69,$00,$00,$00; attack 09
  .db $23,$33,$39,$00,$26,$30,$33,$27,$2f,$29,$28,$00,$38,$2c,$29,$00,$25,$38,$38,$25,$27,$2f,$69,$00; shielded 0a
  .db $23,$33,$39,$00,$37,$39,$36,$3a,$2d,$3a,$29,$28,$00,$38,$2c,$29,$00,$26,$25,$38,$38,$30,$29,$69; damages 0b
  .db $23,$33,$39,$00,$36,$25,$32,$00,$25,$3b,$25,$3d,$69,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; run 0c
  .db $23,$33,$39,$00,$27,$25,$32,$32,$33,$38,$00,$36,$39,$32,$00,$25,$3b,$25,$3d,$69,$00,$00,$00,$00; cannot_run 0d
  .db $0b,$26,$25,$32,$28,$33,$32,$00,$6d,$00,$16,$29,$25,$3a,$29,$00,$28,$39,$32,$2b,$29,$33,$32,$69; quit 0e

;; dialogs map

dialogs_offset_low:            ; 
  .db #<(dialogs+(#$17* 0)),#<(dialogs+(#$17* 1)),#<(dialogs+(#$17* 2)),#<(dialogs+(#$17* 3)),#<(dialogs+(#$17* 4)),#<(dialogs+(#$17* 5))
  .db #<(dialogs+(#$17* 6)),#<(dialogs+(#$17* 7)),#<(dialogs+(#$17* 8)),#<(dialogs+(#$17* 9)),#<(dialogs+(#$17*10)),#<(dialogs+(#$17*11))
  .db #<(dialogs+(#$17*12)),#<(dialogs+(#$17*13)),#<(dialogs+(#$17*14))
dialogs_offset_high:           ; 
  .db #>(dialogs+(#$17* 0)),#>(dialogs+(#$17* 1)),#>(dialogs+(#$17* 2)),#>(dialogs+(#$17* 3)),#>(dialogs+(#$17* 4)),#>(dialogs+(#$17* 5))
  .db #>(dialogs+(#$17* 6)),#>(dialogs+(#$17* 7)),#>(dialogs+(#$17* 8)),#>(dialogs+(#$17* 9)),#>(dialogs+(#$17*10)),#>(dialogs+(#$17*11))
  .db #>(dialogs+(#$17*12)),#>(dialogs+(#$17*13)),#>(dialogs+(#$17*14))

;; cards

cards:                         ; [skip]
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$52,$86,$86,$86,$87,$85,$e8,$e4,$e5,$e9,$87,$85,$ec,$e0,$e1,$ed,$87,$85,$f8,$f5,$f6,$fb,$87,$85,$86,$f9,$fa,$86,$87,$85,$fc,$fd,$fe,$ff,$87,$89,$ee,$eb,$ea,$ef,$8b; heart1
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$46,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$42,$86,$86,$87,$85,$86,$86,$42,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; heart2
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$47,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$42,$86,$86,$87,$85,$86,$86,$42,$86,$87,$85,$86,$42,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; heart3
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$48,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$42,$86,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; heart4
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$49,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$86,$42,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; heart5
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$4a,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; heart6
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$4b,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$86,$42,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; heart7
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$4c,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; heart8
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$4d,$86,$86,$86,$87,$85,$86,$86,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; heart9
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$4e,$86,$86,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$85,$86,$42,$42,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; heart10
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$4f,$86,$86,$86,$87,$85,$e8,$e4,$e5,$e9,$87,$85,$ec,$e0,$e1,$ed,$87,$85,$f8,$8e,$8f,$fb,$87,$85,$86,$c2,$c3,$86,$87,$85,$fc,$c0,$c7,$ff,$87,$89,$ee,$9e,$9e,$ef,$8b; heart11
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$50,$86,$86,$86,$87,$85,$e8,$e4,$e5,$e9,$87,$85,$ec,$e0,$e1,$ed,$87,$85,$f8,$8c,$8d,$fb,$87,$85,$86,$c2,$c3,$86,$87,$85,$fc,$c0,$c1,$ff,$87,$89,$ee,$c4,$c5,$ef,$8b; heart12
  .db $81,$82,$82,$82,$82,$83,$85,$42,$86,$86,$86,$87,$85,$51,$86,$86,$86,$87,$85,$e8,$e4,$e5,$e9,$87,$85,$ec,$e0,$e1,$ed,$87,$85,$f8,$9c,$9d,$fb,$87,$85,$86,$f9,$fa,$86,$87,$85,$fc,$bc,$bd,$ff,$87,$89,$ee,$be,$bf,$ef,$8b; heart13
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$52,$86,$86,$86,$87,$85,$86,$f0,$f3,$86,$87,$85,$f0,$f1,$f2,$f3,$87,$85,$f4,$f5,$f6,$f7,$87,$85,$86,$f9,$fa,$86,$87,$85,$fc,$fd,$fe,$ff,$87,$89,$ee,$eb,$ea,$ef,$8b; diamond1
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$46,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$43,$86,$86,$87,$85,$86,$86,$43,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; diamond2
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$47,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$43,$86,$86,$87,$85,$86,$86,$43,$86,$87,$85,$86,$43,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; diamond3
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$48,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$43,$86,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; diamond4
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$49,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$86,$43,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; diamond5
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$4a,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; diamond6
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$4b,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$86,$43,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; diamond7
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$4c,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; diamond8
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$4d,$86,$86,$86,$87,$85,$86,$86,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; diamond9
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$4e,$86,$86,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$85,$86,$43,$43,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; diamond10
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$4f,$86,$86,$86,$87,$85,$86,$f0,$f3,$86,$87,$85,$f0,$f1,$f2,$f3,$87,$85,$f4,$8e,$8f,$f7,$87,$85,$86,$c2,$c3,$86,$87,$85,$fc,$c0,$c7,$ff,$87,$89,$ee,$9e,$9e,$ef,$8b; diamond11
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$50,$86,$86,$86,$87,$85,$86,$f0,$f3,$86,$87,$85,$f0,$f1,$f2,$f3,$87,$85,$f4,$8c,$8d,$f7,$87,$85,$86,$c2,$c3,$86,$87,$85,$fc,$c0,$c1,$ff,$87,$89,$ee,$c4,$c5,$ef,$8b; diamond12
  .db $81,$82,$82,$82,$82,$83,$85,$43,$86,$86,$86,$87,$85,$51,$86,$86,$86,$87,$85,$86,$f0,$f3,$86,$87,$85,$f0,$f1,$f2,$f3,$87,$85,$f4,$9c,$9d,$f7,$87,$85,$86,$f9,$fa,$86,$87,$85,$fc,$bc,$bd,$ff,$87,$89,$ee,$be,$bf,$ef,$8b; diamond13
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$52,$86,$86,$86,$87,$85,$86,$d0,$d3,$86,$87,$85,$d0,$d1,$d2,$d3,$87,$85,$d4,$d5,$d6,$d7,$87,$85,$86,$d9,$da,$86,$87,$85,$dc,$dd,$de,$df,$87,$89,$e6,$e2,$e3,$e7,$8b; spade1
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$46,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$86,$40,$86,$87,$85,$86,$40,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; spade2
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$47,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$86,$40,$86,$87,$85,$86,$40,$86,$86,$87,$85,$86,$86,$40,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; spade3
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$48,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$86,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$86,$40,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; spade4
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$49,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$86,$40,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; spade5
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$4a,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; spade6
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$4b,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; spade7
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$4c,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; spade8
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$4d,$86,$86,$86,$87,$85,$86,$40,$86,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; spade9
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$4e,$86,$86,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$85,$86,$40,$40,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; spade10
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$4f,$86,$86,$86,$87,$85,$86,$d0,$d3,$86,$87,$85,$d0,$d1,$d2,$d3,$87,$85,$d4,$56,$57,$d7,$87,$85,$86,$5e,$5f,$86,$87,$85,$dc,$ce,$cf,$df,$87,$89,$e6,$9f,$9f,$e7,$8b; spade11
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$50,$86,$86,$86,$87,$85,$86,$d0,$d3,$86,$87,$85,$d0,$d1,$d2,$d3,$87,$85,$d4,$5a,$5b,$d7,$87,$85,$86,$5e,$5f,$86,$87,$85,$dc,$ce,$c9,$df,$87,$89,$e6,$cc,$cd,$e7,$8b; spade12
  .db $81,$82,$82,$82,$82,$83,$85,$40,$86,$86,$86,$87,$85,$51,$86,$86,$86,$87,$85,$86,$d0,$d3,$86,$87,$85,$d0,$d1,$d2,$d3,$87,$85,$d4,$58,$59,$d7,$87,$85,$86,$5c,$5d,$86,$87,$85,$dc,$54,$55,$df,$87,$89,$e6,$88,$c8,$e7,$8b; spade13
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$52,$86,$86,$86,$87,$85,$86,$d8,$db,$86,$87,$85,$d8,$d1,$d2,$db,$87,$85,$d4,$d5,$d6,$d7,$87,$85,$86,$d9,$da,$86,$87,$85,$dc,$dd,$de,$df,$87,$89,$e6,$e2,$e3,$e7,$8b; clover1
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$46,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$41,$86,$86,$87,$85,$86,$86,$41,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; clover2
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$47,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$41,$86,$86,$87,$85,$86,$86,$41,$86,$87,$85,$86,$41,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; clover3
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$48,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$41,$86,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; clover4
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$49,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$86,$41,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; clover5
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$4a,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; clover6
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$4b,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$86,$41,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; clover7
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$4c,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; clover8
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$4d,$86,$86,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$40,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$86,$41,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; clover9
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$4e,$86,$86,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$85,$86,$41,$41,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; clover10
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$4f,$86,$86,$86,$87,$85,$86,$d8,$db,$86,$87,$85,$d8,$d1,$d2,$db,$87,$85,$d4,$56,$57,$d7,$87,$85,$86,$ca,$cb,$86,$87,$85,$dc,$ce,$cf,$df,$87,$89,$e6,$9f,$9f,$e7,$8b; clover11
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$50,$86,$86,$86,$87,$85,$86,$d8,$db,$86,$87,$85,$d8,$d1,$d2,$db,$87,$85,$d4,$5a,$5b,$d7,$87,$85,$86,$ca,$cb,$86,$87,$85,$dc,$ce,$c9,$df,$87,$89,$e6,$cc,$cd,$e7,$8b; clover12
  .db $81,$82,$82,$82,$82,$83,$85,$41,$86,$86,$86,$87,$85,$51,$86,$86,$86,$87,$85,$86,$d8,$db,$86,$87,$85,$d8,$d1,$d2,$db,$87,$85,$d4,$58,$59,$d7,$87,$85,$86,$5c,$5d,$86,$87,$85,$dc,$54,$55,$df,$87,$89,$e6,$88,$c8,$e7,$8b; clover13
  .db $81,$82,$82,$82,$82,$83,$85,$53,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$78,$79,$7a,$7b,$87,$85,$7c,$7d,$7e,$7f,$87,$85,$86,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; joker1
  .db $81,$82,$82,$82,$82,$83,$85,$53,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$85,$70,$71,$72,$73,$87,$85,$74,$75,$76,$77,$87,$85,$86,$86,$86,$86,$87,$85,$86,$86,$86,$86,$87,$89,$8a,$8a,$8a,$8a,$8b; joker2
  .db $91,$92,$92,$92,$92,$93,$95,$96,$96,$96,$96,$97,$95,$96,$96,$96,$96,$97,$95,$96,$96,$96,$96,$97,$95,$96,$96,$96,$96,$97,$95,$96,$96,$96,$96,$97,$95,$96,$96,$96,$96,$97,$95,$96,$96,$96,$96,$97,$99,$9a,$9a,$9a,$9a,$9b; blank

;; cards map

cards_offset_low:              ; 
  .db #<(cards+(#$35* 0)),#<(cards+(#$35* 1)),#<(cards+(#$35* 2)),#<(cards+(#$35* 3)),#<(cards+(#$35* 4)),#<(cards+(#$35* 5)),#<(cards+(#$35* 6)),#<(cards+(#$35* 7)),#<(cards+(#$35* 8)),#<(cards+(#$35* 9))
  .db #<(cards+(#$35*10)),#<(cards+(#$35*11)),#<(cards+(#$35*12)),#<(cards+(#$35*13)),#<(cards+(#$35*14)),#<(cards+(#$35*15)),#<(cards+(#$35*16)),#<(cards+(#$35*17)),#<(cards+(#$35*18)),#<(cards+(#$35*19))
  .db #<(cards+(#$35*20)),#<(cards+(#$35*21)),#<(cards+(#$35*22)),#<(cards+(#$35*23)),#<(cards+(#$35*24)),#<(cards+(#$35*25)),#<(cards+(#$35*26)),#<(cards+(#$35*27)),#<(cards+(#$35*28)),#<(cards+(#$35*29))
  .db #<(cards+(#$35*30)),#<(cards+(#$35*31)),#<(cards+(#$35*32)),#<(cards+(#$35*33)),#<(cards+(#$35*34)),#<(cards+(#$35*35)),#<(cards+(#$35*36)),#<(cards+(#$35*37)),#<(cards+(#$35*38)),#<(cards+(#$35*39))
  .db #<(cards+(#$35*40)),#<(cards+(#$35*41)),#<(cards+(#$35*42)),#<(cards+(#$35*43)),#<(cards+(#$35*44)),#<(cards+(#$35*45)),#<(cards+(#$35*46)),#<(cards+(#$35*47)),#<(cards+(#$35*48)),#<(cards+(#$35*49))
  .db #<(cards+(#$35*50)),#<(cards+(#$35*51)),#<(cards+(#$35*52)),#<(cards+(#$35*53)),#<(cards+(#$35*54)),#<(cards+(#$35*55))
cards_offset_high:             ; 
  .db #>(cards+(#$35* 0)),#>(cards+(#$35* 1)),#>(cards+(#$35* 2)),#>(cards+(#$35* 3)),#>(cards+(#$35* 4)),#>(cards+(#$35* 5)),#>(cards+(#$35* 6)),#>(cards+(#$35* 7)),#>(cards+(#$35* 8)),#>(cards+(#$35* 9))
  .db #>(cards+(#$35*10)),#>(cards+(#$35*11)),#>(cards+(#$35*12)),#>(cards+(#$35*13)),#>(cards+(#$35*14)),#>(cards+(#$35*15)),#>(cards+(#$35*16)),#>(cards+(#$35*17)),#>(cards+(#$35*18)),#>(cards+(#$35*19))
  .db #>(cards+(#$35*20)),#>(cards+(#$35*21)),#>(cards+(#$35*22)),#>(cards+(#$35*23)),#>(cards+(#$35*24)),#>(cards+(#$35*25)),#>(cards+(#$35*26)),#>(cards+(#$35*27)),#>(cards+(#$35*28)),#>(cards+(#$35*29))
  .db #>(cards+(#$35*30)),#>(cards+(#$35*31)),#>(cards+(#$35*32)),#>(cards+(#$35*33)),#>(cards+(#$35*34)),#>(cards+(#$35*35)),#>(cards+(#$35*36)),#>(cards+(#$35*37)),#>(cards+(#$35*38)),#>(cards+(#$35*39))
  .db #>(cards+(#$35*40)),#>(cards+(#$35*41)),#>(cards+(#$35*42)),#>(cards+(#$35*43)),#>(cards+(#$35*44)),#>(cards+(#$35*45)),#>(cards+(#$35*46)),#>(cards+(#$35*47)),#>(cards+(#$35*48)),#>(cards+(#$35*49))
  .db #>(cards+(#$35*50)),#>(cards+(#$35*51)),#>(cards+(#$35*52)),#>(cards+(#$35*53)),#>(cards+(#$35*54)),#>(cards+(#$35*55))

;; card names

card_names:                    ; [skip]
  .db $21,$2c,$2d,$38,$29,$00,$17,$25,$2b,$29,$00,$02,$02,$00,$00,$00; White Mage 11
  .db $1d,$31,$25,$30,$30,$00,$1a,$33,$38,$2d,$33,$32,$00,$03,$00,$00; Small Potion 2
  .db $1d,$31,$25,$30,$30,$00,$1a,$33,$38,$2d,$33,$32,$00,$04,$00,$00; Small Potion 3
  .db $17,$29,$28,$2d,$39,$31,$00,$1a,$33,$38,$2d,$33,$32,$00,$05,$00; Medium Potion 4
  .db $17,$29,$28,$2d,$39,$31,$00,$1a,$33,$38,$2d,$33,$32,$00,$06,$00; Medium Potion 5
  .db $16,$25,$36,$2b,$29,$00,$1a,$33,$38,$2d,$33,$32,$00,$07,$00,$00; Large Potion 6
  .db $16,$25,$36,$2b,$29,$00,$1a,$33,$38,$2d,$33,$32,$00,$08,$00,$00; Large Potion 7
  .db $1d,$39,$34,$29,$36,$00,$1a,$33,$38,$2d,$33,$32,$00,$09,$00,$00; Super Potion 8
  .db $1d,$39,$34,$29,$36,$00,$1a,$33,$38,$38,$33,$32,$00,$0a,$00,$00; Super Potion 9
  .db $1d,$39,$34,$29,$36,$00,$1a,$33,$38,$2d,$33,$32,$00,$02,$01,$00; Super Potion 10
  .db $21,$2c,$2d,$38,$29,$00,$17,$25,$2b,$29,$00,$02,$02,$00,$00,$00; White Mage 11
  .db $21,$2c,$2d,$38,$29,$00,$17,$25,$2b,$29,$00,$02,$02,$00,$00,$00; White Mage 11
  .db $21,$2c,$2d,$38,$29,$00,$17,$25,$2b,$29,$00,$02,$02,$00,$00,$00; White Mage 11

;;

  .db $1c,$29,$28,$00,$17,$25,$2b,$29,$00,$02,$02,$00,$00,$00,$00,$00; Red Mage 11
  .db $0c,$39,$27,$2f,$30,$29,$36,$00,$03,$00,$00,$00,$00,$00,$00,$00; Buckler 2
  .db $0c,$39,$27,$2f,$30,$29,$36,$00,$04,$00,$00,$00,$00,$00,$00,$00; Buckler 3
  .db $15,$2d,$38,$29,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; Kite 4
  .db $15,$2d,$38,$29,$00,$06,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; Kite 5
  .db $12,$29,$25,$38,$29,$36,$00,$07,$00,$00,$00,$00,$00,$00,$00,$00; Heater 6
  .db $12,$29,$25,$38,$29,$36,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00; Heater 7
  .db $1e,$33,$3b,$29,$36,$00,$1d,$2c,$2d,$29,$30,$28,$00,$09,$00,$00; Tower Shield 8
  .db $1e,$33,$3b,$29,$36,$00,$1d,$2c,$2d,$29,$30,$28,$00,$0a,$00,$00; Tower Shield 9
  .db $1e,$33,$3b,$29,$36,$00,$1d,$2c,$2d,$29,$30,$28,$00,$02,$01,$00; Tower Shield 10
  .db $1c,$29,$28,$00,$31,$25,$2b,$29,$00,$02,$02,$00,$00,$00,$00,$00; Red Mage 11
  .db $1c,$29,$28,$00,$31,$25,$2b,$29,$00,$02,$02,$00,$00,$00,$00,$00; Red Mage 11
  .db $1c,$29,$28,$00,$31,$25,$2b,$29,$00,$02,$02,$00,$00,$00,$00,$00; Red Mage 11

;;

  .db $0f,$31,$34,$36,$29,$37,$37,$00,$02,$08,$00,$00,$00,$00,$00,$00; Empress 17
  .db $1d,$30,$2d,$31,$29,$00,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00; Slime 2
  .db $1e,$39,$32,$32,$29,$30,$29,$36,$00,$04,$00,$00,$00,$00,$00,$00; Tunneler 3
  .db $10,$2d,$29,$32,$28,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00; Fiend 4
  .db $0e,$36,$25,$2f,$29,$00,$06,$00,$00,$00,$00,$00,$00,$00,$00,$00; Drake 5
  .db $1d,$34,$29,$27,$38,$29,$36,$00,$07,$00,$00,$00,$00,$00,$00,$00; Specter 6
  .db $21,$36,$25,$2d,$38,$2c,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00; Ghost 7
  .db $0f,$30,$29,$31,$29,$32,$38,$25,$30,$00,$09,$00,$00,$00,$00,$00; Elemental 8
  .db $21,$2d,$38,$27,$2c,$00,$0a,$00,$00,$00,$00,$00,$00,$00,$00,$00; Witch 9
  .db $10,$25,$31,$2d,$30,$2d,$25,$36,$00,$02,$01,$00,$00,$00,$00,$00; Familiar 10
  .db $0d,$33,$32,$37,$33,$36,$38,$00,$02,$02,$00,$00,$00,$00,$00,$00; Consort 11
  .db $1b,$39,$29,$29,$32,$00,$02,$04,$00,$00,$00,$00,$00,$00,$00,$00; Queen 13
  .db $1c,$29,$2b,$32,$25,$32,$38,$00,$02,$06,$00,$00,$00,$00,$00,$00; Regnant 15

;;

  .db $0f,$31,$34,$36,$29,$37,$37,$00,$02,$08,$00,$00,$00,$00,$00,$00; Empress 17
  .db $1c,$25,$38,$00,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; Rat 2
  .db $0c,$25,$38,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; Bat 3
  .db $13,$31,$34,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; Imp 4
  .db $11,$33,$26,$30,$2d,$32,$00,$06,$00,$00,$00,$00,$00,$00,$00,$00; Goblin 5
  .db $19,$36,$27,$00,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; Orc 6
  .db $19,$2b,$36,$29,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; Ogre 7
  .db $0c,$29,$2c,$33,$30,$28,$29,$36,$00,$09,$00,$00,$00,$00,$00,$00; Beholder 8
  .db $17,$29,$28,$39,$37,$25,$00,$0a,$00,$00,$00,$00,$00,$00,$00,$00; Medusa 9
  .db $0e,$29,$31,$33,$32,$00,$02,$01,$00,$00,$00,$00,$00,$00,$00,$00; Demon 10
  .db $0d,$33,$32,$37,$33,$36,$38,$00,$02,$02,$00,$00,$00,$00,$00,$00; Consort 11
  .db $1b,$39,$29,$29,$32,$00,$02,$04,$00,$00,$00,$00,$00,$00,$00,$00; Queen 13
  .db $1c,$29,$2b,$32,$25,$32,$38,$00,$02,$06,$00,$00,$00,$00,$00,$00; Regnant 15

;;

  .db $1c,$29,$28,$00,$0e,$33,$32,$37,$33,$30,$00,$03,$02,$00,$00,$00; Red Donsol 21
  .db $0c,$30,$25,$27,$2f,$00,$0e,$33,$32,$37,$33,$30,$00,$03,$02,$00; Black Donsol 21
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00; Blank

;;

card_names_offset_lb:          ; 
  .db #<(card_names+(#$0f* 0)),#<(card_names+(#$0f* 1)),#<(card_names+(#$0f* 2)),#<(card_names+(#$0f* 3)),#<(card_names+(#$0f* 4)),#<(card_names+(#$0f* 5)),#<(card_names+(#$0f* 6)),#<(card_names+(#$0f* 7)),#<(card_names+(#$0f* 8)),#<(card_names+(#$0f* 9))
  .db #<(card_names+(#$0f*10)),#<(card_names+(#$0f*11)),#<(card_names+(#$0f*12)),#<(card_names+(#$0f*13)),#<(card_names+(#$0f*14)),#<(card_names+(#$0f*15)),#<(card_names+(#$0f*16)),#<(card_names+(#$0f*17)),#<(card_names+(#$0f*18)),#<(card_names+(#$0f*19))
  .db #<(card_names+(#$0f*20)),#<(card_names+(#$0f*21)),#<(card_names+(#$0f*22)),#<(card_names+(#$0f*23)),#<(card_names+(#$0f*24)),#<(card_names+(#$0f*25)),#<(card_names+(#$0f*26)),#<(card_names+(#$0f*27)),#<(card_names+(#$0f*28)),#<(card_names+(#$0f*29))
  .db #<(card_names+(#$0f*30)),#<(card_names+(#$0f*31)),#<(card_names+(#$0f*32)),#<(card_names+(#$0f*33)),#<(card_names+(#$0f*34)),#<(card_names+(#$0f*35)),#<(card_names+(#$0f*36)),#<(card_names+(#$0f*37)),#<(card_names+(#$0f*38)),#<(card_names+(#$0f*39))
  .db #<(card_names+(#$0f*40)),#<(card_names+(#$0f*41)),#<(card_names+(#$0f*42)),#<(card_names+(#$0f*43)),#<(card_names+(#$0f*44)),#<(card_names+(#$0f*45)),#<(card_names+(#$0f*46)),#<(card_names+(#$0f*47)),#<(card_names+(#$0f*48)),#<(card_names+(#$0f*49))
  .db #<(card_names+(#$0f*50)),#<(card_names+(#$0f*51)),#<(card_names+(#$0f*52)),#<(card_names+(#$0f*53)),#<(card_names+(#$0f*54)),#<(card_names+(#$0f*55))
card_names_offset_hb:          ; 
  .db #>(card_names+(#$0f* 0)),#>(card_names+(#$0f* 1)),#>(card_names+(#$0f* 2)),#>(card_names+(#$0f* 3)),#>(card_names+(#$0f* 4)),#>(card_names+(#$0f* 5)),#>(card_names+(#$0f* 6)),#>(card_names+(#$0f* 7)),#>(card_names+(#$0f* 8)),#>(card_names+(#$0f* 9))
  .db #>(card_names+(#$0f*10)),#>(card_names+(#$0f*11)),#>(card_names+(#$0f*12)),#>(card_names+(#$0f*13)),#>(card_names+(#$0f*14)),#>(card_names+(#$0f*15)),#>(card_names+(#$0f*16)),#>(card_names+(#$0f*17)),#>(card_names+(#$0f*18)),#>(card_names+(#$0f*19))
  .db #>(card_names+(#$0f*20)),#>(card_names+(#$0f*21)),#>(card_names+(#$0f*22)),#>(card_names+(#$0f*23)),#>(card_names+(#$0f*24)),#>(card_names+(#$0f*25)),#>(card_names+(#$0f*26)),#>(card_names+(#$0f*27)),#>(card_names+(#$0f*28)),#>(card_names+(#$0f*29))
  .db #>(card_names+(#$0f*30)),#>(card_names+(#$0f*31)),#>(card_names+(#$0f*32)),#>(card_names+(#$0f*33)),#>(card_names+(#$0f*34)),#>(card_names+(#$0f*35)),#>(card_names+(#$0f*36)),#>(card_names+(#$0f*37)),#>(card_names+(#$0f*38)),#>(card_names+(#$0f*39))
  .db #>(card_names+(#$0f*40)),#>(card_names+(#$0f*41)),#>(card_names+(#$0f*42)),#>(card_names+(#$0f*43)),#>(card_names+(#$0f*44)),#>(card_names+(#$0f*45)),#>(card_names+(#$0f*46)),#>(card_names+(#$0f*47)),#>(card_names+(#$0f*48)),#>(card_names+(#$0f*49))
  .db #>(card_names+(#$0f*50)),#>(card_names+(#$0f*51)),#>(card_names+(#$0f*52)),#>(card_names+(#$0f*53)),#>(card_names+(#$0f*54)),#>(card_names+(#$0f*55))

;; shuffles

shuffleA:                      ; 
  .db $03,$10,$18,$23,$32,$0f,$06,$2a,$1e,$0b,$34,$17,$0c,$19
  .db $07,$11,$35,$21,$31,$12,$2e,$02,$08,$16,$1f,$1a,$25,$00
  .db $33,$0e,$05,$1d,$26,$13,$1b,$0d,$22,$2b,$28,$29,$20,$1c
  .db $09,$24,$14,$04,$27,$2f,$30,$0a,$2c,$2d,$01,$15
shuffleB:                      ; 
  .db $1e,$0a,$13,$18,$2b,$02,$08,$0d,$06,$20,$33,$30,$34,$03
  .db $12,$10,$1d,$15,$25,$1c,$22,$28,$21,$04,$07,$26,$23,$01
  .db $2a,$17,$0c,$2d,$32,$2c,$29,$09,$0e,$11,$19,$2f,$31,$1a
  .db $1f,$0f,$2e,$16,$24,$1b,$14,$27,$0b,$05,$35,$00
shuffleC:                      ; 
  .db $19,$34,$1b,$29,$2b,$15,$16,$1c,$11,$1f,$27,$01,$1d,$0f
  .db $30,$06,$14,$0a,$31,$05,$20,$26,$2c,$00,$0c,$1e,$22,$0b
  .db $33,$07,$04,$0d,$2a,$2f,$08,$28,$23,$21,$25,$12,$0e,$2e
  .db $18,$03,$1a,$10,$32,$35,$09,$24,$13,$2d,$02,$17
shuffleD:                      ; 
  .db $29,$01,$09,$32,$20,$08,$1c,$19,$18,$30,$23,$05,$1b,$1d
  .db $0c,$13,$03,$0a,$1f,$12,$0b,$21,$1e,$04,$25,$35,$0d,$16
  .db $14,$2a,$00,$15,$06,$33,$17,$24,$0e,$34,$2e,$11,$10,$2c
  .db $07,$2d,$22,$1a,$02,$0f,$27,$26,$28,$31,$2b,$2f

;; splash

selections@splash:             ; 
  .db $2c,$5c,$9c

;;

data@splash:                   ; [skip]
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$a9,$aa,$a9,$aa,$a9,$aa,$a9,$aa,$a9,$aa,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$a5,$a4,$a5,$a4,$a5,$a5,$a4,$a5,$a4,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$a5,$00,$a5,$00,$a5,$a5,$00,$a5,$00,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$a5,$96,$a5,$96,$a5,$a5,$96,$a5,$96,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$aa,$a9,$aa,$a9,$aa,$a9,$aa,$a9,$aa,$a9,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$b1,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$a5,$a5,$a5,$a5,$a5,$a5,$a5,$a5,$a5,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$a7,$a7,$a5,$a7,$a5,$a5,$a5,$a5,$a3,$a5,$a3,$a3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$b8,$b1,$b5,$b9,$b1,$b5,$b8,$b2,$b5,$b9,$b1,$90,$b9,$b1,$b5,$b3,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$ba,$00,$ba,$ba,$00,$ba,$ba,$00,$ba,$b6,$b1,$b5,$ba,$00,$ba,$ba,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$ba,$00,$ba,$ba,$00,$ba,$ba,$00,$ba,$b3,$00,$ba,$ba,$00,$ba,$ba,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$b0,$b1,$bb,$b6,$b1,$bb,$b0,$00,$b4,$b6,$b1,$bb,$b6,$b1,$bb,$b6,$b1,$90,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$a1,$a1,$a5,$a1,$a9,$b1,$b1,$a9,$a0,$a5,$a0,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$a5,$a4,$a5,$aa,$a6,$a6,$aa,$a5,$a4,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$a5,$00,$a5,$aa,$00,$00,$aa,$a5,$00,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$a8,$a5,$96,$a5,$aa,$00,$00,$aa,$a5,$96,$a5,$a8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$ac,$ab,$ab,$ab,$ab,$af,$ae,$ae,$af,$ab,$ab,$ab,$ab,$ab,$ad,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$ab,$af,$af,$ab,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$ab,$ab,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$0f,$25,$37,$3d,$00,$00,$18,$33,$36,$31,$25,$30,$00,$00,$12,$25,$36,$28,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;;

attributes@splash:             ; 
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000