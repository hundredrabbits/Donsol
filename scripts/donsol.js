
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
  this.timeline = new Timeline();
  
  this.is_complete = false;
  
  this.start = function()
  {
    this.deck.start();
    this.player.install();
    this.player.start();
    
    this.board.enter_room(true);
    donsol.deck.shuffle();
  }
  
  this.new_game = function()
  {
    this.deck = new Deck();
    this.deck.start();
    
    this.player.start();
    this.board.enter_room(true);
    donsol.deck.shuffle();
  }
}
