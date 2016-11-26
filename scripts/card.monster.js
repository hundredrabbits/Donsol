function Card_Monster(sym,value,type,name = "Unknown")
{
  Card.call(this,sym,value,type,name);
  
  this.touch = function()
  {
    if(this.is_flipped){ console.log("Card is already flipped"); return; }
    console.log("Monster");
    this.flip();
    donsol.player.attack(this.value);
    donsol.board.update();
  }
}