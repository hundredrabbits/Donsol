
const HEART   = 10;
const DIAMOND = 20;
const CLOVE   = 30;
const SPADE   = 40;

function Donsol()
{
  this.game = new Game();
  this.deck = new Deck();
  this.board = new Board();
  this.player = new Player();
  
  this.start = function()
  {
    this.deck.start();
    this.player.start();
    this.board.add_card(this.deck.draw_card());
    this.board.add_card(this.deck.draw_card());
    this.board.add_card(this.deck.draw_card());
    this.board.add_card(this.deck.draw_card());
  }
}
