/* The grid stores some information that is also stored in the cell,
 * since I figured that it would be faster to check a locally stored array
 * then to iterate over the list of cells each time.
 */

class Grid extends GameObject
{
  Cell[][] cells = new Cell[10][10];
  int[][] occupied = new int[10][10];  // Stores the id of the ship, or -1 if not occupied
  boolean[][] hit = new boolean[10][10];
  float size;
  int shipsAlive;
  Cell lastHitCell;  // This is needed to clear the last hit cell's flag before setting the next.

  Grid(float x, float y, float size)
  {
    pos = new PVector(x, y);
    this.size = size;
    shipsAlive = 5;

    for (int i = 0; i < 10; i++)
    {
      for (int j = 0; j < 10; j++)
      {
        cells[i][j] = new Cell(x + (size/10) * j, y + (size/10) * i, size/10);
        occupied[i][j] = -1;
        //hit[i][j] = false;
      }
    }
    lastHitCell = cells[0][0];  // Initialise this to avoid having to null check it later
  }

  void render()
  {
    for (int i = 0; i < 10; i++)
    {
      for (int j = 0; j < 10; j++)
      {
        cells[i][j].render();
      }
    }
    
    strokeWeight(1);
    fill(#DDDDDD);
    for(int i = 0; i < 10; i++)
    {
      textSize(size/50);
      
      textAlign(CENTER, BOTTOM);
      text(i+1, pos.x + size/20 + i*size/10, pos.y - 5);
      
      textAlign(CENTER, CENTER);
      text((char)('A'+i), pos.x - 12, pos.y + size/20 + i*size/10);
    }
  }
  
  // Returns coordinates of a cell that's been hit
  // but does not contain a sunk ship.
  // Used by the huntAI to find a partially sunk ship that it 
  // hit while sinking a different ship.
  PVector findUnSunk()
  {
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        if(cells[i][j].hit && cells[i][j].occupied && !cells[i][j].sunk)
        {
          return new PVector(i,j);
        }
      }
    }
    return new PVector(-1,-1);
  }

  // Checks if a PVector coordinate is within the grid
  // and if it has not been hit.
  // Returns true if in bounds and not hit.
  // Used by the huntAI to determine if a cell should be added as
  // a target after it scores a hit.
  boolean notHit(PVector p)
  {
    // Bounds check
    if (p.x >= 0 && p.x < 10 && p.y >= 0 && p.y < 10)
    {
      if (!hit[(int)p.x][(int)p.y])
      {
        return true;
      }
    }
    return false;
  }

  boolean mouseOver()
  {
    return(mouseX > pos.x && mouseX < pos.x + size && mouseY > pos.y && mouseY < pos.y + size);
  }
  
  void checkHover()
  {
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        cells[i][j].updateHover();
      }
    }
  }
  
  // Highlight a cell being hovered while a ship is selected
  // Cell lights up green if it's a valid position,
  // red if it's invalid
  void checkSelectedShipHover()
  {
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        if(cells[i][j].mouseOver())
        {
          if(checkShipPlaceable(selectedShip, i, j))
          {
            cells[i][j].hovered = 1;
          } else {
            cells[i][j].hovered = 2;
          }
        } else {
          cells[i][j].hovered = 0;
        }
      }
    }
  }
  
  void clearHovered()
  {
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        cells[i][j].hovered = 0;
      }
    }
  }

  // Sets occupied cells to -1 if a ship is moved after being placed
  void remove(Ship s)
  {
    if (s.orientation)
    {
      for (int j = s.cellJ; j < s.cellJ + s.size; j++)
      {
        occupied[s.cellI][j] = -1;
        cells[s.cellI][j].occupied = false;
      }
    } else {
      for (int i = s.cellI; i < s.cellI + s.size; i++)
      {
        occupied[i][s.cellJ] = -1;
        cells[i][s.cellJ].occupied = false;
      }
    }
    numPlaced--;
  }
  
  // Tells the relevant cells that the ship they are holding has sunk
  void sinkShip(Ship s)
  {
    if (s.orientation)
    {
      for (int k = s.cellJ; k < s.cellJ + s.size; k++)
      {
        cells[s.cellI][k].sunk = true;
      }
    } else {
      for (int k = s.cellI; k < s.cellI + s.size; k++)
      {
        cells[k][s.cellJ].sunk = true;
      }
    }
  }

  // Unlike player's checkHit, ai specifies which cell it's targeting.
  // Returns -1 on square already shot, 0 on miss, 1 on hit, 2 on hit and kill
  int AICheckHit(Ship[] ships, PVector shot)
  {
    int x = (int)shot.x;
    int y = (int)shot.y;
    if (hit[x][y] == false)
    {
      hit[x][y] = true;
      cells[x][y].hit = true;
      lastHitCell.lastHit = false;
      lastHitCell = cells[x][y];
      lastHitCell.lastHit = true;
      if (occupied[x][y] >= 0)
      {
        Ship s = ships[occupied[x][y]];
        s.health--;
        if (s.health == 0)
        {
          sinkShip(s);
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

  // Called when the player clicks anywhere on the enemy grid.
  // Returns -1 on square already shot, 0 on miss, 1 on hit, 2 on hit and kill
  int checkHit(Ship[] ships)
  {
    // Iterate over hit array to ensure it hasn't already been hit.
    for (int i = 0; i < 10; i++)
    {
      for (int j = 0; j < 10; j++)
      {
        if (cells[i][j].mouseOver())
        {
          //println("You clicked cell: " + i + " " + j);
          // Found the cell that was clicked
          if (hit[i][j] == false)
          {
            hit[i][j] = true;  // Store the hit locally
            cells[i][j].hit = true;  // Tell the cell it was hit
            // This keeps track of last hit cell, to allow for a different coloured ma
            lastHitCell.lastHit = false;
            lastHitCell = cells[i][j];
            lastHitCell.lastHit = true;
            if (occupied[i][j] >= 0)  // If the cell was occupied
            {
              Ship s = ships[occupied[i][j]];
              s.health--;  // Tell the ship it was hit
              if (s.health == 0)
              {
                sinkShip(s);
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

  // Place ship at coordinates (i,j)
  void placeShip(Ship s, int i, int j)
  {
    // Informs the relevant cells as to where the ship was placed
    // and updates the local occupied array.
    if (s.orientation)
    {
      for (int k = j; k < j + s.size; k++)
      {
        occupied[i][k] = s.id;
        cells[i][k].occupied = true;
      }
    } else {
      for (int k = i; k < i + s.size; k++)
      {
        occupied[k][j] = s.id;
        cells[k][j].occupied = true;
      }
    }
    
    // Clears the cell from being hovered
    cells[i][j].hovered = 0;
    
    numPlaced++;
    if(this == myGrid && numPlaced == 5)
    {
      infoQueue.remove();
      infoQueue.add("PRESS START TO BEGIN");
    }
  }
  
  // Check if a ship can be placed at coordinates (i,j) in the grid
  boolean checkShipPlaceable(Ship s, int i, int j)
  {
    // First check if the ship can fit at the position
    Boolean validPos = true;
    if (s.orientation)
    {
      if (j + s.size > 10)
      {
        validPos = false;
      } else {
        for (int k = j; k < j + s.size; k++)
        {
          if (occupied[i][k] >= 0)
          {
            validPos = false;
            break;
          }
        }
      }
    } else {
      if (i + s.size > 10)
      {
        validPos = false;
      } else {
        for (int k = i; k < i + s.size; k++)
        {
          if (occupied[k][j] >= 0)
          {
            validPos = false;
            break;
          }
        }
      }
    }

    return validPos;
  }

  // If the grid is clicked with a ship selected,
  // attempt to place the ship
  void mouseClicked()
  {
    if (selectedShip != null)
    {
      for (int i = 0; i < 10; i++)
      {
        for (int j = 0; j < 10; j++)
        {
          if (cells[i][j].mouseOver())
          {
            if (checkShipPlaceable(selectedShip, i, j))
            {
              placeShip(selectedShip, i, j);
              selectedShip.lockToGrid(this, i, j);
              selectedShip = null;
            }
          }
        }
      }
    }
  }

  // Reset grid to empty
  void reset()
  {
    for (int i = 0; i < 10; i++)
    {
      for (int j = 0; j < 10; j++)
      {
        cells[i][j].occupied = false;
        occupied[i][j] = -1;
        hit[i][j] = false;
      }
    }
  }
  
  void printHitCells(){
    int count = 0;
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        if(cells[i][j].hit)
        {
          print("1 ");
          count++;
        } else {
          print("0 ");
        }
      }
      println();
    }
    println("Total hit cells: " + count);
  }
  
  void printOccupiedCells(){
    int count = 0;
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        if(occupied[i][j] >= 0)
        {
          print("1 ");
          count++;
        } else {
          print("0 ");
        }
      }
      println();
    }
    println("Total occupied cells: " + count);
    println();
  }
  
  void printSunkCells(){
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        if(cells[i][j].sunk == true)
        {
          print("1 ");
        } else {
          print("0 ");
        }
      }
      println();
    }
    println();
  }
}