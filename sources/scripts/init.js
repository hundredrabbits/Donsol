
var donsol = new Donsol();
donsol.board.element = document.getElementById('board');
donsol.player.element = document.getElementById('player');
donsol.timeline.element = donsol.player.timeline_element;

var keyboard = new Keyboard();
document.onkeyup = function myFunction(event){ keyboard.listen(event); };

// Splash

var logo = new Logo(false);

logo.install(document.getElementById("logo"),120);

$("#logo").delay(5500).animate({ opacity: 0 }, 1000);
$("#splash").delay(7000).animate({ opacity: 0 }, 200);

// setTimeout(function(){ $("#splash").remove(); donsol.start(); }, 5500);
setTimeout(function(){ $("#splash").remove(); donsol.start(); }, 100);

window.addEventListener('dragover',function(e)
{
  e.stopPropagation();
  e.preventDefault();
  e.dataTransfer.dropEffect = 'copy';
});

window.addEventListener('drop', function(e)
{
  e.stopPropagation();
  e.preventDefault();

  var files = e.dataTransfer.files;
  var file = files[0];

  if (file.type && !file.type.match(/text.*/)) { console.log("Not text", file.type); return false; }

  var path = file.path ? file.path : file.name;

  // Load Theme
  if(path.substr(-3,3) == "thm"){
    console.log("Found theme..")
    var reader = new FileReader();
    reader.onload = function(e){
      console.log("Loading theme..")
      donsol.theme.load(e.target.result);
      return;
    };
    reader.readAsText(file);
  }
});