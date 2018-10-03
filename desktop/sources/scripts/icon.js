'use strict'

function Icon (type) {
  this.type = type

  this.install = function () {
    switch (this.type) {
      case HEART:
        return this.heart()
      case DIAMOND:
        return this.diamond()
      case CLOVE:
        return this.clove()
      case SPADE:
        return this.spade()
      case JOKER:
        return this.joker()
    }
  }

  this.heart = function () {
    let e = document.createElementNS('http://www.w3.org/2000/svg', 'svg')
    e.setAttribute('class', 'icon')

    let s = document.createElementNS('http://www.w3.org/2000/svg', 'path')
    s.setAttribute('d', 'M0,15 a15,15 0 0,1 30,0 l-15,15 l-15,-15')
    s.setAttribute('class', 'fill_red')

    e.appendChild(s)
    return e
  }

  this.diamond = function () {
    let e = document.createElementNS('http://www.w3.org/2000/svg', 'svg')
    e.setAttribute('class', 'icon')

    let s = document.createElementNS('http://www.w3.org/2000/svg', 'path')
    s.setAttribute('d', 'M15 0 L 30 15 L 15 30 L 0 15')
    s.setAttribute('class', 'fill_red')

    e.appendChild(s)
    return e
  }

  this.clove = function () {
    let e = document.createElementNS('http://www.w3.org/2000/svg', 'svg')
    e.setAttribute('class', 'icon')

    let s = document.createElementNS('http://www.w3.org/2000/svg', 'circle')
    s.setAttribute('cx', '15px')
    s.setAttribute('cy', '6px')
    s.setAttribute('r', '5px')
    s.setAttribute('class', 'fill_black')
    e.appendChild(s)

    let s2 = document.createElementNS('http://www.w3.org/2000/svg', 'circle')
    s2.setAttribute('cx', '24px')
    s2.setAttribute('cy', '15px')
    s2.setAttribute('r', '5px')
    s2.setAttribute('class', 'fill_black')
    e.appendChild(s2)

    let s3 = document.createElementNS('http://www.w3.org/2000/svg', 'circle')
    s3.setAttribute('cx', '6px')
    s3.setAttribute('cy', '15px')
    s3.setAttribute('r', '5px')
    s3.setAttribute('class', 'fill_black')
    e.appendChild(s3)

    let s4 = document.createElementNS('http://www.w3.org/2000/svg', 'circle')
    s4.setAttribute('cx', '15px')
    s4.setAttribute('cy', '24px')
    s4.setAttribute('r', '5px')
    s4.setAttribute('class', 'fill_black')
    e.appendChild(s4)

    return e
  }

  this.spade = function () {
    let e = document.createElementNS('http://www.w3.org/2000/svg', 'svg')
    e.setAttribute('class', 'icon')

    let s = document.createElementNS('http://www.w3.org/2000/svg', 'path')
    s.setAttribute('d', 'M15,0 L0,15 a15,15 0 0,1 15,15 a15,15 0 0,1 15,-15')
    s.setAttribute('class', 'fill_black')

    e.appendChild(s)
    return e
  }

  this.joker = function () {
    let e = document.createElementNS('http://www.w3.org/2000/svg', 'svg')
    e.setAttribute('class', 'icon')

    let s = document.createElementNS('http://www.w3.org/2000/svg', 'circle')
    s.setAttribute('cx', '15px')
    s.setAttribute('cy', '15px')
    s.setAttribute('r', '15px')
    s.setAttribute('class', 'fill_black')
    e.appendChild(s)

    return e
  }
}
