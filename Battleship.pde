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

int cellSize = 50;
int edgeGap = 50;
int shipGap = 10;

int numPlaced = 0;
int delay;
String info = "";

// For these variables, 0 is the player, 1 is the computer
int winner;
int turn;

Ship selectedShip;
 
Grid myGrid;
Grid enemyGrid;

Ship[] myShips;
Ship[] enemyShips;

ArrayList<Button> buttons = new ArrayList<Button>();
ResetButton resetButton;
StartButton startButton;

EasyAI easy = new EasyAI();

void setup()
{
  size(1200, 800);
  frameRate(60);
  
  resetButton = new ResetButton("Reset", new PVector(900,700),100, 50, #FFFF00);
  startButton = new StartButton("Start", new PVector(900,625),100, 50, #FFFF00);
  buttons.add(resetButton);
  buttons.add(startButton);
  
  reset();
  
  state = State.PLAYING;
  //state = State.SETUP;
  textAlign(CENTER);
  textSize(20);
}

void draw()
{
  background(0);
  textAlign(LEFT);
  textSize(12);
  fill(255);
  text("State: " + state, 10, 20);
  switch(state)
  {
    case MENU:
      break;
    case OPTIONS:
      break;
    case SETUP:
      renderGame();
      for(Button b : buttons)
      {
        b.render();
      }
      break;
    case PLAYING:
      renderGame();
      resetButton.render();
      
      if(turn == 1)
      {
        if(delay == 0)
        {
          easy.seekShot();
          turn = 0;
          delay = 60;
        }
        delay--;
      }
      
      // Check if either player has won
      if(myGrid.shipsAlive == 0)
      {
        winner = 1;
        state = State.GAMEOVER;
      } else {
        if(enemyGrid.shipsAlive == 0)
        {
          winner = 0;
          state = State.GAMEOVER;
        }
      }
      break;
    case GAMEOVER:
      renderGame();
      resetButton.render();
      info = (winner == 0) ? "You win!" : "You lose!";
      break;
  }
  textAlign(CENTER, CENTER);
  textSize(20);
  fill(255);
  text(info,width/2,750);
}

void mouseClicked()
{
  switch(state)
  {
    case MENU:
      break;
    case OPTIONS:
      break;
    case PLAYING:
      resetButton.mouseClicked();
      // Check if the mouse is over the grid
      // If so check if it's a hit
      if(turn == 0 && enemyGrid.mouseOver())
      {
        int shotResult = enemyGrid.checkHit(enemyShips);
        switch(shotResult)
        {
          case 0:
            info = "Miss";
            turn = 1;
            break;
          case 1:
            info = "Hit";
            turn = 1;
            break;
          case 2:
            info = "Hit. Battleship sunk.";
            turn = 1;
            break;
          default:
            break;
        }
      }
      break;
    case SETUP:
      for(Button b : buttons)
      {
        b.mouseClicked();
      }
      if(mouseButton == LEFT)
      {
        if(selectedShip == null)
        {
          for(int i = 0; i < 5; i++)
          {
            myShips[i].mouseClicked();
          }
        } else {
          myGrid.mouseClicked();
        }
      }
      
      // Right click rotates a selected ship
      if(mouseButton == RIGHT)
      {
        if(selectedShip != null)
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

// method to call updated and render on all game objects
void renderGame()
{
  myGrid.render();
  enemyGrid.render();
  for(int i = 0; i < 5; i++)
  {
    myShips[i].update();
    myShips[i].render();
  }
  
}

void reset()
{
  myGrid = new Grid(50,50,500);
  enemyGrid = new Grid(650,50,500);
  
  myShips = new Ship[5];
  enemyShips = new Ship[5];
  
  myShips[0] = new Ship(100,600,5,0);
  myShips[1] = new Ship(100,650,4,1);
  myShips[2] = new Ship(100,700,3,2);
  myShips[3] = new Ship(600,600,3,3);
  myShips[4] = new Ship(600,650,2,4);
  
  enemyShips[0] = new Ship(5,0);
  enemyShips[1] = new Ship(4,1);
  enemyShips[2] = new Ship(3,2);
  enemyShips[3] = new Ship(3,3);
  enemyShips[4] = new Ship(2,4);
  
  // Place enemy ships
  enemyGrid.placeShip(enemyShips[0],0,0);
  enemyGrid.placeShip(enemyShips[1],1,1);
  enemyGrid.placeShip(enemyShips[2],2,2);
  enemyGrid.placeShip(enemyShips[3],3,3);
  enemyGrid.placeShip(enemyShips[4],4,4);
  
  info = "Please place your ships";
  numPlaced = 0;
  turn = 0;
  delay = 60;
}