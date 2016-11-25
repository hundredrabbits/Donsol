
const HEART   = "heart";
const DIAMOND = "diamond";
const CLOVE   = "clove";
const SPADE   = "spade";
const JOKER   = "joker";

function Donsol()
{
  this.deck = new Deck();
  this.board = new Board();
  this.player = new Player();
  
  this.start = function()
  {
    this.deck.start();
    this.player.start();
    this.board.start();
    
    this.board.enter_room();
  }
}
