function Card_Shield(sym,value,type,name = "Unknown")
{
  Card.call(this,sym,value,type,name);
  
  this.touch = function()
  {
    if(this.is_flipped == true){ console.log("Card is already flipped"); return; }
    console.log("Shield");
    this.flip();
    donsol.player.equip_shield(this.value);
    donsol.board.update();
  }
}