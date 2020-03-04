;;;;;;;;;;;;;;;;;;
;;;   TABLES   ;;;
;;;;;;;;;;;;;;;;;;

  .org $E000

  ; $30 -> white
  ; $15 -> red
  ; $3A -> cyan
  ; $2D -> dark grey

palettes: ; red        ; cyan           ; grey
  .db $0F,$15,$2D,$30, $0F,$3A,$2D,$30, $13,$2D,$2D,$30, $0F,$3A,$30,$30 ; background
  .db $0F,$15,$2D,$30, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F ; sprites

cursor_positions:
  .db $28,$60,$98,$d0

card_types:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; hearts
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; diamonds 
  .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02 ; spades
  .db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; clovers
  .db $04,$04,$05                                         ; joker

card_values:
  .db $0b,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0b,$0b ; heart
  .db $0b,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0b,$0b ; diamonds
  .db $11,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0d,$0f ; spades
  .db $11,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0d,$0f ; clovers
  .db $15,$15,$00                                         ; joker

card_glyphs:
  .db $00,$02,$03,$04,$05,$06,$07,$08,$09,$0a
  .db $22,$14,$20,$1b,$00,$15,$08,$0b,$00,$00
  .db $00,$0e,$00

number_high:
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02
  .db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03
  .db $04,$04,$04,$04,$04,$04,$04,$04,$04,$04
  .db $05,$05,$05,$05,$05,$05,$05,$05,$05,$05

number_low:
  .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a
  .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a
  .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a
  .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a
  .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0a

; Health Bars

healthbaroffset:
  .db $c3,$c4,$c5,$c6,$c7,$c8,$c9

healthbarpos:
  .db $00,$06,$06,$06,$06,$0c,$0c,$0c,$0c,$12,$12
  .db $12,$12,$18,$18,$18,$18,$1E,$1E,$1E,$1E,$24

progressbar:
  .db $60,$61,$61,$61,$61,$62 ; $00
  .db $67,$61,$61,$61,$61,$62 ; $06
  .db $64,$63,$61,$61,$61,$62 ; $0c
  .db $64,$65,$63,$61,$61,$62 ; $12
  .db $64,$65,$65,$63,$61,$62 ; $18
  .db $64,$65,$65,$65,$63,$62 ; $1E
  .db $64,$65,$65,$65,$65,$66 ; $24

shieldbaroffset:
  .db $ca,$cb,$cc,$cd,$ce,$cf,$d0

shieldbarpos:
  .db $00,$06,$06,$0c,$0c,$12
  .db $12,$18,$18,$1E,$1E,$24

experiencebaroffset:
  .db $d1,$d2,$d3,$d4,$d5,$d6,$d7

experiencebarpos:
  .db $00,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
  .db $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$12
  .db $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$18,$18
  .db $18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$1E,$1E,$1E
  .db $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$24

card1pos_high:
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22

card1pos_low:
  .db $83,$84,$85,$86,$87,$88
  .db $a3,$a4,$a5,$a6,$a7,$a8
  .db $c3,$c4,$c5,$c6,$c7,$c8
  .db $e3,$e4,$e5,$e6,$e7,$e8
  .db $03,$04,$05,$06,$07,$08
  .db $23,$24,$25,$26,$27,$28
  .db $43,$44,$45,$46,$47,$48
  .db $63,$64,$65,$66,$67,$68
  .db $83,$84,$85,$86,$87,$88

card2pos_low:
  .db $8a,$8b,$8c,$8d,$8e,$8f
  .db $aa,$ab,$ac,$ad,$ae,$af
  .db $ca,$cb,$cc,$cd,$ce,$cf
  .db $ea,$eb,$ec,$ed,$ee,$ef
  .db $0a,$0b,$0c,$0d,$0e,$0f
  .db $2a,$2b,$2c,$2d,$2e,$2f
  .db $4a,$4b,$4c,$4d,$4e,$4f
  .db $6a,$6b,$6c,$6d,$6e,$6f
  .db $8a,$8b,$8c,$8d,$8e,$8f

card3pos_high:
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $21,$21,$21,$21,$21,$21
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22
  .db $22,$22,$22,$22,$22,$22

card3pos_low:
  .db $91,$92,$93,$94,$95,$96
  .db $b1,$b2,$b3,$b4,$b5,$b6
  .db $d1,$d2,$d3,$d4,$d5,$d6
  .db $f1,$f2,$f3,$f4,$f5,$f6
  .db $11,$12,$13,$14,$15,$16
  .db $31,$32,$33,$34,$35,$36
  .db $51,$52,$53,$54,$55,$56
  .db $71,$72,$73,$74,$75,$76
  .db $91,$92,$93,$94,$95,$96

card4pos_low:
  .db $98,$99,$9a,$9b,$9c,$9d
  .db $b8,$b9,$ba,$bb,$bc,$bd
  .db $d8,$d9,$da,$db,$dc,$dd
  .db $f8,$f9,$fa,$fb,$fc,$fd
  .db $18,$19,$1a,$1b,$1c,$1d
  .db $38,$39,$3a,$3b,$3c,$3d
  .db $58,$59,$5a,$5b,$5c,$5d
  .db $78,$79,$7a,$7b,$7c,$7d
  .db $98,$99,$9a,$9b,$9c,$9d

attributes:
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %11000000, %11110000, %10100000, %10100000, %00000000, %00000000
  .db %00000000, %00000100, %00000001, %00001011, %00000000, %00001111, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000

dialog_clear_data: ; $00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00

dialog_potionsickness_data: ; $01
  .db $23,$33,$39,$00,$2a,$29,$29,$30,$00,$37
  .db $2d,$27,$2f,$69,$00,$00,$00,$00,$00,$00

dialog_shieldbreak_data: ; $02
  .db $23,$33,$39,$36,$00,$37,$2c,$2d,$29,$30
  .db $28,$00,$26,$36,$33,$2f,$29,$68,$00,$00