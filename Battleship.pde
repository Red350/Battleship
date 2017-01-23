/* OOP Assignment 2: Battleship Game
 * Name: Pádraig Redmond 
 * Student number: C15755659
 */
 
int cellSize = 50;
 
Grid myGrid = new Grid(50,50,500);
Grid enemyGrid = new Grid(650,50,500);

Ship ship = new Ship(100,600,5);

void setup()
{
  size(1200, 800);
  frameRate(60);
}

void draw()
{
  background(0);
  myGrid.render();
  enemyGrid.render();
  
  ship.update();
  ship.render();
}

void mouseClicked()
{
  ship.mouseClicked();
}