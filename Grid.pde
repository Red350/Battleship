class Grid extends GameObject
{
  Cell[][] cells = new Cell[10][10];
  float size;
  Ship[] ships = new Ship[5];
  
  Grid(float x, float y, float size)
  {
    pos = new PVector(x, y);
    this.size = size;
    
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        cells[i][j] = new Cell(x + (size/10) * i, y + (size/10) * j, size/10);
      }
    }
  }
  
  void render()
  {
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        cells[i][j].render();
      }
    }
  }
  
  void mouseOver()
  {
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        cells[i][j].mouseOver();
      }
    }
  }
  
  void mouseClicked()
  {
    if(selectedShip != null)
    {
      for(int i = 0; i < 10; i++)
      {
        for(int j = 0; j < 10; j++)
        {
          if(cells[i][j].mouseOver())
          {
            // Here the mouse is over a cell with a ship selected
            // Must check now if the ship will fit at the location
            
            
            println("ship placed");
            println(i + " " + j);
            ship.pos.x = i*cellSize + edgeGap + shipGap;
            ship.pos.y = j*cellSize + edgeGap + shipGap;
            ship.selected = false;
            selectedShip = null;
          }
        }
      }
    }
  }
}