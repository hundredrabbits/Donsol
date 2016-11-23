function Player()
{
  this.element = null;
  this.health = new Gage("Health");
  this.shield = new Gage("Shield");
  this.experience = new Gage("Experience");
  
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
}