function Deck()
{
  this.cards = [];
  this.draw_pile = [];
  
  this.start = function()
  {
    this.draw_pile = shuffle(this.cards);
  }
  
  this.draw_card = function()
  {
    return this.draw_pile.splice();
  }
  
  function shuffle(array) {
    for (var i = array.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    return array;
  }
}