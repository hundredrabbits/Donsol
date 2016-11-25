function Card_Potion(value,type)
{
  Card.call(this,value,type);
  
  this.touch = function()
  {
    if(this.is_flipped){ console.log("Card is already flipped"); return; }
    console.log("Potion");
    this.flip();
    donsol.player.can_drink = false;
    donsol.player.drink_potion(this.value);
    donsol.board.update();
  }
}