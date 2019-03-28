// Donsol

#include <Arduboy2.h>

Arduboy2 arduboy;

#define GAME_TITLE  0
#define GAME_BOARD 1
#define GAME_END 2
#define MAXWIDTH 128
#define MAXHEIGHT 64

int gamestate = GAME_BOARD;

// Screens

void gameloop() {
  switch (gamestate) {
    case GAME_TITLE:
      _title();
      break;
    case GAME_BOARD:
      _board();
      break;
    case GAME_END:
      _end();
      break;
  }
}

void _title() {
  arduboy.setCursor(0, 0);
  arduboy.print("Title Screen\n");

  arduboy.setCursor(0, 8);
  arduboy.print("Donsol Arduino\n");

  arduboy.setCursor(0, 16);
  arduboy.print("Press A\n");

  if (arduboy.justPressed(A_BUTTON)) {
    gamestate = GAME_BOARD;
  }
}

void _board() {
  drawBoard();

  if (arduboy.pressed(A_BUTTON + B_BUTTON)) {
    resetGame();
    gamestate = GAME_TITLE;
  }
}

void _end() {
  arduboy.setCursor(0, 0);
  arduboy.print("Game End Screen\n");
  arduboy.setCursor(0, 8);
  arduboy.print("Press A + B Together\n");

  if (arduboy.pressed(A_BUTTON + B_BUTTON)) {
    resetGame();
    gamestate = GAME_TITLE;
  }
}

// Board Controls

void resetGame() {
}

// Draw

void drawBoard() {
  drawCards();
  drawInterface();
}

void drawCards() {

  int spacing = 3;
  int padding = MAXWIDTH / 16;
  int paddingTop = padding * 2;
  int cardWidth = (MAXWIDTH - (2 * padding) - (3 * spacing)) / 4;
  int cardHeight = MAXHEIGHT - (padding * 4);
  int cardPositions[4] = { padding , padding + cardWidth + spacing, padding + (cardWidth * 2) + (spacing * 2), padding + (cardWidth * 3) + (spacing * 3) };

  arduboy.drawRoundRect(cardPositions[0], paddingTop, cardWidth, cardHeight, 2);
  arduboy.drawRoundRect(cardPositions[1], paddingTop, cardWidth, cardHeight, 2);
  arduboy.drawRoundRect(cardPositions[2], paddingTop, cardWidth, cardHeight, 2);
  arduboy.drawRoundRect(cardPositions[3], paddingTop, cardWidth, cardHeight, 2);
}

void drawCard(int id) {

}

void drawInterface() {

  int padding = MAXWIDTH / 16;

  Serial.print("Hello");
  arduboy.setCursor(padding * 2, 2);
  arduboy.print("HP20"); // getCardName(13)

  arduboy.setCursor(50, 2);
  arduboy.print("SP09"); // getCardName(13)

  arduboy.print("\n");
}


// Deck

int getCardType(int id) {
  return floor(id / 13);
}

int getCardValue(int id) {
  return id % 13;
}

char getCardName(int id) {
  switch (id) {
    case 12: return 'K';
    case 11:  return 'Q';
    case 10:  return 'J';
    case 9:  return '10';
    case 8:  return '9';
    case 7:  return '8';
    case 6:  return '7';
    case 5:  return '6';
    case 4:  return '5';
    case 3:  return '4';
    case 2:  return '3';
    case 1:  return '2';
    case 0:  return 'A';
    default: return '?';
  }
  return id;
}

// Generics

void setup() {
  arduboy.begin();
  arduboy.setFrameRate(30);
  arduboy.display();
  arduboy.initRandomSeed();
  arduboy.clear();
  resetGame();
}

void loop() {
  if (!(arduboy.nextFrame())) {
    return;
  }

  arduboy.pollButtons();
  arduboy.clear();

  gameloop();

  arduboy.display();
}
