function Gage_Health(name,limit,color)
{
  Gage.call(this,name,limit,color);

  this.update = function()
  {
	this.progress.update(this.value,this.limit);  
	  
    if(donsol.player.can_drink === false){
      this.value_element.innerHTML = "<span>"+this.value+"</span> <span class='unit'>HP</span>";
    }
    else{
      this.value_element.innerHTML = this.value+" <span class='unit'>HP</span>";  
    }
    
  }

}
