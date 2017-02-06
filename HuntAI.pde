class HuntAI extends AI
{
  ArrayList<PVector> vertTargets;
  ArrayList<PVector> horizTargets;
  PVector pivot;
  
  HuntAI()
  {
    super();
    vertTargets = new ArrayList<PVector>();
    horizTargets = new ArrayList<PVector>();
  }
  
  // Add the next node in line with the current hit
  // Must take into account an adjacent node might
  // be a successful hit on the same ship
  void addNextNode()
  {
    
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
    println("Hit a pivot, targets as follows:");
    println(vertTargets);
    println(horizTargets);
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
      println("Index Generated: " + i);
      
      println();
      //myGrid.printHitCells();
      pivot = targets.get(i);
      result =  g.AICheckHit(ships, pivot);
      println("Ai just targeted " + pivot + "with a result of " + result);

      if(result == 1)
      {
        loadHuntTargets(g);
      }
      targets.remove(i);
    } else {
      println("AI is hunting...");
      if(vertTargets.size() > 0)
      {
        println("Vert Targets: " + vertTargets);
        PVector check = vertTargets.get(0);  // Shoot the first cell in the vertical array
        targets.remove(check);  // remove the cell being checked from the targets
        println("Ai has chosen: " + check);
        result = g.AICheckHit(ships, check);
        switch(result)
        {
          case 0:
            vertTargets.remove(0);
            break;
          case 1:
            println("Success");
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
              println("RETURNING TO SEEK");
              mode = Mode.SEEK;
            } else {
              println("NEW TARGET ACQUIRED");
              loadHuntTargets(g);
            }
            break;
        }
      } else if(horizTargets.size() > 0) {
        println("Horiz Targets: " + horizTargets);
        PVector check = horizTargets.get(0);  // Shoot the first cell in the horizontal array
        targets.remove(check);  // remove the cell being checked from the targets
        println("Ai has chosen: " + check);
        result = g.AICheckHit(ships, check);
        switch(result)
        {
          case 0: 
            horizTargets.remove(0);
            break;
          case 1:
            println("Success");
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
              println("RETURNING TO SEEK");
              mode = Mode.SEEK;
            } else {
              println("NEW TARGET ACQUIRED: " + pivot);
              loadHuntTargets(g);
            }
            break;
        }
      } else {
        mode = Mode.SEEK;
        println("I HAVE FAILED, RETURNING TO SEEK");
      }
    }
  }
  
}