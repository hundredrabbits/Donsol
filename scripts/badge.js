function Badge(value,type)
{
  this.value = value;
  this.type  = type;
  
  this.install = function()
  {
    return this.type+"."+this.value+".svg";
  }
}