function Card_Potion(value,type)
{
  Card.call(this);
  
  this.touch = function()
  {
    console.log("Potion");
  }
}