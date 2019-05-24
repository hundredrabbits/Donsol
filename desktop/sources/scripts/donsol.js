'use strict'

const HEART = 'heart'
const DIAMOND = 'diamond'
const CLOVE = 'clove'
const SPADE = 'spade'
const JOKER = 'joker'

function Donsol () {
  const defaultTheme = {
    background: '#000000',
    f_high: '#000000',
    f_med: '#a93232',
    f_low: '#aaaaaa',
    f_inv: '#ffffff',
    b_high: '#ffffff',
    b_med: '#cccccc',
    b_low: '#333333',
    b_inv: '#a93232'
  }

  this.theme = new Theme(defaultTheme)

  this.deck = new Deck()
  this.board = new Board()
  this.player = new Player()
  this.timeline = new Timeline()
  this.controller = new Controller()
  this.speaker = new Speaker()
  this.walkthrough = new Walkthrough()

  this.is_complete = false
  this.difficulty = 1

  this.install = function (host = document.body) {
    this.theme.install(host)
  }

  this.start = function () {
    donsol.board.element = document.getElementById('board')
    donsol.player.element = document.getElementById('player')

    this.theme.start()
    this.deck.start()
    this.player.install()
    donsol.timeline.install(donsol.player.element)
    this.player.start()

    this.board.enter_room(true)
    donsol.deck.shuffle()

    this.update()
  }

  this.new_game = function () {
    this.deck = new Deck()
    this.deck.start()

    this.player.start()
    this.board.enter_room(true)
    donsol.deck.shuffle()

    this.update()
  }

  this.toggle_difficulty = function () {
    this.difficulty = this.difficulty < 3 ? this.difficulty + 1 : 0
    donsol.new_game()
  }

  this.set_difficulty = function (id) {
    this.difficulty = id
    donsol.new_game()
  }

  this.update = function () {
    console.log('Difficulty', this.difficulty == 3 ? 'Expert' : this.difficulty == 2 ? 'Hard' : this.difficulty == 1 ? 'Normal' : 'Easy')
  }

  this.skip = function () {
    if (donsol.player.experience.value < 1) {
      donsol.new_game()
    } else {
      donsol.player.escape_room()
    }
  }
}
