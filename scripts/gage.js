function Radial_Progress()
{
  this.install = function()
  {
    var e = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    e.setAttribute("class","progress");
    e.setAttribute("width","300px");
    e.setAttribute("height","300px");
    
    var c = document.createElementNS("http://www.w3.org/2000/svg", "circle");
    c.setAttribute("cx","15px");
    c.setAttribute("cy","15px");
    c.setAttribute("r","15px");
    c.setAttribute("stroke-dasharray","600px");
    c.setAttribute("stroke-dashoffset","15px");
    c.setAttribute("stroke-width","3px");
    c.setAttribute("stroke","red");
    
    e.appendChild(c);
    
    return e
  }
  
  this.update = function(value,limit)
  {
    console.log("gage:"+value+"/"+limit);
  }
}

function Gage(name,limit)
{
  this.name = name;
  this.name_element = null;
  this.limit = limit;
  this.value = limit;
  this.value_element = null;
  this.element = null;
  this.progress = new Radial_Progress();
  
  this.start = function()
  {
    this.install();
  }
  
  this.install = function()
  {
    var e = document.createElement("div");
    e.setAttribute("class","gage");
    
    this.name_element = document.createElement("span");
    this.name_element.setAttribute("class","name");
    this.name_element.innerHTML = this.name;
    e.appendChild(this.name_element);
    
    this.value_element = document.createElement("span");
    this.value_element.setAttribute("class","value");
    this.value_element.innerHTML = this.value+"/"+this.limit;
    e.appendChild(this.value_element);
    
    e.appendChild(this.progress.install());
    
    return e
  }
  
  this.update = function(value)
  {
    this.value = value ? value : this.value;
    if(this.value > this.limit){this.value = this.limit;}
    if(this.value < 0){this.value = 0;}
    this.value_element.innerHTML = this.value+"/"+this.limit;
    this.progress.update(this.value,this.limit);
  }
}