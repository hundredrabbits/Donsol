function Gage_Shield(name,limit,color)
{
  Gage.call(this,name,limit,color);

  this.break_limit = null;

  this.update = function()
  {
    if(this.is_damaged() === true){
      this.value_element.innerHTML = this.value+" <span class='unit'>DP</span> "+this.break_limit+" <span class='unit'>MAX</span>";
    }
    else if(this.is_damaged() === false && this.value == 11){
      this.value_element.innerHTML = "<span style='color:#82dec2'>"+this.value+"</span> <span class='unit'>DP</span>";  
    }
    else{
      this.value_element.innerHTML = this.value+" <span class='unit'>DP</span>";  
    }

    this.progress.update(this.value,11);
  }

  this.is_damaged = function()
  {
    if(this.break_limit === null){ return false; }
    return true;
  }
}
