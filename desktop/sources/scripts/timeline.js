function Timeline()
{
  this.el = document.createElement("div");
  this.el.id = "timeline"
    
  this.install = function(host)
  {
    host.appendChild(this.el)
  }

  this.add_event = function(message)
  {
    this.el.className = "";
    setTimeout(()=>{ this.el.className = "show"; this.el.innerHTML = message; },10)
  }
}