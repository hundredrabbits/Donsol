function Deck()
{
  this.cards = [
    new Card_Potion(1,HEART),
    new Card_Potion(2,HEART),
    new Card_Potion(3,HEART),
    new Card_Potion(4,HEART),
    new Card_Potion(5,HEART),
    new Card_Potion(6,HEART),
    new Card_Potion(7,HEART),
    new Card_Potion(8,HEART),
    new Card_Potion(9,HEART),
    new Card_Potion(10,HEART),
    new Card_Potion(11,HEART),
    new Card_Potion(12,HEART),
    new Card_Potion(13,HEART),
    new Card_Potion(14,HEART),
    new Card_Shield(1,DIAMOND),
    new Card_Shield(2,DIAMOND),
    new Card_Shield(3,DIAMOND),
    new Card_Shield(4,DIAMOND),
    new Card_Shield(5,DIAMOND),
    new Card_Shield(6,DIAMOND),
    new Card_Shield(7,DIAMOND),
    new Card_Shield(8,DIAMOND),
    new Card_Shield(9,DIAMOND),
    new Card_Shield(10,DIAMOND),
    new Card_Shield(11,DIAMOND),
    new Card_Shield(12,DIAMOND),
    new Card_Shield(13,DIAMOND),
    new Card_Shield(14,DIAMOND),
    new Card_Monster(1,CLOVE),
    new Card_Monster(2,CLOVE),
    new Card_Monster(3,CLOVE),
    new Card_Monster(4,CLOVE),
    new Card_Monster(5,CLOVE),
    new Card_Monster(6,CLOVE),
    new Card_Monster(7,CLOVE),
    new Card_Monster(8,CLOVE),
    new Card_Monster(9,CLOVE),
    new Card_Monster(10,CLOVE),
    new Card_Monster(11,CLOVE),
    new Card_Monster(12,CLOVE),
    new Card_Monster(13,CLOVE),
    new Card_Monster(14,CLOVE),
    new Card_Monster(1,SPADE),
    new Card_Monster(2,SPADE),
    new Card_Monster(3,SPADE),
    new Card_Monster(4,SPADE),
    new Card_Monster(5,SPADE),
    new Card_Monster(6,SPADE),
    new Card_Monster(7,SPADE),
    new Card_Monster(8,SPADE),
    new Card_Monster(9,SPADE),
    new Card_Monster(10,SPADE),
    new Card_Monster(11,SPADE),
    new Card_Monster(12,SPADE),
    new Card_Monster(13,SPADE),
    new Card_Monster(14,SPADE),
    new Card_Shield(21,JOKER),
    new Card_Shield(21,JOKER),
  ];
  
  var draw_pile = [];
  
  this.start = function()
  {
    draw_pile = this.cards;
  }
  
  this.shuffle = function()
  {
    draw_pile = shuffle(this.cards);
  }
  
  this.draw_card = function(type)
  {
    var i = 0;
    switch(type) {
      case HEART:
        i = Math.floor((Math.random() * 10) + 0); break;
      case DIAMOND:
        i = Math.floor((Math.random() * 10) + 14); break;
      case CLOVE:
        i = Math.floor((Math.random() * 10) + 28); break;
      case SPADE:
        i = Math.floor((Math.random() * 10) + 42); break;
    }
    
    return draw_pile.splice(i,1)[0];
  }
  
  this.return_card = function(card)
  {
    draw_pile.push(card);
    draw_pile = shuffle(draw_pile);
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