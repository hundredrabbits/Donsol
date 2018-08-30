"use strict";

function Walkthrough()
{
  this.is_running = false;
  this.speed = 500;

  this.start = function()
  {
    console.log("Started walkthrough")
    this.is_running = true;
  }

  this.run = function()
  {
    if(!this.is_running){ return; } // Idle
    if(donsol.player.health.value < 1){ this.is_running = false; return; }

    let target = this.rate_room(donsol.board.room)[0];
    console.log(target)
    donsol.board.room[target[[0]]].touch();
  }

  this.rate_room = function(room)
  {
    let a = []
    for(let id in room){
      let card = room[id];
      if(card.is_flipped){ continue; }
      a.push(this.rate_card(id,card));
    }
    return a.sort(function(a, b){
      return a[1] - b[1];
    }).reverse();
  }

  this.rate_card = function(id,card)
  {
    let rating = 0
    if(card.type == 'diamond'){
      rating = card.value - donsol.player.shield.value;
    }
    if(card.type == 'heart'){
      rating = (21 - donsol.player.health.value) - card.value;
    }
    if(card.type == 'clove' || card.type == 'spade'){
      rating = -card.value;
    }
    return [parseInt(id),rating]
  }

  setInterval(()=>{ donsol.walkthrough.run(); }, this.speed);
}

document.onkeyup = (e) =>
{
  if(e.ctrlKey && e.key.toLowerCase() == "k"){
    donsol.walkthrough.start();
  }
}