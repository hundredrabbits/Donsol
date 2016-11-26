function Card_Potion(sym,value,type,name = "Unknown")
{
  Card.call(this,sym,value,type,name);
  
  this.touch = function()
  {
    if(this.is_flipped){ console.log("Card is already flipped"); return; }
    this.flip();
    donsol.player.drink_potion(this.value);
    donsol.board.update();
  }
}