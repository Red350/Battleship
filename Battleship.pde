/* OOP Assignment 2: Battleship Game
 * Name: Pádraig Redmond 
 * Student number: C15755659
 */

import java.util.Arrays;
import java.util.LinkedList;

public enum State {
  MENU, CONTROLS, SETUP, PLAYING, GAMEOVER
}

private enum Mode
{
  SEEK, HUNT
}

// Setting this to true displays some debug info in the top left,
// enables keys to print debug info and removes any AI delays.
// Keys
// t: Print list of AI targets.
// z: Print player ship locations.
// x: Print ai ship locations.
// q: Skip your turn. Holding this down allows AI to solve board very quickly.
boolean debug = false;

State state;

float scaleValue;

float edgeGap;
float gridSize;

float buttonWidth;
float buttonHeight;

int numPlaced = 0;

int enemyDelayTimer;
// Set this to 0 to have the ai take its turn immediately
int enemyDelayInitial = 20;

int demoResetDelayTimer;
// Set this to 0 to have the demo reset immediately after completion
int demoResetDelayInitial = 60;
int demoTurnDelay = 10;

LinkedList<String> infoQueue;
String howToPlay = "";

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
RandomiseButton randomiseButton;
MainMenuButton mainMenuButton;

ArrayList<Button> menuButtons = new ArrayList<Button>();
PlayButton playButton;
HowToButton howToButton;
EasyButton easyButton;
MediumButton mediumButton;
HardButton hardButton;

MainMenuButton backButton;

AI ai;
AI demoAI;
int difficulty;

PFont titleFont, buttonFont, headingFont, howToFont, infoFont;

