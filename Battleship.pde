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

Ship selectedShip;
 
Grid myGrid = new Grid(50,50,500);
Grid enemyGrid = new Grid(650,50,500);

Ship[] myShips = new Ship[5];
Ship[] enemyShips = new Ship[5];
Ship ship = new Ship(100,600,5);
Ship ship2 = new Ship(100,650,4);

void setup()
{
  size(1200, 800);
  frameRate(60);
  
  myShips[0] = new Ship(100,600,5);
  myShips[1] = new Ship(100,650,4);
  myShips[2] = new Ship(100,700,3);
  myShips[3] = new Ship(600,600,3);
  myShips[4] = new Ship(600,650,2);
  
  enemyShips[0] = new Ship(5);
  enemyShips[1] = new Ship(4);
  enemyShips[2] = new Ship(3);
  enemyShips[3] = new Ship(3);
  enemyShips[4] = new Ship(2);
  
  state = State.SETUP;
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
      break;
    case PLAYING:
      renderGame();
      break;
  }
    
  
}

void mouseClicked()
{
  switch(state)
  {
    case MENU:
    case OPTIONS:
    case PLAYING:
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