class MediumAI extends AI
{
  ArrayList<PVector> vertTargets;
  ArrayList<PVector> horizTargets;
  PVector pivot;
  
  MediumAI()
  {
    super();
    targets = new ArrayList<PVector>();
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        targets.add(new PVector(i,j));
      }
    }
    vertTargets = new ArrayList<PVector>();
    horizTargets = new ArrayList<PVector>();
  }
  
  void shoot()
  {
    PVector temp;
    int result;
    
    if(mode == Mode.SEEK)
    {
      int i = (int)random(targets.size());
      pivot = targets.get(i);
      result =  myGrid.AICheckHit(myShips, pivot);
      println("Ai just targeted " + pivot);
      
      if(result == 1)
      {
        // Add the vertical cells as targets
        temp = new PVector(pivot.x-1,pivot.y);
        if(myGrid.notHit(temp))
        {
          vertTargets.add(temp);
        }
        temp = new PVector(pivot.x+1,pivot.y);
        if(myGrid.notHit(temp))
        {
          vertTargets.add(temp);
        }
        // Add horizontal cells as targets
        temp = new PVector(pivot.x,pivot.y-1);
        if(myGrid.notHit(temp))
        {
          horizTargets.add(temp);
        }
        temp = new PVector(pivot.x,pivot.y+1);
        if(myGrid.notHit(temp))
        {
          horizTargets.add(temp);
        }
        println("Hit a pivot, targets as follows:");
        println(vertTargets);
        println(horizTargets);
        mode = Mode.HUNT;
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
        result = myGrid.AICheckHit(myShips, check);
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
              println("Below");
              temp = new PVector(check.x+1, check.y);
              vertTargets.remove(0);
              if(myGrid.notHit(temp))
              {
                println("Valid");
                vertTargets.add(0,temp);
              }
            } else {
              println("Above");
              temp = new PVector(check.x-1, check.y);
              vertTargets.remove(0);
              if(myGrid.notHit(temp))
              {
                println("Valid");
                vertTargets.add(0,temp);
              }
            }
            break;
          case 2:
            // Ship dead, clear target arrays
            vertTargets.clear();
            horizTargets.clear();
            mode = Mode.SEEK;
            break;
        }
      } else {
        println("Horiz Targets: " + horizTargets);
        PVector check = horizTargets.get(0);  // Shoot the first cell in the horizontal array
        targets.remove(check);  // remove the cell being checked from the targets
        println("Ai has chosen: " + check);
        result = myGrid.AICheckHit(myShips, check);
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
              println("Right");
              temp = new PVector(check.x, check.y+1);
              horizTargets.remove(0);
              if(myGrid.notHit(temp))
              {
                println("Valid");
                horizTargets.add(0,temp);
              }
            } else {
              println("Left");
              temp = new PVector(check.x, check.y-1);
              horizTargets.remove(0);
              if(myGrid.notHit(temp))
              {
                println("Valid");
                horizTargets.add(0,temp);
              }
            }
            break;
          case 2:
            // Ship dead, clear target arrays
            vertTargets.clear();
            horizTargets.clear();
            mode = Mode.SEEK;
            break;
        }
      }
    }
  }
}