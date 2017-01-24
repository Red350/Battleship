class Grid extends GameObject
{
  Cell[][] cells = new Cell[10][10];
  Boolean[][] occupied = new Boolean[10][10];
  Boolean[][] hit = new Boolean[10][10];
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
        occupied[i][j] = false;
        hit[i][j] = false;
      }
    }
    //for(int i = 0; i < 10; i++)
    //{
    //  occupied[i] = new Boolean[10];
    //  hit[i] = new Boolean[10];
    //}
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
            Boolean validPos = true;
            if(selectedShip.orientation)
            {
              if(i + selectedShip.size > 10)
              {
                validPos = false;
              } else {
                for(int k = i; k < i + selectedShip.size; k++)
                {
                  if(occupied[k][j])
                  {
                    validPos = false;
                    break;
                  }
                }
              }
            } else {
              if(j + selectedShip.size > 10)
              {
                validPos = false;
              } else {
                for(int k = j; k < j + selectedShip.size; k++)
                {
                  if(occupied[i][k])
                  {
                    validPos = false;
                    break;
                  }
                }
              }
            }
            
            if(validPos)
            {
              println("ship placed");
              println(i + " " + j);
              // Informs the relevant cells as to where the ship was placed
              // and updates the local occupied array.
              if(selectedShip.orientation)
              {
                for(int k = i; k < i + selectedShip.size; k++)
                {
                  occupied[k][j] = true;
                  cells[k][j].occupied = true;
                }
              } else {
                for(int k = j; k < j + selectedShip.size; k++)
                {
                  occupied[i][k] = true;
                  cells[i][k].occupied = true;
                }
              }
              selectedShip.pos.x = i*cellSize + edgeGap + shipGap;
              selectedShip.pos.y = j*cellSize + edgeGap + shipGap;
              selectedShip.selected = false;
              selectedShip = null;
            }

          }
        }
      }
    }
  }
}