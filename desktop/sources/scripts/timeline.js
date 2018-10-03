'use strict'

function Timeline () {
  this.el = document.createElement('div')
  this.el.id = 'timeline'

  this.install = function (host) {
    host.appendChild(this.el)
  }

  this.add_event = function (message) {
    this.el.className = ''
    this.el.style.opacity = '0'
    setTimeout(() => { this.el.style.opacity = 1; this.el.innerHTML = message }, 100)
  }
}
