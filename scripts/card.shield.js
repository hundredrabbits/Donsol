function Card_Shield(value,type)
{
  Card.call(this,value,type);
  
  this.touch = function()
  {
    console.log("shield");
  }
}