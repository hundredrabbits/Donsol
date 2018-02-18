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

  this.play_ambience = function(name)
  {
    if(this.ambience.name == name){ return; }
    if(DEBUG){ return; }

    // Fadeout
    $(this.ambience).animate({volume: 0}, 1000, function(){
      console.log("Music: ",name);

      oquonie.music.ambience.pause();
      oquonie.music.ambience = oquonie.music.fetch_audio(name, "ambience", "media/audio/ambience/"+name+".mp3", true);
      if(oquonie.music.is_muted == false){ oquonie.music.ambience.play(); }
      $(oquonie.music.ambience).animate({volume: 1}, 1000);
    });
  }

  this.pause_ambience = function()
  {
    this.is_muted = true;

    $(this.ambience).animate({volume: 0}, 1000, function(){
      oquonie.music.ambience.pause();
    });
  }

  this.resume_ambience = function()
  {
    this.ambience.play();
    this.ambience.volume = 0;
    $(this.ambience).animate({volume: 1}, 1000);
    this.is_muted = false;
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
