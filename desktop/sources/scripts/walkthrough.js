'use strict'

function Walkthrough () {
  this.is_running = false
  this.speed = 2500

  this.start = function () {
    console.log('Started walkthrough')
    this.is_running = true
  }

  this.run = function (force = false) {
    if (!this.is_running && !force) { return } // Idle
    if (donsol.player.health.value < 1) { this.is_running = false; return }

    let results = this.rate_room(donsol.board.room)
    let target = results[0]

    // Return if going to waste potions
    if (target && target[1] < -10 && donsol.player.can_escape()) {
      donsol.player.escape_room()
      return
    }

    if (target) {
      donsol.board.room[target[[0]]].touch()
    }
  }

  this.rate_room = function (room) {
    let a = []
    for (let id in room) {
      let card = room[id]
      if (card.is_flipped) { continue }
      a.push(this.rate_card(id, card))
    }
    return a.sort(function (a, b) {
      return a[1] - b[1]
    }).reverse()
  }

  this.rate_card = function (id, card) {
    let rating = 0
    if (card.type == 'diamond') {
      if (donsol.player.shield.value > 0) {
        rating = donsol.player.shield.value - card.value
      } else {
        rating = card.value
      }
    }
    if (card.type == 'heart') {
      // Will waste
      if (!donsol.player.can_drink || donsol.player.health.value == 21) {
        rating = -card.value * 4
      } else {
        let after = clamp(donsol.player.health.value + card.value, 0, 21)
        let actual = (donsol.player.health.value - after)
        rating = actual - card.value
      }
    }
    if (card.type == 'clove' || card.type == 'spade') {
      var strongest = this.find_strongest(id)
      if (card.value < strongest.value) {
        rating = -strongest.value - card.value
      } else {
        rating = -card.value
      }

      if (donsol.player.shield.limit > card.value) {
        rating = donsol.player.shield.limit
      }
    }
    // TODO: Run
    // TODO: Attack in descending order
    // TODO: Don't waste shields
    return [parseInt(id), rating, card]
  }

  this.find_strongest = function () {
    var strongest = null

    for (let id in donsol.board.room) {
      let card = donsol.board.room[id]
      if (card.type == 'diamond' || card.type == 'heart') { continue }
      if (card.is_flipped) { continue }
      if (!strongest) { strongest = card; continue }
      if (card.value > strongest.value) { strongest = card }
    }
    return strongest
  }

  setInterval(() => { donsol.walkthrough.run() }, this.speed)
  function clamp (v, min, max) { return v < min ? min : v > max ? max : v }
}

document.onkeyup = (e) => {
  if (e.ctrlKey && e.key.toLowerCase() == 'k') {
    donsol.walkthrough.start()
  }
  if (e.ctrlKey && e.key.toLowerCase() == 'l') {
    donsol.walkthrough.run(true)
  }
}
