function Speaker()
{
  this.effect = new Audio();
  this.ambience = new Audio();

  this.audio_catalog = {};

  this.is_muted = false;

  this.play_effect = function(name)
  {
    console.log("Effect: ",name);
    this.effect = this.fetch_audio(name, "effect", "media/audio/effect/"+name+".ogg");
    this.effect.play()
  }

  this.fetch_audio = function(name, role, src, loop = false)
  {
    var audio_id = role + "_" + name;
    if (!(audio_id in this.audio_catalog))
    {
      var audio = new Audio();
      audio.name = name;
      audio.src = src;
      audio.loop = loop;
      this.audio_catalog[audio_id] = audio;
    }
    this.audio_catalog[audio_id].currentTime = 0;
    return this.audio_catalog[audio_id];
  }
}
