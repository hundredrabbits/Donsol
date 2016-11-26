function Card(value,type)
{
  this.value = value;
  this.type  = type;
  this.element = null;
  this.is_flipped = false;
    
  this.install = function()
  {
    var e = document.createElement("card");
    e.setAttribute("class",this.type);
    
    // Face
    var face = document.createElement("div");
    face.setAttribute("class","face");
    e.appendChild(face);
    
    // Value
    var value = document.createElement("span");
    value.setAttribute("class","value");
    value.innerHTML = this.value;
    face.appendChild(value);
    
    // Badge
    var badge = document.createElement("span");
    badge.setAttribute("class","badge");
    badge.innerHTML = new Badge(this.value,this.type).install();
    face.appendChild(badge);
    
    // Icon
    face.appendChild(new Icon(this.type).install());
    
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
    var target_element = this.element;
  
    this.is_flipped = true;
    donsol.player.experience.value += 1;
    donsol.player.experience.update();
    
    $(target_element).animate({ opacity: 0.01, top: "-10" }, 100, function() {
      target_element.setAttribute("class","flipped");
    });
  }
  
}