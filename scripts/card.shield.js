function Card_Shield(value,type)
{
  Card.call(this);
  
  this.touch = function()
  {
    console.log("shield");
  }
}