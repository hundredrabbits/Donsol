function Card(value)
{
  this.value = value;
  
  this.install = function()
  {
    var e = document.createElement("card");
    
    var value = document.createElement("span");
    value.class = "value";
    value.innerHTML = this.value;
    
    e.appendChild(value);
    return e;
  }
}