function Gage(name,limit,color)
{
  this.name = name;
  this.limit = limit;
  this.value = limit;
  this.value_element = null;
  this.element = document.createElement("div");
  this.progress = new Progress(15,color);
  
  this.show_limit = true;
  this.units = "";
  
  this.start = function()
  {
    this.install();
  }
  
  this.install = function()
  {
    this.element.setAttribute("class","gage");
    
    this.element.appendChild(this.progress.install());
    
    this.value_element = document.createElement("span");
    this.value_element.setAttribute("class","value");
    this.value_element.innerHTML = this.value+"/"+this.limit;
    this.element.appendChild(this.value_element);
    
    return this.element
  }
  
  this.update = function(value)
  {
    this.value = value ? value : this.value;
    if(this.value > this.limit){this.value = this.limit;}
    if(this.value < 0){this.value = 0;}
    this.value_element.innerHTML = this.show_limit ? this.value+"/"+this.limit : this.value+this.units;
    this.progress.update(this.value,this.limit);
  }
}