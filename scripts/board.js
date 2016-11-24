function Board(element)
{
  this.element = element;
  this.room = [];
  this.slots = [];
  
  this.start = function()
  {
    var slot1 = document.createElement("div");
    slot1.setAttribute("class","slot");
    this.slots.push(slot1);
    this.element.appendChild(slot1);
    var slot2 = document.createElement("div");
    slot2.setAttribute("class","slot");
    this.slots.push(slot2);
    this.element.appendChild(slot2);
    var slot3 = document.createElement("div");
    slot3.setAttribute("class","slot");
    this.slots.push(slot3);
    this.element.appendChild(slot3);
    var slot4 = document.createElement("div");
    slot4.setAttribute("class","slot");
    this.slots.push(slot4);
    this.element.appendChild(slot4);
  }
  
  this.add_card = function(index,card)
  {
    this.slots[index].appendChild(card.install());
    this.room.push(card);
  }
}