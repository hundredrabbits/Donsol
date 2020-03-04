# Notes

A standard deck of playing cards consists of 52 Cards in each of the 4 suits of Spades, Hearts, Diamonds, and Clubs. 
Each suit contains 13 cards: Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King.

## TODOs

### Core

- Implement difficulties (easy/medium/hard)
- Implement deck shuffling
- Implement run
- Implement restart

### Client

- Interpolate stats
- Toggle run ui, when can run
- Implement onscreen guide
- Implement sounds
- Auto switch room timer
- Implement dialog box

### TODOs(minor)

```
; a -> select
; b -> select run
; left/right -> select prev/next
; up/down -< select card/run
```

## Card IDs

```
$00 Hearts Ace
$01 Hearts 2
$02 Hearts 3
$03 Hearts 4
$04 Hearts 5
$05 Hearts 6
$06 Hearts 7
$07 Hearts 8
$08 Hearts 9
$09 Hearts 10
$0a Hearts Jack
$0b Hearts Queen
$0c Hearts King

$0d Diamonds Ace
$0e Diamonds 2
$0f Diamonds 3
$10 Diamonds 4
$11 Diamonds 5
$12 Diamonds 6
$13 Diamonds 7
$14 Diamonds 8
$15 Diamonds 9
$16 Diamonds 10
$17 Diamonds Jack
$18 Diamonds Queen
$19 Diamonds King

$1a Spades Ace
$1b Spades 2
$1c Spades 3
$1d Spades 4
$1e Spades 5
$1f Spades 6
$20 Spades 7
$21 Spades 8
$22 Spades 9
$23 Spades 10
$24 Spades Jack
$25 Spades Queen
$26 Spades King

$27 Clubs Ace
$28 Clubs 2
$29 Clubs 3
$2a Clubs 4
$2b Clubs 5
$2c Clubs 6
$2d Clubs 7
$2e Clubs 8
$2f Clubs 9
$30 Clubs 10
$31 Clubs Jack
$32 Clubs Queen
$33 Clubs King

$34 Joker A
$35 Joker B
```