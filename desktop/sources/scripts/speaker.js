'use strict'

function Speaker () {
  this.effect = new Audio()

  this.audio_catalog = {}

  this.is_muted = false

  this.play_effect = function (name) {
    this.effect = this.load(name, 'effect', `media/audio/effect/${name}.ogg`)
    this.effect.play()
  }

  this.load = function (name, role, src, loop = false) {
    let audio_id = role + '_' + name
    if (!(audio_id in this.audio_catalog)) {
      let audio = new Audio()
      audio.name = name
      audio.src = src
      audio.loop = loop
      audio.mute = 'muted'
      this.audio_catalog[audio_id] = audio
    }
    this.audio_catalog[audio_id].currentTime = 0
    return this.audio_catalog[audio_id]
  }
}
