/* OOP Assignment 2: Battleship Game
 * Name: Pádraig Redmond 
 * Student number: C15755659
 */

public enum State {
  MENU, OPTIONS, SETUP, PLAYING, GAMEOVER
}

private enum Mode
{
  SEEK, HUNT
}

State state;

int edgeGap = 50;

int numPlaced = 0;
int delay;
final int delayAmount = 0;
String info = "";

int demoResetTimer;
int demoDelay = 10;

// For these variables, 0 is the player, 1 is the computer
int winner;
int turn;
boolean turnLock;

Ship selectedShip;

Grid myGrid;  
Grid enemyGrid;
Grid demoGrid;

Ship[] myShips;
Ship[] enemyShips;
Ship[] demoShips;

ArrayList<Button> gameButtons = new ArrayList<Button>();
ResetButton resetButton;
StartButton startButton;
AutoPlaceButton autoPlaceButton;
MainMenuButton mainMenuButton;

ArrayList<Button> menuButtons = new ArrayList<Button>();
PlayButton playButton;
EasyButton easyButton;
MediumButton mediumButton;
HardButton hardButton;

AI ai;
AI demoAI;
int difficulty;

PFont titleFont, textFont;
int defaultTextSize = 10;

void setup()
{
  size(1200, 800);
  frameRate(60);

  startButton = new StartButton("Start", new PVector(900, 625), 100, 50, #FFFF00);
  resetButton = new ResetButton("Reset", new PVector(900, 700), 100, 50, #FFFF00);
  autoPlaceButton = new AutoPlaceButton("Randomise", new PVector(1025, 625), 100, 50, #FFFF00);
  mainMenuButton = new MainMenuButton("Main Menu", new PVector(1025, 700), 100, 50, #FFFF00);
  gameButtons.add(resetButton);
  gameButtons.add(startButton);
  gameButtons.add(autoPlaceButton);
  gameButtons.add(mainMenuButton);

  playButton = new PlayButton("Play", new PVector(width/2-50, 475), 100, 50, #FFFF00);
  easyButton = new EasyButton("Easy", new PVector(width/2 - 200, height/2+200), 100, 50, #FFFF00);
  mediumButton = new MediumButton("Medium", new PVector(width/2-50, height/2+200), 100, 50, #FFFF00);
  hardButton = new HardButton("Hard", new PVector(width/2 + 100, height/2+200), 100, 50, #FFFF00);
  menuButtons.add(playButton);
  menuButtons.add(easyButton);
  menuButtons.add(mediumButton);
  menuButtons.add(hardButton);
  
  titleFont = createFont("game_over.ttf", 200);
  textFont = createFont("Pixeled.ttf", defaultTextSize);

  difficulty = 0;

  resetDemo();
  state = State.MENU;
}

void draw()
{
  background(0);
  textAlign(LEFT);
  fill(255);
  text("State: " + state + "\nDifficulty: " + difficulty + "\n(" + mouseX + ", " + mouseY + ")", 10, 20);
  switch(state)
  {
  case MENU:
    renderMenu();
    break;
  case OPTIONS:
    break;
  case SETUP:
    renderGame();
    for (Button b : gameButtons)
    {
      b.render();
    }
    break;
  case PLAYING:
    renderGame();
    resetButton.render();
    
    enemyGrid.checkHover();

    if (turn == 1 && !turnLock)
    {
      turnLock = true;
      if (delay <= 0)
      {
        //println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        //println("Start AI turn");
        //println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        ai.shoot(myGrid, myShips);
        turn = 0;
        delay = delayAmount;
        //println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        //println("End AI turn");
        //println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
      }
      delay--;
      turnLock = false;
    }

    // Check if either player has won
    if (myGrid.shipsAlive == 0)
    {
      winner = 1;
      state = State.GAMEOVER;
    } else {
      if (enemyGrid.shipsAlive == 0)
      {
        winner = 0;
        state = State.GAMEOVER;
      }
    }
    break;
  case GAMEOVER:
    renderGame();
    renderEnemy();
    resetButton.render();
    info = (winner == 0) ? "You win!" : "You lose!";
    break;
  }
}

void mouseClicked()
{
  switch(state)
  {
  case MENU:
    for (Button b : menuButtons)
    {
      b.mouseClicked();
    }
    break;
  case OPTIONS:
    break;
  case PLAYING:
    {
      resetButton.mouseClicked();
      // Check if the mouse is over the grid
      // If so check if it's a hit
      if (turn == 0 && enemyGrid.mouseOver() && !turnLock)
      {
        turnLock = true;
        //println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        //println("Start Player turn");
        //println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        int shotResult = enemyGrid.checkHit(enemyShips);
        switch(shotResult)
        {
        case 0:
          info = "You missed. Enemy's turn.";
          turn = 1;
          break;
        case 1:
          info = "You hit. Enemy's turn.";
          turn = 1;
          break;
        case 2:
          info = "You sunk their battleship! Enemy's turn.";
          turn = 1;
          break;
        default:
          turn = 0; // Still your turn
          break;
        }
        turnLock = false;
        //println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        //println("End Player turn");
        //println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
      }
      break;
    }
  case SETUP:
    for (Button b : gameButtons)
    {
      b.mouseClicked();
    }
    if (mouseButton == LEFT)
    {
      if (selectedShip == null)
      {
        for (int i = 0; i < 5; i++)
        {
          myShips[i].mouseClicked();
        }
      } else {
        myGrid.mouseClicked();
      }
    }

    // Right click rotates a selected ship
    if (mouseButton == RIGHT)
    {
      if (selectedShip != null)
      {
        selectedShip.keyPressed();
      }
    }
    break;
  case GAMEOVER:
    resetButton.mouseClicked();
    break;
  }
}

void renderMenu()
{
  textAlign(CENTER, CENTER);
  textFont(titleFont);
  text("BATTLESHIP", width/2, 50);
  textFont(textFont);
  text("Difficulty:", width/2, 575);
  for (Button b : menuButtons)
  {
    b.update();
    b.render();
  }

  // Draw the demo grid and ships
  demoGrid.render();
  for (Ship s : demoShips)
  {
    s.render();
  }

  // Have the ai play out the board
  if (demoGrid.shipsAlive != 0)
  {
    if (frameCount % demoDelay == 0)
    {
      demoAI.shoot(demoGrid, demoShips);
    }
  } else {
    demoResetTimer++;
    if (demoResetTimer > 0)
    {
      resetDemo();
    }
  }
}

void renderGame()
{
  
  myGrid.render();
  enemyGrid.render();
  for (int i = 0; i < 5; i++)
  {
    myShips[i].update();
    myShips[i].render();
  }
  
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(20);
  text("Your board", myGrid.pos.x+myGrid.size/2, 30);
  text("Enemy board", enemyGrid.pos.x+enemyGrid.size/2, 30);
  textSize(defaultTextSize);
  //text("Enemy board");
  text(info, width/2, 750);
}

void renderEnemy()
{
  for (int i = 0; i < 5; i++)
  {
    enemyShips[i].render();
  }
}

// Print some debug info
void keyPressed()
{
  switch(state)
  {
  case MENU:
    if (keyCode == UP)
    {
      if (demoDelay != 1)
      {
        demoDelay--;
      }
    } else if (keyCode == DOWN)
    {
      demoDelay++;
    }
    break;
  case PLAYING:
    // Print ai's current list of targets
    if (key == 't')
    {
      println(ai.targets);
    }

    // Print player ship locations
    if (key == 'z')
    {
      myGrid.printOccupiedCells();
    }

    // Print ai ship locations
    if (key == 'x')
    {
      myGrid.printOccupiedCells();
    }

    // Skip turn
    if (key == 'q')
    {
      turn = 1;
    }
    break;
  default:
    break;
  }
}

// Randomly place players ships
void randomiseShips(Ship[] s, Grid g)
{
  int x, y;

  numPlaced = 0;
  for (int i = 0; i < 5; i++)
  {
    s[i].orientation = (random(1)<0.5)?true:false;
    x = (int)random(10);
    y = (int)random(10);
    while (!g.placeShip(s[i], x, y))
    {
      x = (int)random(10);
      y = (int)random(10);
    }
    s[i].lockToGrid(g, x, y);
  }
}

void reset()
{
  myGrid = new Grid(50, 100, 500);
  enemyGrid = new Grid(650, 100, 500);

  myShips = new Ship[5];
  enemyShips = new Ship[5];

  myShips[0] = new Ship(100, 600, 5, 0, true, 500/10);
  myShips[1] = new Ship(100, 650, 4, 1, true, 500/10);
  myShips[2] = new Ship(100, 700, 3, 2, true, 500/10);
  myShips[3] = new Ship(375, 600, 3, 3, true, 500/10);
  myShips[4] = new Ship(375, 650, 2, 4, true, 500/10);

  enemyShips[0] = new Ship(5, 0, (random(1)<0.5)?true:false, 500/10);
  enemyShips[1] = new Ship(4, 1, (random(1)<0.5)?true:false, 500/10);
  enemyShips[2] = new Ship(3, 2, (random(1)<0.5)?true:false, 500/10);
  enemyShips[3] = new Ship(3, 3, (random(1)<0.5)?true:false, 500/10);
  enemyShips[4] = new Ship(2, 4, (random(1)<0.5)?true:false, 500/10);

  switch(difficulty)
  {
  case 0:
    ai = new EasyAI();
    break;
  case 1:
    ai = new MediumAI();
    break;
  case 2:
    ai = new HardAI();
    break;
  }
  ai.randomiseShips(enemyShips, enemyGrid);

  info = "Please place your ships";
  numPlaced = 0;
  turn = 0;
  turnLock = false;
  delay = delayAmount;
  state = State.SETUP;
}

void resetDemo()
{
  float demoGridSize = 300;
  demoGrid = new Grid(width/2-150, 150, demoGridSize);
  demoAI = new HardAI();
  demoShips = new Ship[5];

  demoShips[0] = new Ship(5, 0, (random(1)<0.5)?true:false, demoGridSize/10);
  demoShips[1] = new Ship(4, 1, (random(1)<0.5)?true:false, demoGridSize/10);
  demoShips[2] = new Ship(3, 2, (random(1)<0.5)?true:false, demoGridSize/10);
  demoShips[3] = new Ship(3, 3, (random(1)<0.5)?true:false, demoGridSize/10);
  demoShips[4] = new Ship(2, 4, (random(1)<0.5)?true:false, demoGridSize/10);

  demoAI.randomiseShips(demoShips, demoGrid);

  demoResetTimer = 0;
}