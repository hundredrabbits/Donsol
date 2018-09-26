"use strict";

const blessed  = require('blessed');

function Terminal()
{
  this._screen = blessed.screen();
  this._body = blessed.box({ top: 1, left: 1, height: '100%-4', width: 54, keys: true, mouse: true });
  this._run = blessed.box({ top: 5, left: 0, height: 1, width: 6, keys: true, mouse: true });
  this._hp = blessed.box({ top: 5, left: 7, height: 1, width: 6, keys: true, mouse: true });
  this._sp = blessed.box({ top: 5, left: 14, height: 1, width: 6, keys: true, mouse: true });
  this._xp = blessed.box({ top: 5, left: 21, height: 1, width: 5, keys: true, mouse: true });

  this.card1 = new CardUI(0);
  this.card2 = new CardUI(1);
  this.card3 = new CardUI(2);
  this.card4 = new CardUI(3);

  this.install = function()
  {
    this._screen.append(this._body);

    this._body.append(this._run);
    this._body.append(this._hp);
    this._body.append(this._sp);
    this._body.append(this._xp);

    this._body.append(this.card1._el);
    this._body.append(this.card2._el);
    this._body.append(this.card3._el);
    this._body.append(this.card4._el);
  }

  this.start = function()
  {
    this._screen.key(['escape', 'q', 'C-c'], (ch, key) => (process.exit(0)));
    this._screen.on('keypress', (text)=>{ this.on_keypress(text) });
    this.update();
  }

  this.update = function()
  {
    this._run.setContent("RUN")
    this._hp.setContent("HP  9")
    this._sp.setContent("SP 11")
    this._xp.setContent("XP 12")
    this.card1.update('♠︎','9');
    this.card2.update('♥︎','A');
    this.card3.update('♣︎','K');
    this.card4.update('♦︎','J');

    this._screen.render();
  }

  this.on_keypress = function(text = "")
  {
    this._screen.render();
  }

  function CardUI(id)
  {
    this._el = blessed.box({ top: 0, left: id * 7, height: 4, width: 5, keys: true, mouse: true, style:{fg:'#f00',bg:'#fcfcfc'} });
    this._glyph = blessed.box({ top: 1, left: 2, height: 1, width: 1, keys: true, mouse: true, style:{fg:'#000',bg:'#fcfcfc'} });
    this._value = blessed.box({ top: 2, left: 2, height: 1, width: 1, keys: true, mouse: true, style:{fg:'#000',bg:'#fcfcfc'} });

    this._glyph.setContent("*")
    this._value.setContent("3")

    this._el.append(this._glyph);
    this._el.append(this._value);

    this.update = function(glyph,value)
    {
      this._glyph.style.fg = glyph == "♦︎" || glyph == "♥︎" ? '#f00' : '#000'
      this._value.style.fg = glyph == "♦︎" || glyph == "♥︎" ? '#f00' : '#000'
      this._glyph.setContent(glyph)
      this._value.setContent(value)
    }
  }
}

module.exports = Terminal