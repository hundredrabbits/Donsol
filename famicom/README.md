# Notes

A standard deck of playing cards consists of 52 Cards in each of the 4 suits of Spades, Hearts, Diamonds, and Clubs. 
Each suit contains 13 cards: Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King.

## Styleguide

- Routine that writes on a register, should be called `loadName`.
- Routine that updates the value at a memory address, should be called `updateName`.
- Routine that triggers a redraw, should be called `redrawName`.
- Routine that are triggered during nmi, should be called `alwaysName`.

## TODOs

- Add marker on screen for special mode.
- Screen tear when returning to splash
- Implement deck shuffling
  - Implement shuffle seed
  - Can reshuffle on first hand
- Implement onscreen guide
- Implement sounds

- Implement special mode
- Implement 100R logo

## Rules

- Easy: Can escape if when no monsters present or when the player has not escaped before.
- Normal: Can escape when the player has not escaped before.
- Hard: Can escape if there are no monsters present.
- special mode, can't escape when injured?

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

## Controller ($2000)

```
7  bit  0
---- ----
VPHB SINN
|||| ||||
|||| ||++- Base nametable address
|||| ||    (0 = $2000; 1 = $2400; 2 = $2800; 3 = $2C00)
|||| |+--- VRAM address increment per CPU read/write of PPUDATA
|||| |     (0: add 1, going across; 1: add 32, going down)
|||| +---- Sprite pattern table address for 8x8 sprites
||||       (0: $0000; 1: $1000; ignored in 8x16 mode)
|||+------ Background pattern table address (0: $0000; 1: $1000)
||+------- Sprite size (0: 8x8 pixels; 1: 8x16 pixels)
|+-------- PPU master/slave select
|          (0: read backdrop from EXT pins; 1: output color on EXT pins)
+--------- Generate an NMI at the start of the
           vertical blanking interval (0: off; 1: on)
```

## Mask ($2001) 

```
7  bit  0
---- ----
BGRs bMmG
|||| ||||
|||| |||+- Greyscale (0: normal color, 1: produce a greyscale display)
|||| ||+-- 1: Show background in leftmost 8 pixels of screen, 0: Hide
|||| |+--- 1: Show sprites in leftmost 8 pixels of screen, 0: Hide
|||| +---- 1: Show background
|||+------ 1: Show sprites
||+------- Emphasize red
|+-------- Emphasize green
+--------- Emphasize blue
```