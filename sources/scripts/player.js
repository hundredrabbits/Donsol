function Player()
{
  this.element = null;
  this.health = new Gage_Health("Health",21,"#ff0000");
  this.shield = new Gage_Shield("Shield",0,"#72dec2");
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
    this.shield.units = "DP";
    this.experience.units = "XP";
    this.experience.show_limit = false;
    
    this.health.update(21);
    this.shield.update(0);
    this.experience.limit = 54;
    this.experience.update(0);
    
    this.can_drink = true;
    this.has_escaped = false;
    
    this.update();
  }
  
  this.install = function()
  {
    this.element.appendChild(this.experience.install());
    this.element.appendChild(this.shield.install());
    this.element.appendChild(this.health.install());
    
    this.escape_button.setAttribute("class","escape");
    this.escape_button.innerHTML = "Escape";
    this.element.appendChild(this.escape_button);
    this.timeline_element.setAttribute("class","timeline");
    this.timeline_element.innerHTML = "";
    this.element.appendChild(this.timeline_element);
  }
  
  this.attack = function(card)
  {
    console.log("<attack>"+card.value);
    var attack_value = card.value;
    var damages = attack_value;

    // Shield
    if(this.shield.value > 0){
      // Damaged shield
      if(this.shield.is_damaged() === true && attack_value >= this.shield.break_limit){
        this.shield.value = 0;
        this.shield.break_limit = null;
        donsol.player.shield.add_event("<span style='color:red'>Broke!</span>");
      }
      else
      {
        this.shield.break_limit = attack_value;
        damages = attack_value > this.shield.value ? Math.abs(attack_value - this.shield.value) : 0;
      }
    }
  
    // Damages went through
    if(damages > 0){
      this.health.value -= damages;
    }
    
    // Timeline
    if(this.health.value < 1){
      donsol.player.health.add_event("-"+damages);
      donsol.timeline.add_event("<span style='color:red'>The "+card.name+" killed you!</span>");
      donsol.board.dungeon_failed();
      this.update();
    }
    else if(damages > 0){
      donsol.player.health.add_event("-"+damages);
      donsol.timeline.add_event("Battled the "+card.name+".");
    }
    
    // Experience
    donsol.player.experience.add_event("+1");
    
    this.can_drink = true;
    donsol.is_complete = false;
    this.shield.update();
    this.health.update();
  }
  
  this.equip_shield = function(shield_value)
  {
    console.log("<shield>"+shield_value);

    this.shield.value = shield_value;
    this.shield.break_limit = null;

    // donsol.player.shield.add_event(shield_value);
    donsol.player.experience.add_event("+1");
    donsol.timeline.add_event("Equipped shield "+shield_value+".");
    this.can_drink = true;
    donsol.is_complete = false;
    this.shield.update();
    this.health.update();
  }
  
  this.drink_potion = function(potion_value)
  {
    console.log("<potion>"+potion_value);

    if(this.can_drink === false){
      donsol.timeline.add_event("Wasted potion!");
      donsol.player.health.add_event("Wasted");
      return;
    }
    var before_health = this.health.value;
    var new_health = this.health.value + potion_value; new_health = new_health > 21 ? 21 : new_health;
    

    var mod = new_health - before_health;
    donsol.player.health.add_event(mod > 0 ? "+"+mod : "Wasted");
    donsol.player.experience.add_event("+1");
    donsol.timeline.add_event("Drank potion.");
    this.can_drink = false;
    donsol.is_complete = false;
    this.health.update();
    this.shield.update();
  }
  
  this.escape_room = function()
  {
    if(this.health.value < 1 || donsol.is_complete === true || this.experience.value == 0){
      donsol.new_game();
      return;
    }
    if(this.can_escape() !== true){
      donsol.timeline.add_event("Cannot escape the room!");
      return;
    }
    
    this.has_escaped = true;
    this.can_drink = true;
    
    donsol.board.return_cards();
    donsol.board.enter_room();
    donsol.timeline.add_event("Escaped the room!");
  }
  
  this.update = function()
  {
    if(this.health.value < 1){
      this.escape_button.innerHTML = "Restart";
      this.element.setAttribute("class","death");
    }
    else if(this.can_escape() === true){
      this.escape_button.innerHTML = "Run";
      this.element.setAttribute("class","unlocked");
    }
    else{
      this.escape_button.innerHTML = "Locked";
      this.element.setAttribute("class","locked");
    }
    
    this.health.clear_event();
    this.shield.clear_event();
    this.experience.clear_event();
  }
  
  this.can_escape = function()
  {
    if(this.health.value < 1){ return true; }                                                   // Death
    if(this.experience.value === 0){ return true; }                                             // New Game
    if(donsol.board.cards_monsters().length > 0 && this.has_escaped === true){ return false; }  // Room Started
    if(donsol.board.cards_monsters().length == 0){ return true; }                               // Monsters in the room
    if(this.has_escaped === false){ return true; }                                              // Can escape
    return false;
  }
}
