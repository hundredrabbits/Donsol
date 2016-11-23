function Card_Monster(value,type)
{
  Card.call(this,value,type);
  
  this.touch = function()
  {
    console.log("Enemy");
  }
}