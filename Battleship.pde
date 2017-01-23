/* OOP Assignment 2: Battleship Game
 * Name: Pádraig Redmond 
 * Student number: C15755659
 */
 
Grid myGrid = new Grid(50,50,500);
Grid enemyGrid = new Grid(650,50,500);

void setup()
{
  size(1200, 600);
  frameRate(60);
}

void draw()
{
  background(0);
  myGrid.render();
  enemyGrid.render();
}