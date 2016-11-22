function Icon(type)
{
  this.type  = type;
  
  this.install = function()
  {
    switch(this.type) {
      case HEART:
        return this.heart();
      case DIAMOND:
        return this.heart();
      case CLOVE:
        return this.clove();
      case SPADE:
        return this.spade();
    }
  }
  
  this.heart = function()
  {
    return "heart";
  }
  
  this.diamond = function()
  {
    return "diamond";
  }
  
  this.clove = function()
  {
    return "clove";
  }
  
  this.spade = function()
  {
    return "spade";
  }
}