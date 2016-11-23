function Board(element)
{
  this.element = element;
  this.room = [];
  
  this.add_card = function(card)
  {
    this.element.appendChild(card.install());
    this.room.push(card);
  }
}