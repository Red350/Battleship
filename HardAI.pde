class HardAI extends HuntAI
{
  ArrayList<PVector> vertTargets;
  ArrayList<PVector> horizTargets;
  PVector pivot;
  
  ArrayList<PVector> backupTargets;
  
  HardAI()
  {
    super();
    reset();
  }
  
  void reset()
  {
    targets = new ArrayList<PVector>();
    backupTargets = new ArrayList<PVector>();
    // Adds every second location to the targets list
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        if((i + j) % 2 == 0)
        {
          targets.add(new PVector(i,j));
        } else {
          backupTargets.add(new PVector(i,j));
        }
      }
    }
  }
  
  void shoot(Grid g, Ship[] ships)
  {
    if(targets.size() == 0)
    {
      targets = backupTargets;
    }
    super.shoot(g, ships);
  }
}