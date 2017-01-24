class Grid extends GameObject
{
  Cell[][] cells = new Cell[10][10];
  int[][] occupied = new int[10][10];
  boolean[][] hit = new boolean[10][10];
  float size;
  
  Grid(float x, float y, float size)
  {
    pos = new PVector(x, y);
    this.size = size;
    
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        cells[i][j] = new Cell(x + (size/10) * i, y + (size/10) * j, size/10);
        occupied[i][j] = -1;
        //hit[i][j] = false;
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
  
  boolean mouseOver()
  {
    return(mouseX > pos.x && mouseX < pos.x + size && mouseY > pos.y && mouseY < pos.y + size);
    //for(int i = 0; i < 10; i++)
    //{
    //  for(int j = 0; j < 10; j++)
    //  {
    //    cells[i][j].mouseOver();
    //  }
    //}
  }
  
  // Sets occupied cells to -1 if a ship is moved after being placed
  void remove(Ship s)
  {
    if(s.orientation)
    {
      for(int i = s.cellI; i < s.cellI + s.size; i++)
      {
        occupied[i][s.cellJ] = -1;
        cells[i][s.cellJ].occupied = false;
      }
    } else {
      for(int j = s.cellJ; j < s.cellJ + s.size; j++)
      {
        occupied[s.cellI][j] = -1;
        cells[s.cellI][j].occupied = false;
      }
    }
    numPlaced--;
  }
  
  // Returns -1 on square already shot, 0 on miss, 1 on hit, 2 on hit and kill
  int checkHit(Ship[] ships)
  {
    // Iterate over hit array to ensure it hasn't already been hit.
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        if(cells[i][j].mouseOver())
        {
          // Found the cell that was clicked
          if(hit[i][j] == false)
          {
            hit[i][j] = true;  // Store the hit locally
            cells[i][j].hit = true;  // Tell the cell it was hit
            println("occupied " + occupied[i][j]);
            if(occupied[i][j] >= 0)  // If the cell was occupied
            {
              println("hello");
              ships[occupied[i][j]].health--;  // Tell the ship it was hit
              if(ships[occupied[i][j]].health == 0)
              {
                return 2;
              }
            }
            return 1;
          } else {
            return -1;
          }
        }
      }
    }
    return 0;
  }
  
  // Attempt to place a ship at coordinates (i,j) in the grid
  void placeShip(int i, int j)
  {
    // First check if the ship can fit at the position
    Boolean validPos = true;
    if(selectedShip.orientation)
    {
      if(i + selectedShip.size > 10)
      {
        validPos = false;
      } else {
        for(int k = i; k < i + selectedShip.size; k++)
        {
          if(occupied[k][j] >= 0)
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
          if(occupied[i][k] >= 0)
          {
            validPos = false;
            break;
          }
        }
      }
    }
    
    // If the position if valid, place the ship
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
          occupied[k][j] = selectedShip.id;
          println(selectedShip.id);
          cells[k][j].occupied = true;
        }
      } else {
        for(int k = j; k < j + selectedShip.size; k++)
        {
          occupied[i][k] = selectedShip.id;
          cells[i][k].occupied = true;
        }
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
            placeShip(i,j);
            selectedShip.pos.x = i*cellSize + edgeGap + shipGap;
            selectedShip.pos.y = j*cellSize + edgeGap + shipGap;
            selectedShip.cellI = i;
            selectedShip.cellJ = j;
            selectedShip.placed = true;
            selectedShip.selected = false;
            selectedShip = null;
            numPlaced++;
          }
        }
      }
    }
  }
}