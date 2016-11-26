function Gage(name,limit)
{
  this.name = name;
  this.name_element = null;
  this.notification = null;
  this.limit = limit;
  this.value = limit;
  this.value_element = null;
  this.element = document.createElement("div");
  this.progress = new Radial_Progress();
  
  this.start = function()
  {
    this.install();
  }
  
  this.install = function()
  {
    this.element.setAttribute("class","gage");
    
    this.name_element = document.createElement("span");
    this.name_element.setAttribute("class","name");
    this.name_element.innerHTML = this.name;
    this.element.appendChild(this.name_element);
    
    this.notification = document.createElement("span");
    this.notification.setAttribute("class","notification");
    this.notification.innerHTML = "";
    this.name_element.appendChild(this.notification);
    
    this.value_element = document.createElement("span");
    this.value_element.setAttribute("class","value");
    this.value_element.innerHTML = this.value+"/"+this.limit;
    this.element.appendChild(this.value_element);
    
    this.element.appendChild(this.progress.install());
    
    return this.element
  }
  
  this.update = function(value)
  {
    this.value = value ? value : this.value;
    if(this.value > this.limit){this.value = this.limit;}
    if(this.value < 0){this.value = 0;}
    this.value_element.innerHTML = this.value+"/"+this.limit;
    this.progress.update(this.value,this.limit);
  }
  
  this.add_notification = function(message,color)
  {
    this.notification.innerHTML = message;
    this.notification.style.color = color;
    this.notification.style.opacity = 1;
    $(this.notification).delay(1500).animate({ opacity: 0 }, 200);
  }
}