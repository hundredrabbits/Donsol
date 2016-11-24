function Player()
{
  this.element = null;
  this.health = new Gage("Health",21);
  this.shield = new Gage("Shield",11);
  this.experience = new Gage("Experience",52);
  
  this.start = function()
  {
    this.install();
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
  
  this.heal = function(value)
  {
    console.log("Healing value:"+value);
  }
  
  this.attack = function(value)
  {
    console.log("Attack value:"+value);
  }
}