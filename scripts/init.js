
var donsol = new Donsol();
donsol.board.element = document.getElementById('board');
donsol.player.element = document.getElementById('player');
donsol.timeline.element = donsol.player.timeline_element;

var keyboard = new Keyboard();
document.onkeyup = function myFunction(){ keyboard.listen(event); };

// Splash

var logo = new Logo(document.getElementById("logo"));

logo.install();

$("#logo").delay(5500).animate({ opacity: 0 }, 1000);
$("#splash").delay(7000).animate({ opacity: 0 }, 200);

setTimeout(function(){ $("#splash").remove(); donsol.start(); }, 7500);