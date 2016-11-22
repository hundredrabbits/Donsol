
const HEART = 1;
const DIAMOND = 2;
const CLOVE = 3;
const SPADE = 4;

function Donsol()
{
  this.game = new Game();
  this.deck = new Deck();
  this.board = new Board();
  
  this.start = function()
  {
    this.deck.start();
    this.board.add_card(this.deck.draw_card());
    this.board.add_card(this.deck.draw_card());
    this.board.add_card(this.deck.draw_card());
    this.board.add_card(this.deck.draw_card());
  }
}
