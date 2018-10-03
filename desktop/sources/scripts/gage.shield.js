'use strict'

function Gage_Shield (name, limit, color) {
  Gage.call(this, name, limit, color)

  this.break_limit = null

  this.update = function () {
    if (this.is_damaged() === true) {
      this.value_element.innerHTML = `${this.break_limit - 1}/${this.value} <span class='unit'>DP</span>`
      this.progress.update(this.value < this.break_limit ? this.value : this.break_limit - 1, 11)
    } else if (this.value == 0) {
      this.value_element.innerHTML = "<span class='unit'>--</span>"
      this.progress.update(0, 11)
    } else {
      this.value_element.innerHTML = '<span>' + this.value + "</span> <span class='unit'>DP</span>"
      this.progress.update(this.value, 11)
    }
  }

  this.is_damaged = function () {
    if (this.break_limit === null) { return false }
    return true
  }
}
