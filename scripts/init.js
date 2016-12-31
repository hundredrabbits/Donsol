
var donsol = new Donsol();
donsol.board.element = document.getElementById('board');
donsol.player.element = document.getElementById('player');
donsol.timeline.element = donsol.player.timeline_element;

var keyboard = new Keyboard();
document.onkeyup = function myFunction(){ keyboard.listen(event); };

donsol.start();

// Resize

$(document).ready(function()
{
  scale();
});

$(window).resize(function()
{
  scale();
});

function scale()
{
  if( $( window ).width() < 900 ){
    $("html").addClass("mobile");
  }
  else{
    $("html").removeClass("mobile");
  }
}