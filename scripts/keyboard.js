function Keyboard()
{
  this.is_locked = false;

  this.lock = function()
  {
    this.is_locked = true;
    interface.actions_panel.style.color = "red";
  }

  this.unlock = function()
  {
    this.is_locked = false;
    interface.actions_panel.style.color = "black";
  }

  this.listen = function(event)
  {
    if(this.is_locked === true){ return; }
  
    switch (event.key) {
      case "Enter": this.key_enter(); break;
      case " " : this.key_space(); break;
      case "ArrowUp": this.key_arrow_up(); break;
      case "ArrowDown": this.key_arrow_down(); break;
      case "ArrowLeft": this.key_arrow_left(); break;
      case "ArrowRight": this.key_arrow_right(); break;
      case ":": this.key_colon(); break;
      //not sure if this one needed anymore
      case ";": if (event.shiftKey) this.key_colon(); break;
      case "Escape": this.key_escape(); break;
    }
  };

  this.key_tab = function()
  {
  }

  this.key_enter = function()
  {
    
  }

  this.key_space = function()
  {
  }

  this.key_arrow_up = function()
  {
  }

  this.key_arrow_down = function()
  {
  }

  this.key_arrow_left = function()
  {
  }

  this.key_arrow_right = function()
  {
  }

  this.key_colon = function()
  {
  }

  this.key_escape = function()
  {
  }
}
