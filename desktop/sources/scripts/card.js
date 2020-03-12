'use strict'

function Card (sym, value, type, name = 'Unknown') {
  this.symbol = sym
  this.value = value
  this.type = type
  this.name = name

  this.element = null
  this.is_flipped = false

  this.install = function () {
    const e = document.createElement('card')
    e.setAttribute('class', this.type + ' card_' + this.value)

    // Face
    const face = document.createElement('div')
    face.setAttribute('class', 'face')
    e.appendChild(face)

    // Value
    const value = document.createElement('span')
    value.setAttribute('class', 'value')
    value.innerHTML = this.symbol
    face.appendChild(value)

    const graphic = document.createElement('div')
    graphic.className = 'graphic'
    graphic.innerHTML = require('fs').readFileSync(`${__dirname}/media/${this.type}/${this.value}.svg`)
    face.appendChild(graphic)

    // Name
    const name_element = document.createElement('span')
    name_element.setAttribute('class', 'name')
    name_element.innerHTML = this.name + ' ' + this.value
    face.appendChild(name_element)

    // Icon
    face.appendChild(new Icon(this.type).install())

    addClickHandler(e, this, this.value)

    this.element = e

    return e
  }

  function addClickHandler (elem, object) {
    elem.addEventListener('click', function (e) { object.touch() }, false)
  }

  this.touch = function () {
    console.log('??')
  }

  this.flip = function () {
    donsol.speaker.play_effect('flip')

    this.is_flipped = true
    donsol.player.experience.value += 1
    donsol.player.experience.update()

    this.element.style.opacity = '0'
    this.element.style.top = '-5px'
    donsol.speaker.play_effect('click2')

    donsol.player.update()
  }
}
