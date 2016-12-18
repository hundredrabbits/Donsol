function Progress(radius = 15,color = "#ff0000")
{
  this.radius = radius;
  this.circumference = 2 * Math.PI * this.radius;
  this.color = color;
  
  this.wrapper = null;
  this.progress_bar = null;
  
  this.install = function()
  {
    this.wrapper = document.createElement("div");
    this.wrapper.setAttribute("class","progress");
    this.wrapper.style.borderColor = this.color;
    
    this.progress_bar = document.createElement("div");
    this.progress_bar.setAttribute("class","bar");
    this.progress_bar.style.backgroundColor = this.color;
    
    this.wrapper.appendChild(this.progress_bar);
    
    return this.wrapper;
  }
  
  this.update = function(value,limit = 0)
  {
    if(limit === 0){ value = 0; limit = 1;}
    var min = 0;
    var max = 130;
    
    var pixels = Math.floor(((value/limit) * max) + min);
    
    $(this.progress_bar).animate({ width: pixels }, 300);
  }
  
}