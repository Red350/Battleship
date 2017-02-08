/* Hard and medium AIs extend this class.
 * While in seek mode it searches randomly based on a list of targets.
 * When a ship is hit, it enters hunt mode, loading adjacent cells into
 * vertical and horizontal lists.
 * These lists are targeted in turn, until the ship is sunk.
 * Each time a target in these lists is a successful hit, it 
 * adds the next target in that direction to the list.
 *
 * After a ship is sunk, it is possible that a second ship was
 * partially hit while sinking the first. The AI iterates over
 * the grid after sinking a ship to check for this.
 * If it finds a partially sunk ship, it remains in hunt mode,
 * and begins the algorithm again.
 * If not, it returns to seek mode.
 */

class HuntAI extends AI
{
  ArrayList<PVector> vertTargets;
  ArrayList<PVector> horizTargets;
  ArrayList<PVector> backupTargets;
  PVector pivot;  // Stores the most recent successful hit
  
  HuntAI()
  {
    super();
    vertTargets = new ArrayList<PVector>();
    horizTargets = new ArrayList<PVector>();
    backupTargets = new ArrayList<PVector>();
  }

  // Loads potential ship positions based on the current pivot 
  void loadHuntTargets(Grid g)
  {
    PVector temp;
    // Add the vertical cells as targets
    temp = new PVector(pivot.x-1,pivot.y);
    if(g.notHit(temp))
    {
      vertTargets.add(temp);
    }
    temp = new PVector(pivot.x+1,pivot.y);
    if(g.notHit(temp))
    {
      vertTargets.add(temp);
    }
    
    // Add horizontal cells as targets
    temp = new PVector(pivot.x,pivot.y-1);
    if(g.notHit(temp))
    {
      horizTargets.add(temp);
    }
    temp = new PVector(pivot.x,pivot.y+1);
    if(g.notHit(temp))
    {
      horizTargets.add(temp);
    }
    //println("Hit a pivot, targets as follows:");
    //println(vertTargets);
    //println(horizTargets);
    mode = Mode.HUNT;
  }
  
  void shoot(Grid g, Ship[] ships)
  {
    PVector temp;
    int result;
    //for(int j = 0; j < targets.size(); j++)
    //{
    //  print(j + " " + targets.get(j)+ ", ");
    //}
    
    if(mode == Mode.SEEK)
    {
      int i = (int)random(targets.size());
      //println("Index Generated: " + i);
      
      //println();
      //myGrid.printHitCells();
      pivot = targets.get(i);
      result =  g.AICheckHit(ships, pivot);
      updateInfo(result);
      //println("Ai just targeted " + pivot + "with a result of " + result);

      if(result == 1)
      {
        loadHuntTargets(g);
      }
      targets.remove(i);
    } else {
      //println("AI is hunting...");
      if(vertTargets.size() > 0)
      {
        //println("Vert Targets: " + vertTargets);
        PVector check = vertTargets.get(0);  // Shoot the first cell in the vertical array
        targets.remove(check);  // remove the cell being checked from the targets
        backupTargets.remove(check);
        //println("Ai has chosen: " + check);
        result = g.AICheckHit(ships, check);
        updateInfo(result);
        switch(result)
        {
          case 0:
            vertTargets.remove(0);
            break;
          case 1:
            //println("Success");
            // The target was successful. Add the
            // next target to the start of the list
            if(check.x > pivot.x)
            {
              temp = new PVector(check.x+1, check.y);
              vertTargets.remove(0);
              if(g.notHit(temp))
              {
                vertTargets.add(0,temp);
              }
            } else {
              temp = new PVector(check.x-1, check.y);
              vertTargets.remove(0);
              if(g.notHit(temp))
              {
                vertTargets.add(0,temp);
              }
            }
            break;
          case 2:
            // Ship dead, check for any unsunk ships that have been hit
            vertTargets.clear();
            horizTargets.clear();
            pivot = g.findUnSunk();
            if(pivot.x == -1)
            {
              //println("RETURNING TO SEEK");
              mode = Mode.SEEK;
            } else {
              //println("NEW TARGET ACQUIRED");
              loadHuntTargets(g);
            }
            break;
        }
      } else if(horizTargets.size() > 0) {
        //println("Horiz Targets: " + horizTargets);
        PVector check = horizTargets.get(0);  // Shoot the first cell in the horizontal array
        targets.remove(check);  // remove the cell being checked from the targets
        backupTargets.remove(check);
        //println("Ai has chosen: " + check);
        result = g.AICheckHit(ships, check);
        updateInfo(result);
        switch(result)
        {
          case 0: 
            horizTargets.remove(0);
            break;
          case 1:
            //println("Success");
            // The target was successful. Add the
            // next target to the start of the list
            if(check.y > pivot.y)
            {
              temp = new PVector(check.x, check.y+1);
              horizTargets.remove(0);
              if(g.notHit(temp))
              {
                horizTargets.add(0,temp);
              }
            } else {
              temp = new PVector(check.x, check.y-1);
              horizTargets.remove(0);
              if(g.notHit(temp))
              {
                horizTargets.add(0,temp);
              }
            }
            break;
          case 2:
            // Ship dead, check for any unsunk ships that have been hit
            vertTargets.clear();
            horizTargets.clear();
            pivot = g.findUnSunk();
            if(pivot.x == -1)
            {
              //println("RETURNING TO SEEK");
              mode = Mode.SEEK;
            } else {
              //println("NEW TARGET ACQUIRED: " + pivot);
              loadHuntTargets(g);
            }
            break;
        }
      } else {
        mode = Mode.SEEK;
        //println("I HAVE FAILED, RETURNING TO SEEK");
      }
    }
  }
  
}