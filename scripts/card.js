function Card(value,type)
{
  this.value = value;
  this.type  = type;
  this.element = null;
  this.is_flipped = false;
    
  this.install = function()
  {
    var e = document.createElement("card");
    
    // Value
    var value = document.createElement("span");
    value.setAttribute("class","value");
    value.innerHTML = this.value;
    e.appendChild(value);
    
    // Badge
    var badge = document.createElement("span");
    badge.setAttribute("class","badge");
    badge.innerHTML = new Badge(this.value,this.type).install();
    e.appendChild(badge);
    
    // Icon
    var icon = document.createElement("span");
    icon.setAttribute("class","icon");
    icon.innerHTML = new Icon(this.type).install();
    e.appendChild(icon);
    
    addClickHandler(e,this,this.value);
    
    this.element = e;
    
    return e;
  }
  
  function addClickHandler(elem, object)
  {
    elem.addEventListener('click', function(e) { object.touch(); }, false);
  }
  
  this.touch = function()
  {
    console.log("??")
  }
  
  this.flip = function()
  {
    this.is_flipped = true;
    this.element.setAttribute("class","flipped");
  }
}