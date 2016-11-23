function Card_Potion(value,type)
{
  Card.call(this,value,type);
  
  this.touch = function()
  {
    console.log("Potion");
  }
}