function Player()
{
  this.element = null;
  this.health = new Gage("Health",21,"#ff0000");
  this.shield = new Gage("Shield",0,"#72dec2");
  this.experience = new Gage("Experience",0,"#ffffff");
  
  this.can_drink = true;
  this.has_escaped = false;
  
  this.start = function()
  {
    this.health.show_limit = false;
    this.health.units = "HP";
    
    this.install();
    this.health.update(21);
    this.shield.update(0);
    this.experience.limit = 52;
    this.experience.update(0);
  }
  
  this.install = function()
  {
    this.element.appendChild(this.health.install());
    this.element.appendChild(this.shield.install());
    this.element.appendChild(this.experience.install());
  }
  
  this.attack = function(card)
  {
    var attack_value = card.value;
    
    var damages = attack_value;
    // Shield
    console.log("Attack:"+attack_value);
    if(this.shield.value > 0){
      console.log("Shield:"+this.shield.value);
      // Damaged shield
      if(attack_value >= this.shield.limit){
        this.shield.value = 0;
        this.shield.limit = 0;
      }
      else
      {
        this.shield.limit = attack_value;
        damages = attack_value > this.shield.value ? Math.abs(attack_value - this.shield.value) : 0;
      }
    }
  
    // Damages went through
    if(damages > 0){
      this.health.value -= damages;
    }
    
    // Timeline
    if(damages > 0){
      donsol.timeline.add_event("<span class='health minus'>"+damages+"</span> <span class='experience plus'>1</span> Battled the "+card.name+".");
    }
    
    this.shield.update();
    this.health.update();
  }
  
  this.equip_shield = function(shield_value)
  {
    this.shield.limit = 25;
    this.shield.update(shield_value);
    donsol.timeline.add_event("<span class='shield plus'>"+shield_value+"</span> <span class='experience plus'>1</span> Equipped shield.");
  }
  
  this.drink_potion = function(potion_value)
  {
    if(this.can_drink === false){
      donsol.timeline.add_event("Wasted potion! Cannot drink two potions in a row.");
      return;
    }
    var new_health = this.health.value + potion_value;
    this.health.update(new_health);
    donsol.timeline.add_event("<span class='health'>"+potion_value+"</span> <span class='experience plus'>1</span> Drank potion.");
    this.can_drink = false;
  }
}
