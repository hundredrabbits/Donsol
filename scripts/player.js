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
    // Shield
    console.log("Attack:"+attack_value);
    if(this.shield.value > 0){
      console.log("Shield:"+this.shield.value);
      // Shield Break
      if(attack_value > this.shield.value  && this.shield.value != this.shield.limit){
        console.log("Shield: Break!");
        this.shield.value = 0;
        this.shield.limit = 0;
        this.shield.add_notification("Broke!","red");
      }
      else if(attack_value <= this.shield.value){
        this.shield.value = attack_value;
        attack_value = Math.abs(attack_value- this.shield.value);
        console.log("Shield Damaged:"+this.shield.value);
        this.shield.add_notification("Dammaged","red");
      }
      else{
        attack_value = Math.abs(attack_value- this.shield.value);
        this.shield.value = 0;
        this.shield.limit = 0;
        console.log("Shield Broke, Attack:"+attack_value);
        this.shield.add_notification("Broke!","red");
      }
    }
    
    // Damages went through
    if(attack_value > 0){
      this.health.value -= attack_value;
      this.health.add_notification("-"+attack_value+"hp","red");
    }
    this.shield.update();
    this.health.update();
    
    this.shield.status.update(this.shield.value,11);
  }
  
  this.equip_shield = function(shield_value)
  {
    this.shield.limit = shield_value;
    this.shield.update(shield_value);
    this.shield.status.update(shield_value,11);
  }
}