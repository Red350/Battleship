/* OOP Assignment 2: Battleship Game
 * Name: Pádraig Redmond 
 * Student number: C15755659
 */
 
public enum State {
  MENU, OPTIONS, SETUP, PLAYING, GAMEOVER
}

State state;

int cellSize = 50;
int edgeGap = 50;
int shipGap = 10;
int numPlaced = 0;
String info = "";
int winner;

Ship selectedShip;
 
Grid myGrid = new Grid(50,50,500);
Grid enemyGrid = new Grid(650,50,500);

Ship[] myShips = new Ship[5];
Ship[] enemyShips = new Ship[5];

ArrayList<Button> buttons = new ArrayList<Button>();
ResetButton resetButton;

void setup()
{
  size(1200, 800);
  frameRate(60);
  
  resetButton = new ResetButton("Reset", new PVector(900,700),100, 50, #FFFF00);
  buttons.add(resetButton);
  
  // Set the starting positions for the ships
  reset();
  
  state = State.PLAYING;
  //state = State.SETUP;
  info = "test";
  textAlign(CENTER);
}

void draw()
{
  background(0);
  switch(state)
  {
    case MENU:
      break;
    case OPTIONS:
      break;
    case SETUP:
      renderGame();
      state = (numPlaced==5) ? State.PLAYING : State.SETUP;
      break;
    case PLAYING:
      renderGame();
      fill(255);
      
      // Check if either player has won
      if(myGrid.shipsAlive == 0)
      {
        winner = 0;
        state = State.GAMEOVER;
      } else {
        if(enemyGrid.shipsAlive == 0)
        {
          winner = 1;
          state = State.GAMEOVER;
        }
      }
      break;
    case GAMEOVER:
      renderGame();
      info = (winner == 1) ? "You win!" : "You lose!";
      break;
  }
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
      // Check if the mouse is over the grid
      // If so check if it's a hit
      if(enemyGrid.mouseOver())
      {
        println("Outcome of shot: " + enemyGrid.checkHit(enemyShips));
      }
      break;
    case SETUP:
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
  for(Button b : buttons)
  {
    b.update();
    b.render();
  }
}

void reset()
{
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
}