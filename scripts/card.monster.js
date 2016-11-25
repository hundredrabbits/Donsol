function Card_Monster(value,type)
{
  Card.call(this,value,type);
  
  this.touch = function()
  {
    if(this.is_flipped){ console.log("Card is already flipped"); return; }
    this.flip();
    donsol.player.attack(this.value);
    donsol.board.update();
  }
}