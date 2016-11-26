function Timeline()
{
  this.element = null;
  
  this.add_event = function(message)
  {
    this.element.innerHTML = message;
    this.element.style.opacity = 0;
    $(this.element).animate({ opacity: 1 }, 200);
  }
}