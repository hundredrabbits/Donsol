function Player()
{
  this.element = null;
  this.health = new Gage("Health",21);
  this.shield = new Gage("Shield",0);
  this.experience = new Gage("Experience",0);
  
  this.can_drink = true;
  this.has_escaped = false;
  
  this.start = function()
  {
    this.install();
    this.health.update(21);
    this.shield.update(0);
    this.experience.limit = 52;
  }
  
  this.install = function()
  {
    this.element.appendChild(this.health.install());
    this.element.appendChild(this.shield.install());
    this.element.appendChild(this.experience.install());
    
    // Shield Status
    this.shield.status = new Radial_Progress(10, "#ffffff")
    this.shield.element.appendChild(this.shield.status.install());
    this.shield.status.update(0,1);
    
    // Dongeon Depth
    var dongeon_depth = new Radial_Progress(10);
    this.experience.element.appendChild(dongeon_depth.install());
    dongeon_depth.update(0,6);
  }
  
  this.drink_potion = function(potion_value)
  {
    var new_health = this.health.value + potion_value;
    this.health.update(new_health);
    this.health.add_notification("+"+(potion_value)+"hp","#72dec2");
  }
  
  this.attack = function(attack_value)
  {
    var damages = attack_value;
    // Shield
    console.log("Attack:"+attack_value);
    if(this.shield.value > 0){
      console.log("Shield:"+this.shield.value);
      // Damaged shield
      if(attack_value >= this.shield.limit){
        this.shield.add_notification("Broke!","red");
        this.shield.value = 0;
        this.shield.limit = 0;
      }
      else
      {
        this.shield.add_notification("Damaged","red");
        this.shield.limit = attack_value;
        damages = attack_value > this.shield.value ? Math.abs(attack_value - this.shield.value) : 0;
      }
    }
  
    // Damages went through
    if(damages > 0){
      this.health.value -= damages;
      this.health.add_notification("-"+damages+"hp","red");
    }
    
    this.shield.update();
    this.health.update();
    
  }
  
  this.equip_shield = function(shield_value)
  {
    this.shield.limit = 100;
    this.shield.update(shield_value);
    this.shield.status.update(100,100);
  }
}