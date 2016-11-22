function Card_Monster(value,type)
{
  Card.call(this);
  
  this.touch = function()
  {
    console.log("Enemy");
  }
}