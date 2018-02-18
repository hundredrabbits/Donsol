
const HEART   = "heart";
const DIAMOND = "diamond";
const CLOVE   = "clove";
const SPADE   = "spade";
const JOKER   = "joker";

function Donsol()
{
  this.theme = new Theme();
  this.deck = new Deck();
  this.board = new Board();
  this.player = new Player();
  this.timeline = new Timeline();
  this.controller = new Controller();
  this.speaker = new Speaker();
  
  this.is_complete = false;
  
  this.start = function()
  {
    donsol.board.element = document.getElementById('board');
    donsol.player.element = document.getElementById('player');
    donsol.timeline.element = donsol.player.timeline_element;
    
    this.theme.start();
    this.deck.start();
    this.player.install();
    this.player.start();

    this.controller.add("default","*","About",() => { require('electron').shell.openExternal('https://github.com/hundredrabbits/Donsol'); },"CmdOrCtrl+,");
    this.controller.add("default","*","Fullscreen",() => { app.toggle_fullscreen(); },"CmdOrCtrl+Enter");
    this.controller.add("default","*","Hide",() => { app.toggle_visible(); },"CmdOrCtrl+H");
    this.controller.add("default","*","Inspect",() => { app.inspect(); },"CmdOrCtrl+.");
    this.controller.add("default","*","Documentation",() => { donsol.controller.docs(); },"CmdOrCtrl+Esc");
    this.controller.add("default","*","Reset",() => { donsol.theme.reset(); },"CmdOrCtrl+Backspace");
    this.controller.add("default","*","Quit",() => { app.exit(); },"CmdOrCtrl+Q");

    this.controller.add("default","File","New",() => { donsol.new_game(); },"CmdOrCtrl+N");

    this.controller.add("default","Cards","Pick 1",() => { donsol.board.room[0].touch(); },"1");
    this.controller.add("default","Cards","Pick 2",() => { donsol.board.room[1].touch(); },"2");
    this.controller.add("default","Cards","Pick 3",() => { donsol.board.room[2].touch(); },"3");
    this.controller.add("default","Cards","Pick 4",() => { donsol.board.room[3].touch(); },"4");

    this.controller.add("default","Room","Escape",() => { donsol.skip(); },"Space");
    this.controller.add("default","Room","Restart",() => { donsol.new_game(); },"Esc");

    this.controller.commit();
    
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

  this.skip = function()
  {
    if(donsol.player.experience.value < 1){
      donsol.new_game();
    }
    else{
      donsol.player.escape_room();
    }
  }
}
