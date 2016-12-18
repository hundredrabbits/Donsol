function Card_Shield(sym,value,type,name = "Unknown")
{
  Card.call(this,sym,value,type,name);
  
  this.touch = function()
  {
    if(this.is_flipped == true){ console.log("Card is already flipped"); return; }
    if(donsol.player.health.value < 1){ console.log("Player is dead"); return; }
    this.flip();
    donsol.player.equip_shield(this.value);
    donsol.board.update();
  }
}