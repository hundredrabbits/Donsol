function Gage(name,color)
{
  this.name = name;
  this.color = color;
  this.element = null;
  
  this.start = function()
  {
    this.install();
  }
  
  this.install = function()
  {
    var e = document.createElement("div");
    e.setAttribute("class","gage");
    
    e.innerHTML = "<span class='name'>"+this.name+"</span><span class='value'>20/20</span>";
    
    return e
  }
}