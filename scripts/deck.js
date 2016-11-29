function Deck()
{
  this.cards = [
    new Card_Potion("A",14,HEART,"White Mage"),
    new Card_Potion("2",2,HEART,"Small Potion"),
    new Card_Potion("3",3,HEART,"Small Potion"),
    new Card_Potion("4",4,HEART,"Medium Potion"),
    new Card_Potion("5",5,HEART,"Medium Potion"),
    new Card_Potion("6",6,HEART,"Medium Potion"),
    new Card_Potion("7",7,HEART,"Medium Potion"),
    new Card_Potion("8",8,HEART,"Medium Potion"),
    new Card_Potion("9",9,HEART,"Large Potion"),
    new Card_Potion("10",10,HEART,"Large Potion"),
    new Card_Potion("V",11,HEART,"White Mage"),
    new Card_Potion("Q",11,HEART,"White Mage"),
    new Card_Potion("K",11,HEART,"White Mage"),
    new Card_Shield("A",11,DIAMOND,"Red Mage"),
    new Card_Shield("2",2,DIAMOND,"Buckler"),
    new Card_Shield("3",3,DIAMOND,"Buckler"),
    new Card_Shield("4",4,DIAMOND,"Shield"),
    new Card_Shield("5",5,DIAMOND,"Shield"),
    new Card_Shield("6",6,DIAMOND,"Shield"),
    new Card_Shield("7",7,DIAMOND,"Shield"),
    new Card_Shield("8",8,DIAMOND,"Shield"),
    new Card_Shield("9",9,DIAMOND,"Large Shield"),
    new Card_Shield("10",10,DIAMOND,"Large Shield"),
    new Card_Shield("V",11,DIAMOND,"Red Mage"),
    new Card_Shield("Q",11,DIAMOND,"Red Mage"),
    new Card_Shield("K",11,DIAMOND,"Red Mage"),
    new Card_Monster("A",17,CLOVE,"Fallen"),
    new Card_Monster("2",2,CLOVE,"Rat"),
    new Card_Monster("3",3,CLOVE,"Bat"),
    new Card_Monster("4",4,CLOVE,"Imp"),
    new Card_Monster("5",5,CLOVE,"Goblin"),
    new Card_Monster("6",6,CLOVE,"Orc"),
    new Card_Monster("7",7,CLOVE,"Ogre"),
    new Card_Monster("8",8,CLOVE,"Beholder"),
    new Card_Monster("9",9,CLOVE,"Medusa"),
    new Card_Monster("10",10,CLOVE,"Demon"),
    new Card_Monster("V",11,CLOVE,"Banshee"),
    new Card_Monster("Q",13,CLOVE,"Vampire Queen"),
    new Card_Monster("K",15,CLOVE,"Lich King"),
    new Card_Monster("A",17,SPADE,"Fallen"),
    new Card_Monster("2",2,SPADE,"Slime"),
    new Card_Monster("3",3,SPADE,"Tunneler"),
    new Card_Monster("4",4,SPADE,"Fiend"),
    new Card_Monster("5",5,SPADE,"Drake"),
    new Card_Monster("6",6,SPADE,"Specter"),
    new Card_Monster("7",7,SPADE,"Ghost Knight"),
    new Card_Monster("8",8,SPADE,"Elemental"),
    new Card_Monster("9",9,SPADE,"Witch"),
    new Card_Monster("10",10,SPADE,"Familiar"),
    new Card_Monster("V",11,SPADE,"Dragon Rider"),
    new Card_Monster("Q",13,SPADE,"Merfolk Queen"),
    new Card_Monster("K",15,SPADE,"Undead King"),
    new Card_Shield("J",21,JOKER,"Red Donsol"),
    new Card_Shield("J",21,JOKER,"Black Donsol"),
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
        i = Math.floor((Math.random() * 10) + 12); break;
      case CLOVE:
        i = Math.floor((Math.random() * 10) + 24); break;
      case SPADE:
        i = Math.floor((Math.random() * 10) + 36); break;
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