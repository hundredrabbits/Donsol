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
    
    // console.log(event.keyCode);

    switch (event.key || event.keyCode) {
      case " " : this.key_space(); break;
      case "Escape": this.key_escape(); break;
      case "1": donsol.board.room[0].touch(); break;
      case "2": donsol.board.room[1].touch(); break;
      case "3": donsol.board.room[2].touch(); break;
      case "4": donsol.board.room[3].touch(); break;
      // Codes
      case 49: donsol.board.room[0].touch(); break;
      case 50: donsol.board.room[1].touch(); break;
      case 51: donsol.board.room[2].touch(); break;
      case 52: donsol.board.room[3].touch(); break;

      case 32 : this.key_space(); break;
      case 27: this.key_escape(); break;
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
    if(donsol.player.experience.value < 1){
      donsol.new_game();
    }
    else{
      donsol.player.escape_room();
    }
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
    donsol.new_game();
  }
}
