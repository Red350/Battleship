/* OOP Assignment 2: Battleship Game
 * Name: Pádraig Redmond 
 * Student number: C15755659
 */
 
public enum State {
  MENU, OPTIONS, SETUP, PLAYING
}

State state;

int cellSize = 50;
int edgeGap = 50;
int shipGap = 10;
int numPlaced = 0;

Ship selectedShip;
 
Grid myGrid = new Grid(50,50,500);
Grid enemyGrid = new Grid(650,50,500);

Ship[] myShips = new Ship[5];
Ship[] enemyShips = new Ship[5];

void setup()
{
  size(1200, 800);
  frameRate(60);
  
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
  enemyGrid.cells[0][0].occupied = true;
  enemyGrid.cells[0][1].occupied = true;
  enemyGrid.cells[0][2].occupied = true;
  enemyGrid.cells[0][3].occupied = true;
  enemyGrid.cells[0][4].occupied = true;
  
  enemyGrid.cells[1][0].occupied = true;
  enemyGrid.cells[2][0].occupied = true;
  enemyGrid.cells[3][0].occupied = true;
  enemyGrid.cells[4][0].occupied = true;
  
  enemyGrid.cells[4][3].occupied = true;
  enemyGrid.cells[4][4].occupied = true;
  enemyGrid.cells[4][5].occupied = true;
  
  enemyGrid.cells[5][2].occupied = true;
  enemyGrid.cells[5][3].occupied = true;
  enemyGrid.cells[5][4].occupied = true;
  
  enemyGrid.cells[7][6].occupied = true;
  enemyGrid.cells[8][6].occupied = true;
  
  
  state = State.PLAYING;
  //state = State.SETUP;
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
      text(enemyShips[0].health,100,600);
      break;
  }
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