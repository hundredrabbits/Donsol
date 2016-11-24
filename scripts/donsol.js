
const HEART   = "heart";
const DIAMOND = "diamond";
const CLOVE   = "clove";
const SPADE   = "spade";

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
    this.board.start();
    this.board.add_card(0,this.deck.draw_card());
    this.board.add_card(1,this.deck.draw_card());
    this.board.add_card(2,this.deck.draw_card());
    this.board.add_card(3,this.deck.draw_card());
  }
}
