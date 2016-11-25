function Player()
{
  this.element = null;
  this.health = new Gage("Health",21);
  this.shield = new Gage("Shield",11);
  this.experience = new Gage("Experience",52);
  
  this.start = function()
  {
    this.install();
    this.health.update(21);
    this.shield.update(0);
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
    var original_attack_value = attack_value;
    var original_health_value = this.health.value;
    var original_shield_value = this.shield.value;
    
    if(this.shield.value > 0){
      // Shield Break
      if(attack_value > this.shield.value  && this.shield.value != this.shield.limit){
        this.shield.value = 0;
        this.shield.limit = 0;
      }
      else{
        attack_value -= this.shield.value;
        this.shield.value -= attack_value;
      }
    }
    
    // Damages went through
    if(attack_value > 0){
      this.health.value -= attack_value;
    }
    this.shield.update();
    this.health.update();
    
    if(this.shield.value === 0){
      this.shield.limit = 0;
    }
  }
  
  this.equip_shield = function(shield_value)
  {
    this.shield.limit = shield_value;
    this.shield.update(shield_value);
  }
}