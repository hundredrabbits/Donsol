function Gage(name,limit,color)
{
  this.name = name;
  this.color = color;
  this.limit = limit;
  this.value = limit;
  this.value_element = null;
  this.event_element = null;
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
    this.element.setAttribute("class","gage "+this.name.toLowerCase());
    
    this.element.appendChild(this.progress.install());
    
    this.value_element = document.createElement("span");
    this.value_element.setAttribute("class","value");
    this.value_element.innerHTML = this.value+"("+this.limit+")";
    this.element.appendChild(this.value_element);
    
    this.event_element = document.createElement("span");
    this.event_element.setAttribute("class","event");
    this.element.appendChild(this.event_element);
    
    return this.element
  }
  
  this.update = function(value)
  {
    this.value = typeof value === "number" ? value : this.value;
    if(this.value > this.limit){this.value = this.limit;}
    if(this.value < 0){this.value = 0;}
    
    this.progress.update(this.value,this.limit);
    
    if(this.name == "Shield" && this.value == 0){
      this.value_element.innerHTML = "0<span class='unit'>DP</span>";
    }
    else if(this.name == "Shield" && this.limit == 25){
      this.value_element.innerHTML = this.value+"<span class='unit'>DP</span>";
    }
    else{
      this.value_element.innerHTML = this.show_limit ? this.value+" < "+this.limit+"<span class='unit'>"+this.units+"</span>" : this.value+" <span class='unit'>"+this.units+"</span>";
    }
  }
  
  this.add_event = function(value)
  {
    this.event_element.innerHTML = "<span class='name'>"+value+"</span>";
    this.event_element.style.marginLeft = "0px";
    this.event_element.style.opacity = "0";
    $(this.event_element).animate({ marginLeft: 5, opacity: 1 }, 300);
  }
  
  this.clear_event = function()
  {
    this.event_element.innerHTML = "";
  }
}
