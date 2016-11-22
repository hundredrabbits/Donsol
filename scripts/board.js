function Board(element)
{
  this.element = element;
  
  this.add_card = function(card)
  {
    this.element.appendChild(card.install());
  }
}