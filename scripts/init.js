
var donsol = new Donsol();
donsol.board.element = document.getElementById('board');

var keyboard = new Keyboard();
document.onkeyup = function myFunction(){ keyboard.listen(event); };