function Deck()
{
  this.cards = [
    new Card_Potion(1,HEART),
    new Card_Potion(2,HEART),
    new Card_Potion(3,HEART),
    new Card_Potion(4,HEART),
    new Card_Potion(5,HEART),
    new Card_Potion(6,HEART),
    new Card_Shield(1,DIAMOND),
    new Card_Shield(2,DIAMOND),
    new Card_Shield(3,DIAMOND),
    new Card_Shield(4,DIAMOND),
    new Card_Shield(5,DIAMOND),
    new Card_Shield(6,DIAMOND),
    new Card_Monster(1,CLOVE),
    new Card_Monster(2,CLOVE),
    new Card_Monster(3,CLOVE),
    new Card_Monster(4,CLOVE),
    new Card_Monster(5,CLOVE),
    new Card_Monster(6,CLOVE),
    new Card_Monster(1,SPADE),
    new Card_Monster(2,SPADE),
    new Card_Monster(3,SPADE),
    new Card_Monster(4,SPADE),
    new Card_Monster(5,SPADE),
    new Card_Monster(6,SPADE),
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