function Radial_Progress(radius = 15,color = "#ff0000")
{
  this.radius = radius;
  this.circumference = 2 * Math.PI * this.radius;
  this.color = color;
  this.c = null;
  
  this.install = function()
  {
    var e = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    e.setAttribute("class","progress");
    e.setAttribute("width","300px");
    e.setAttribute("height","300px");
    
    var s = document.createElementNS("http://www.w3.org/2000/svg", "circle");
    s.setAttribute("cx","15px");
    s.setAttribute("cy","15px");
    s.setAttribute("r",this.radius+"px");
    s.setAttribute("stroke-width","3px");
    s.setAttribute("stroke","#555");
    
    var c = document.createElementNS("http://www.w3.org/2000/svg", "circle");
    c.setAttribute("cx","15px");
    c.setAttribute("cy","15px");
    c.setAttribute("r",this.radius+"px");
    c.setAttribute("stroke-dasharray",this.circumference+"px");
    c.setAttribute("stroke-width","3px");
    c.setAttribute("stroke",this.color);
    
    this.c = c;
    
    e.appendChild(s);
    e.appendChild(c);
    
    return e
  }
  
  this.update = function(value,limit)
  {
    if(limit === 0){ value = 0; limit = 1;}
    this.c.setAttribute("stroke-dashoffset",(this.circumference * (1-(value/limit)))+"px");
    this.c.style.opacity = 0.01;
    $(this.c).animate({ opacity: 1 }, 200);
  }
  
}