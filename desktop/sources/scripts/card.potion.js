'use strict'

function Card_Potion (sym, value, type, name = 'Unknown') {
  Card.call(this, sym, value, type, name)

  this.touch = function () {
    if (this.is_flipped) { console.log('Card is already flipped'); return }
    if (donsol.player.health.value < 1) { console.log('Player is dead'); return }
    this.flip()
    donsol.player.drink_potion(this.value)
    donsol.board.update()
  }
}
