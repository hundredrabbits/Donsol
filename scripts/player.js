function Player()
{
  this.element = null;
  this.health = new Gage("Health",21,"#ff0000");
  this.shield = new Gage("Shield",0,"#72dec2");
  this.experience = new Gage("Experience",0,"#ffffff");
  
  this.can_drink = true;
  this.has_escaped = false;
  this.escape_button = document.createElement("a");
  this.timeline_element = document.createElement("div");
	
  $(this.escape_button).on( "click", function() {
    donsol.player.escape_room();
	});
  	
  this.start = function()
  {
    this.health.show_limit = false;
    this.health.units = "HP";
    
    this.health.update(21);
    this.shield.update(0);
    this.experience.limit = 52;
    this.experience.update(0);
    
    this.update();
  }
  
  this.install = function()
  {
    this.element.appendChild(this.health.install());
    this.element.appendChild(this.shield.install());
    this.element.appendChild(this.experience.install());
    
    this.escape_button.setAttribute("class","escape");
    this.escape_button.innerHTML = "Escape";
    this.element.appendChild(this.escape_button);
    this.timeline_element.setAttribute("class","timeline");
    this.timeline_element.innerHTML = "";
    this.element.appendChild(this.timeline_element);
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
      donsol.timeline.add_event("Wasted potion!");
      return;
    }
    var new_health = this.health.value + potion_value;
    this.health.update(new_health);
    donsol.timeline.add_event("<span class='health plus'>"+potion_value+"</span> <span class='experience plus'>1</span> Drank potion.");
    this.can_drink = false;
  }
  
  this.escape_room = function()
  {
    if(this.can_escape() !== true){
      donsol.timeline.add_event("Cannot escape the room!");
      return;
    }
    
    this.has_escaped = true;
    
    donsol.board.return_cards();
    donsol.board.enter_room();
    donsol.timeline.add_event("Escaped the room!");
  }
  
  this.gain_level = function()
  {
    donsol.timeline.add_event("<span class='level plus'>"+1+"</span> Level up!");
  }
  
  this.update = function()
  {
    if(this.can_escape() === true){
      this.escape_button.innerHTML = "Run";
    }
    else{
      this.escape_button.innerHTML = "Locked";
    }
  }
  
  this.can_escape = function()
  {
    if(this.experience.value === 0){ console.log("New game skip"); return true; }
    if(donsol.board.cards_flipped().length == 3 && this.has_escaped === false){ console.log("almost clear room"); return true; }
    if(donsol.board.cards_flipped().length > 0){ console.log("Cannot escape, Room already started"); return false; }
    if(this.has_escaped === false){ return true; }
    return false;
  }
}