void setup()
{
  // The game should scale to any size as long as the dimensions are kept to a 3:2 ratio
  // e.g.
  size(1200,800);
  frameRate(60);
  
  scaleValue = (float)width/1200;
  
  edgeGap = 50*scaleValue;
  gridSize = width*5/12;
  buttonWidth = 100*scaleValue;
  buttonHeight = 50*scaleValue;

  startButton = new StartButton("START", new PVector(scaleValue*900, scaleValue*625), buttonWidth, buttonHeight, #FFFF00);
  resetButton = new ResetButton("RESET", new PVector(scaleValue*900, scaleValue*700), buttonWidth, buttonHeight, #FFFF00);
  randomiseButton = new RandomiseButton("RANDOMISE", new PVector(scaleValue*1025, scaleValue*625), buttonWidth, buttonHeight, #FFFF00);
  mainMenuButton = new MainMenuButton("MAIN MENU", new PVector(scaleValue*1025, scaleValue*700), buttonWidth, buttonHeight, #FFFF00);
  gameButtons.add(resetButton);
  gameButtons.add(startButton);
  gameButtons.add(randomiseButton);
  gameButtons.add(mainMenuButton);

  playButton = new PlayButton("PLAY", new PVector(width/2-scaleValue*150, scaleValue*500), buttonWidth, buttonHeight, #FFFF00);
  howToButton = new HowToButton("HOW TO PLAY", new PVector(width/2+scaleValue*50, scaleValue*500), buttonWidth, buttonHeight, #FFFF00);
  easyButton = new EasyButton("EASY", new PVector(width/2 - scaleValue*200, height/2+scaleValue*250), buttonWidth, buttonHeight, #FFFF00);
  mediumButton = new MediumButton("MEDIUM", new PVector(width/2-scaleValue*50, height/2+scaleValue*250), buttonWidth, buttonHeight, #FFFF00);
  hardButton = new HardButton("HARD", new PVector(width/2 + scaleValue*100, height/2+scaleValue*250), buttonWidth, buttonHeight, #FFFF00);
  menuButtons.add(playButton);
  menuButtons.add(howToButton);
  menuButtons.add(easyButton);
  menuButtons.add(mediumButton);
  menuButtons.add(hardButton);
  
  backButton  = new MainMenuButton("BACK", new PVector(width/2 - scaleValue*50, height-scaleValue*75), buttonWidth, buttonHeight, #FFFF00);
  
  infoQueue = new LinkedList<String>();
  
  loadHowToPlay();
  
  titleFont = createFont("Gameplay.ttf", 50*scaleValue);
  buttonFont = createFont("Pixeled.ttf", 9*scaleValue);
  infoFont = createFont("Pixeled.ttf", 14*scaleValue);
  headingFont = createFont("Pixeled.ttf", 20*scaleValue);
  howToFont = createFont("coolvetica rg.ttf", 25*scaleValue);

  difficulty = 2;
  
  if(debug)
  {
    enemyDelayInitial = 0;
    demoResetDelayInitial = 0;
  }

  reset();
  resetDemo();
  state = State.MENU;
}

void draw()
{
  background(0);
  if(debug)
  {
    displayDebugInfo();
  }
  
  switch(state)
  {
  case MENU:
    renderMenu();
    break;
  case CONTROLS:
    renderHowTo();
    break;
  case SETUP:
    renderGame();
    for (Button b : gameButtons)
    {
      b.render();
    }
    if(selectedShip != null)
    {
      myGrid.checkSelectedShipHover();
    }
    break;
  case PLAYING:
    renderGame();
    resetButton.render();
    
    enemyGrid.checkHover();

    if (turn == 1 && !turnLock)
    {
      turnLock = true;
      if (enemyDelayTimer <= 0)
      {
        ai.shoot(myGrid, myShips);
        turn = 0;
        enemyDelayTimer = enemyDelayInitial;
      }
      enemyDelayTimer--;
      turnLock = false;
    }

    // Check if either player has won
    if (myGrid.shipsAlive == 0)
    {
      winner = 1;
      state = State.GAMEOVER;
      enemyGrid.clearHovered();
      infoQueue.remove();
      infoQueue.add("YOU LOSE!");
    } else {
      if (enemyGrid.shipsAlive == 0)
      {
        winner = 0;
        state = State.GAMEOVER;
        enemyGrid.clearHovered();
        infoQueue.remove();
        infoQueue.add("YOU WIN!");
      }
    }
    break;
  case GAMEOVER:
    renderGame();
    renderEnemy();
    resetButton.render();
    mainMenuButton.render();
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
  case CONTROLS:
    backButton.mouseClicked();
    break;
  case PLAYING:
    {
      resetButton.mouseClicked();
      // Check if the mouse is over the grid
      // If so check if it's a hit
      if (turn == 0 && enemyGrid.mouseOver() && !turnLock)
      {
        turnLock = true;
        int shotResult = enemyGrid.checkHit(enemyShips);
        switch(shotResult)
        {
        case 0:
          infoQueue.remove();
          infoQueue.add("YOU MISSED, ENEMY TURN");
          turn = 1;
          break;
        case 1:
          infoQueue.remove();
          infoQueue.add("YOU HIT, ENEMY TURN");
          turn = 1;
          break;
        case 2:
          infoQueue.remove();
          infoQueue.add("YOU SUNK THEIR BATTLESHIP! ENEMY TURN");
          turn = 1;
          break;
        default:
          turn = 0; // Still your turn
          break;
        }
        turnLock = false;
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
  text("BATTLESHIP", width/2, scaleValue*50);
  textFont(buttonFont);
  textSize(16);
  text("Difficulty:", width/2, scaleValue*600);
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
    if (frameCount % demoTurnDelay == 0)
    {
      demoAI.shoot(demoGrid, demoShips);
    }
  } else {
    demoResetDelayTimer--;
    if (demoResetDelayTimer <= 0)
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
  textFont(headingFont);
  text("YOUR GRID", myGrid.pos.x+myGrid.size/2, 30*scaleValue);
  text("ENEMY GRID", enemyGrid.pos.x+enemyGrid.size/2, 30*scaleValue);
  
  // Print info
  textFont(infoFont);
  fill(20);
  text(infoQueue.get(0), width/2, height-scaleValue*100);
  fill(50);
  text(infoQueue.get(1), width/2, height-scaleValue*125);
  fill(255);
  text(infoQueue.get(2), width/2, height-scaleValue*150);
}

void renderHowTo()
{
  backButton.update();
  backButton.render();
  
  textAlign(CENTER, CENTER);
  textFont(howToFont);
  fill(255);
  text(howToPlay, width/2, height/2);
}

void renderEnemy()
{
  for (int i = 0; i < 5; i++)
  {
    enemyShips[i].render();
  }
}

void keyPressed()
{
  switch(state)
  {
  case MENU:
    // Speed up or slow down ai demo
    if (keyCode == UP)
    {
      if (demoTurnDelay != 1)
      {
        demoTurnDelay--;
      }
    } else if (keyCode == DOWN)
    {
      demoTurnDelay++;
    }
    break;
  case PLAYING:
    if(debug)
    {
      // Print ai's current list of targets
      if (key == 't')
      {
        ai.printTargets();
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
    }
  default:
    break;
  }
}

// Method called when then reset button is pushed
void reset()
{  
  myGrid = new Grid(edgeGap, edgeGap*2, gridSize);
  enemyGrid = new Grid(width/2+edgeGap, edgeGap*2, gridSize);

  myShips = new Ship[5];
  enemyShips = new Ship[5];

  myShips[0] = new Ship(50*scaleValue, 625*scaleValue, 5, 0, true, gridSize/10);
  myShips[1] = new Ship(50*scaleValue, 675*scaleValue, 4, 1, true, gridSize/10);
  myShips[2] = new Ship(50*scaleValue, 725*scaleValue, 3, 2, true, gridSize/10);
  myShips[3] = new Ship(200*scaleValue, 725*scaleValue, 3, 3, true, gridSize/10);
  myShips[4] = new Ship(250*scaleValue, 675*scaleValue, 2, 4, true, gridSize/10);

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
  
  infoQueue.clear();
  infoQueue.add("");
  infoQueue.add("");
  infoQueue.add("PLEASE PLACE YOUR SHIPS");

  numPlaced = 0;
  turn = 0;
  turnLock = false;
  enemyDelayTimer = enemyDelayInitial;
  state = State.SETUP;
}

// Resets the demo shown on the main menu
void resetDemo()
{
  float demoGridSize = width/4;
  demoGrid = new Grid(width/2-scaleValue*150, scaleValue*150, demoGridSize);
  demoAI = new HardAI();
  demoShips = new Ship[5];

  demoShips[0] = new Ship(5, 0, (random(1)<0.5)?true:false, demoGridSize/10);
  demoShips[1] = new Ship(4, 1, (random(1)<0.5)?true:false, demoGridSize/10);
  demoShips[2] = new Ship(3, 2, (random(1)<0.5)?true:false, demoGridSize/10);
  demoShips[3] = new Ship(3, 3, (random(1)<0.5)?true:false, demoGridSize/10);
  demoShips[4] = new Ship(2, 4, (random(1)<0.5)?true:false, demoGridSize/10);

  demoAI.randomiseShips(demoShips, demoGrid);

  demoResetDelayTimer = demoResetDelayInitial;
}

void loadHowToPlay()
{
  String[] temp = loadStrings("howtoplay.txt");
  if(temp != null)
  {
    for(String s : temp)
    {
      howToPlay += s;
      howToPlay += "\n";
    }
  } else {
    howToPlay = "Couldn't load \"How to Play\" file";
  }
}

void displayDebugInfo()
{
  textAlign(LEFT);
  textFont(howToFont);
  textSize(16);
  fill(255);
  text("Framerate: " + frameRate + "\nState: " + state + "\nDifficulty: " + difficulty + "\n(" + mouseX + ", " + mouseY + ")", 10, 20);
}