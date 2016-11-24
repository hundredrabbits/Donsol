function Card(value,type)
{
  this.value = value;
  this.type  = type;
  this.element = null;
  this.is_flipped = false;
    
  this.install = function()
  {
    var e = document.createElement("card");
    
    // Face
    var face = document.createElement("div");
    face.setAttribute("class","face");
    e.appendChild(face);
    
    var face_frame = document.createElement("div");
    face_frame.setAttribute("class","frame");
    face.appendChild(face_frame);
    
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
    var icon = document.createElement("span");
    icon.setAttribute("class","icon");
    icon.innerHTML = new Icon(this.type).install();
    face.appendChild(icon);
    
    // Verso
    var verso = document.createElement("div");
    verso.setAttribute("class","verso");
    e.appendChild(verso);
    
    var verso_frame = document.createElement("div");
    verso_frame.setAttribute("class","frame");
    verso.appendChild(verso_frame);
    
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