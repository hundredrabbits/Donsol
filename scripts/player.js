function Player()
{
  this.element = null;
  this.health = new Gage("Health",21);
  this.shield = new Gage("Shield",0);
  this.experience = new Gage("Experience",0);
  
  this.can_drink = true;
  
  this.start = function()
  {
    this.install();
    this.health.update(21);
    this.shield.update(0);
    this.experience.limit = 52;
  }
  
  this.install = function()
  {
    // Health
    this.element.appendChild(this.health.install());
    // Shield
    this.element.appendChild(this.shield.install());
    // Experience
    this.element.appendChild(this.experience.install());
  }
  
  this.drink_potion = function(potion_value)
  {
    var new_health = this.health.value + potion_value;
    this.health.update(new_health);
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
      }
      else if(attack_value <= this.shield.value){
        this.shield.value = attack_value;
        attack_value = Math.abs(attack_value- this.shield.value);
        console.log("Shield Damaged:"+this.shield.value);
      }
      else{
        attack_value = Math.abs(attack_value- this.shield.value);
        this.shield.value = 0;
        this.shield.limit = 0;
        console.log("Shield Broke, Attack:"+attack_value);
      }
    }
    
    // Damages went through
    if(attack_value > 0){
      this.health.value -= attack_value;
    }
    this.shield.update();
    this.health.update();
  }
  
  this.equip_shield = function(shield_value)
  {
    this.shield.limit = shield_value;
    this.shield.update(shield_value);
  }
}