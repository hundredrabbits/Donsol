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
    c.setAttribute("stroke-dasharray","15px");
    c.setAttribute("stroke-dashoffset","15px");
    c.setAttribute("stroke-width","3px");
    c.setAttribute("stroke","red");
    
    e.appendChild(c);
    
    return e
  }
}

function Gage(name,limit)
{
  this.name = name;
  this.limit = limit;
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
    
    e.innerHTML = "<span class='name'>"+this.name+"</span><span class='value'>"+this.limit+"/"+this.limit+"</span>";
    
    e.appendChild(this.progress.install());
    
    return e
  }
}