# Donsol

Donsol is a solitary card game, designed by John Eternal in which you must go through the deck in sequences of 4 cards.

<img src='https://raw.githubusercontent.com/hundredrabbits/Donsol/master/PREVIEW.jpg' width="600"/>

## Guide

A standard deck, jokers included, is a dungeon. Shuffle the deck and draw 4 cards, display them before you, this is a room. A room ends when all the cards are folded.

### ♥︎ Hearts are Potions

Potion give you health points equal to their value, up to a maximum of 21 health points. Drinking multiple potions in a row will make you sick and result in no extra healing, only the first potion's value will be gained in HP. Potions are equal to their value and face cards (J,Q,K,A) each are equal to 11.

### ♦ Diamonds are Shields

Shields absorb the damage difference from a monster's value. Shields can only defend against monsters in descending value and if you use a shield on a monster with higher or equal value to the previous, it will break. Broken shields leave you unarmored, and taking full damage. A shield card will replace a previously folded shield card. Shields are equal to their value and face cards (J,Q,K,A) each are equal to 11.

### ♣♠ Clubs and Spades are Monster Cards

Monster cards are equal to their value, and face cards are as follows J is 11, Q is 13, K is 15, A is 17; Jokers are both equal to 21. You may escape a room, if you have not escaped the previous one or have handled all the monsters in the current room. When escaping, the remaining cards are shuffled back into the deck.

## Controls

### File
- New: `CmdOrCtrl+N`

### Cards
- Pick 1: `1`
- Pick 2: `2`
- Pick 3: `3`
- Pick 4: `4`

### Room
- Escape: `Space`
- Restart: `Esc`

<img src='https://cdn.rawgit.com/hundredrabbits/Donsol/master/LAYOUT.svg?v=1' width="600"/>

## Install

```
cd desktop
npm install
npm start
```

## Extras

- This application supports the [Ecosystem Theme](https://github.com/hundredrabbits/Themes).
- Support this project through [Patreon](https://patreon.com/100).
- See the [License](LICENSE.md) file for license rights and limitations (MIT).
- Pull Requests are welcome!
