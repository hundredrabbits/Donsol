// Drool.

function Logo(target_element,is_looping)
{
  var is_looping = is_looping;
  this.element = target_element;
  this.container = document.createElement("div");

  this.width = parseInt(this.element.style.width, 10);
  this.height = parseInt(this.element.style.height, 10);

  function Pos(x,y)
  {
    this.x = x;
    this.y = y;
  }

  var tiles = [];

  this.create_tiles = function()
  {
    for (x = 0; x < 10; x++) { 
      for (y = 0; y < 10; y++) { 
        var rand_x = 15 - Math.floor((Math.random() * 20) + 1);
        var rand_y = 15 - Math.floor((Math.random() * 20) + 1);
        var pos = new Pos(x,y);
        tiles.push(new Tile(pos));  
      }
    }
  }

  this.install_tiles = function()
  {
    for (t = 0; t < tiles.length; t++) { 
      tiles[t].install();
    }
  }

  function scare_tiles(steps)
  {
    for (s = 0; s < steps; s++) { 
      for (t = 0; t < tiles.length; t++) { 
        tiles[t].flee();
      }
    }
  }

  function return_tiles_to(step)
  {
    for (i = 0; i < tiles.length; i++) { 
      tiles[i].move_to(tiles[i].history[step]);
      tiles[i].update();
    }
  }

  function animate_return_to(step,id)
  {
    if(id == -1){ return; }
    animate_tile(tiles[id],20);
    tiles[id].move_to(tiles[id].history[step]);
    setTimeout(function(){ animate_return_to(step,id-1); }, 10);
  }

  function animate_to(step,id)
  {
    if(id == 100){ return; }
    animate_tile(tiles[id],20);
    tiles[id].move_to(tiles[id].history[step]);
    setTimeout(function(){ animate_to(step,id+1); }, 10);
  }

  function animate_tile(tile,count)
  {
    if(count == 0){ return; }
    if(parseInt(tile.element.style.left,10) < (tile.pos.x * tile.tile_size)){ tile.translate_with(1,0); }
    if(parseInt(tile.element.style.left,10) > (tile.pos.x * tile.tile_size)){ tile.translate_with(-1,0); }
    if(parseInt(tile.element.style.top,10) < (tile.pos.y * tile.tile_size)){ tile.translate_with(0,1); }
    if(parseInt(tile.element.style.top,10) > (tile.pos.y * tile.tile_size)){ tile.translate_with(0,-1); }
    setTimeout(function(){ animate_tile(tile,count-1); }, 1);
  }

  this.install = function()
  {
    this.element.style.backgroundColor = "black";
    this.element.style.padding = (logo.width/2)+"px";
    this.container.style.width = logo.width+"px";
    this.container.style.height = logo.height+"px";
    this.container.style.position = "relative";
    this.element.appendChild(this.container);

    this.create_tiles();
    this.install_tiles();
    animate();
  }

  function animate()
  {
    scare_tiles(6);
    return_tiles_to(5);

    setTimeout(function(){ animate_return_to(4,99); }, 1500);
    setTimeout(function(){ animate_return_to(3,99); }, 2000);
    setTimeout(function(){ animate_return_to(2,99); }, 2500);
    setTimeout(function(){ animate_return_to(1,99); }, 3000);

    if(is_looping == true){
      setTimeout(function(){ scare_tiles(6); }, 6000);
      setTimeout(function(){ return_tiles_to(1); }, 6000);
      
      setTimeout(function(){ animate_to(2,0); }, 6500);
      setTimeout(function(){ animate_to(3,0); }, 7500);
      setTimeout(function(){ animate_to(4,0); }, 8000);
      setTimeout(function(){ animate_to(5,0); }, 8500);

      setTimeout(function(){ animate(); }, 11500);
    }
  }

  // Generate

  function Tile(pos)
  {
    this.pos = pos;
    this.element = null;
    this.tile_size = logo.width/10;
    this.history = [];
    this.history.push(new Pos(this.pos.x,this.pos.y));   

    this.install = function()
    {
      this.element = document.createElement("tile");
      this.element.style.backgroundColor = 'white';
      this.element.style.width = (logo.width * 0.08)+'px';
      this.element.style.height = (logo.width * 0.08)+'px';
      this.element.style.display = 'block';
      this.element.style.borderRadius = '10px';
      this.element.style.position = 'absolute';
      this.element.style.left = (this.pos.x * this.tile_size)+'px';
      this.element.style.top = (this.pos.y * this.tile_size)+'px';
      logo.container.appendChild(this.element);
    };

    function tile_at(target_pos,neighboors)
    {
      for (t2 = 0; t2 < neighboors.length; t2++) { 
        if(neighboors[t2].pos.x == target_pos.x && neighboors[t2].pos.y == target_pos.y){
          return neighboors[t2];
        }
      }
      return null;
    }

    this.move_to = function(target_pos)
    {
      this.pos.x = target_pos.x;
      this.pos.y = target_pos.y;
    }
    this.translate_with = function(x,y)
    {
      this.element.style.left = (parseInt(this.element.style.left, 10)+x)+'px';
      this.element.style.top = (parseInt(this.element.style.top, 10)+y)+'px';
    }

    this.update = function()
    {
      this.element.style.left = (pos.x * this.tile_size)+'px';
      this.element.style.top = (pos.y * this.tile_size)+'px';
    }

    this.neighboor_left = function()
    {
      return tile_at(new Pos(pos.x-1,pos.y),tiles);
    }
    this.neighboor_right = function()
    {
      return tile_at(new Pos(pos.x+1,pos.y),tiles);
    }
    this.neighboor_top = function()
    {
      return tile_at(new Pos(pos.x,pos.y+1),tiles);
    }
    this.neighboor_down = function()
    {
      return tile_at(new Pos(pos.x,pos.y-1),tiles);
    }

    this.flee = function()
    {
      var random = Math.random();

      this.history.push(new Pos(this.pos.x,this.pos.y));  

      if(random < 0.25 && !this.neighboor_top()){
        this.pos.y += 1; 
      }
      else if(random < 0.5 && !this.neighboor_down()){
        this.pos.y -= 1; 
      }
      else if(random < 0.75 && !this.neighboor_right()){
        this.pos.x += 1; 
      }
      else if(!this.neighboor_left()){
        this.pos.x -= 1; 
      }      
    }
  }
}
