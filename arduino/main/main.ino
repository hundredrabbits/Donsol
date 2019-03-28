// Donsol

#include <Arduboy2.h>

Arduboy2 arduboy;

#define GAME_TITLE  0
#define GAME_BOARD 1
#define GAME_END 2
#define MAXWIDTH 128
#define MAXHEIGHT 64
#define SPACING 4
#define PADDING 8

// Template

int cardWidth = (MAXWIDTH - (2 * PADDING) - (3 * SPACING)) / 4;
int cardHeight = MAXHEIGHT - (PADDING * 3) - SPACING;

int gamestate = GAME_BOARD;
int selection = 0;

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
  testInput();

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

void testInput() {
  if (arduboy.justPressed(RIGHT_BUTTON)) {
    selection = selection < 3 ? selection+1 : selection;
  }
  if (arduboy.justPressed(LEFT_BUTTON)) {
    selection = selection > 0 ? selection-1 : selection;
  }
}

// Draw

void drawBoard() {
  drawCards();
  drawInterface();
  drawCursor();
}

void drawCards() {
  drawCard(0, 3);
  drawCard(1, 35);
  drawCard(2, 18);
  drawCard(3, 45);
}

void drawCard(int pos, int id) {

  int paddingTop = PADDING * 2;
  int x = PADDING + (cardWidth * pos) + (SPACING * pos);

  arduboy.drawRoundRect(x, paddingTop, cardWidth, cardHeight, 2);

  arduboy.setCursor(x + 10, paddingTop + (cardHeight / 4));
  arduboy.print(getCardName(id));

  arduboy.setCursor(x + 10, paddingTop + (cardHeight / 2) + 1);
  arduboy.print(".");
}

void drawInterface() {

  //  Serial.print("Hello");

  arduboy.setCursor(PADDING, 2);
  arduboy.print("HP20"); // getCardName(13)

  arduboy.setCursor(50, 2);
  arduboy.print("SP09"); // getCardName(13)

  arduboy.print("\n");
}

void drawCursor() {

  int paddingTop = PADDING * 2;
  int x = PADDING + (cardWidth * selection) + (SPACING * selection) + (cardWidth / 2);
  int y = cardHeight + (PADDING * 2.7);
  int w = 3;

  arduboy.drawLine(x, y, x + w, y + w);
  arduboy.drawLine(x, y, x - w, y + w);
}


// Deck

int getCardType(int id) {
  return floor(id / 13);
}

int getCardValue(int id) {
  return id % 13;
}

char getCardName(int id) {
  switch (id % 13) {
    case 12: return 'K';
    case 11:  return 'Q';
    case 10:  return 'J';
    case 9:  return 'X';
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
