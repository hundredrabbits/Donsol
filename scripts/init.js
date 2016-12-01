
var donsol = new Donsol();
donsol.board.element = document.getElementById('board');
donsol.player.element = document.getElementById('player');
donsol.timeline.element = donsol.player.timeline_element;

var keyboard = new Keyboard();
document.onkeyup = function myFunction(){ keyboard.listen(event); };

donsol.start();