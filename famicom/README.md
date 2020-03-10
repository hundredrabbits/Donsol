# Notes

A standard deck of playing cards consists of 52 Cards in each of the 4 suits of Spades, Hearts, Diamonds, and Clubs. 
Each suit contains 13 cards: Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King.

## TODOs

- Issue with dialogs

### Core

- Can reshuffle on first hand
- Implement deck shuffling
- Implement restart
- Implement splash screen

### Client

- Implement onscreen guide
- Implement sounds
- Implement dungeon complete
- When shield break, display cyan star next to SP

### TODOs(minor)

```
; a -> select
; b -> run
; left/right -> select prev/next
; up/down -< select card/run
```

## Card IDs

```
$00 Blank
$01 Hearts Ace
$02 Hearts 2
$03 Hearts 3
$04 Hearts 4
$05 Hearts 5
$06 Hearts 6
$07 Hearts 7
$08 Hearts 8
$09 Hearts 9
$0a Hearts 10
$0b Hearts Jack
$0c Hearts Queen
$0d Hearts King

$0e Diamonds Ace
$0f Diamonds 2
$10 Diamonds 3
$11 Diamonds 4
$12 Diamonds 5
$13 Diamonds 6
$14 Diamonds 7
$15 Diamonds 8
$16 Diamonds 9
$17 Diamonds 10
$18 Diamonds Jack
$19 Diamonds Queen
$1a Diamonds King

$1b Spades Ace
$1c Spades 2
$1d Spades 3
$1e Spades 4
$1f Spades 5
$20 Spades 6
$21 Spades 7
$22 Spades 8
$23 Spades 9
$24 Spades 10
$25 Spades Jack
$26 Spades Queen
$27 Spades King

$28 Clubs Ace
$29 Clubs 2
$2a Clubs 3
$2b Clubs 4
$2c Clubs 5
$2d Clubs 6
$2e Clubs 7
$2f Clubs 8
$30 Clubs 9
$31 Clubs 10
$32 Clubs Jack
$33 Clubs Queen
$34 Clubs King

$35 Joker A
$36 Joker B
```