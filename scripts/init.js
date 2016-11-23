
var donsol = new Donsol();
donsol.board.element = document.getElementById('board');
donsol.player.element = document.getElementById('player');

var keyboard = new Keyboard();
document.onkeyup = function myFunction(){ keyboard.listen(event); };

donsol.start();