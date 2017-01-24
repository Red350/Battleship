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

Ship ship = new Ship(100,600,5);
Ship ship2 = new Ship(100,650,4);

void setup()
{
  size(1200, 800);
  frameRate(60);
  
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
          ship.mouseClicked();
          ship2.mouseClicked();
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
  ship.update();
  ship.render();
  ship2.update();
  ship2.render();
}