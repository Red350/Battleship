class Grid extends GameObject
{
  Cell[][] cells = new Cell[10][10];
  int[][] occupied = new int[10][10];
  boolean[][] hit = new boolean[10][10];
  float size;
  int shipsAlive;
  
  Grid(float x, float y, float size)
  {
    pos = new PVector(x, y);
    this.size = size;
    shipsAlive = 5;
    
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
            if(occupied[i][j] >= 0)  // If the cell was occupied
            {
              ships[occupied[i][j]].health--;  // Tell the ship it was hit
              if(ships[occupied[i][j]].health == 0)
              {
                shipsAlive--;
                return 2;
              }
              return 1;
            }
            return 0;
          } else {
            return -1;
          }
        }
      }
    }
    return -1;
  }
  
  // Attempt to place a ship at coordinates (i,j) in the grid
  boolean placeShip(Ship s, int i, int j)
  {
    // First check if the ship can fit at the position
    Boolean validPos = true;
    if(s.orientation)
    {
      if(i + s.size > 10)
      {
        validPos = false;
      } else {
        for(int k = i; k < i + s.size; k++)
        {
          if(occupied[k][j] >= 0)
          {
            validPos = false;
            break;
          }
        }
      }
    } else {
      if(j + s.size > 10)
      {
        validPos = false;
      } else {
        for(int k = j; k < j + s.size; k++)
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
      if(s.orientation)
      {
        for(int k = i; k < i + s.size; k++)
        {
          occupied[k][j] = s.id;
          cells[k][j].occupied = true;
        }
      } else {
        for(int k = j; k < j + s.size; k++)
        {
          occupied[i][k] = s.id;
          cells[i][k].occupied = true;
        }
      }
      return true;
    }
    return false;
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
            if(placeShip(selectedShip,i,j))
            {
              // Update the ship now that it's been placed
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
}