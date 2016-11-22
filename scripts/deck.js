function Deck()
{
  this.cards = [
    new Card(1,HEART),
    new Card(2,DIAMOND),
    new Card(3,CLOVE),
    new Card(4,SPADE),
  ];
  
  var draw_pile = [];
  
  this.start = function()
  {
    draw_pile = shuffle(this.cards);
  }
  
  this.draw_card = function()
  {
    return draw_pile.splice(0,1)[0];
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