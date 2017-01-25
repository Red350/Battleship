class MediumAI extends AI
{
  ArrayList<PVector> vertTargets;
  ArrayList<PVector> horizTargets;
  PVector pivot;
  
  MediumAI()
  {
    super();
    targets = new ArrayList<PVector>(100);
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
        System.out.println(vertTargets);
        System.out.println(horizTargets);
        mode = Mode.HUNT;
      }
      targets.remove(i);
    } else {
      if(vertTargets.size() > 0)
      {
        // CHECKING THE VERTICAL ARRAY, THEN ADDING ANOTHER ELEMENT IF IT HITS
        PVector check = vertTargets.get(0);  // Shoot the first cell in the vertical array
        result = myGrid.AICheckHit(myShips, check);
        switch(result)
        {
          case 0:
            break;
          case 1:
            // The target was successful, add the
            // next target to the start of the list
            if(check.x > pivot.x)
            {
              temp = new PVector(check.x+1, check.y);
              if(myGrid.notHit(temp))
              {
                vertTargets.remove(0);
                vertTargets.add(0,temp);
              }
            } else {
              temp = new PVector(check.x-1, check.y);
              if(myGrid.notHit(temp))
              {
                vertTargets.remove(0);
                vertTargets.add(0,temp);
              }
            }
            break;
          case 2:
            mode = Mode.SEEK;
            break;
        }
      }
    }
  }
}