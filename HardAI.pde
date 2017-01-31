class HardAI extends HuntAI
{
  ArrayList<PVector> vertTargets;
  ArrayList<PVector> horizTargets;
  PVector pivot;
  
  HardAI()
  {
    super();
    reset();
  }
  
  void reset()
  {
    targets = new ArrayList<PVector>();
    // Adds every second location to the targets list
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        if((i + j) % 2 == 0)
        {
          targets.add(new PVector(i,j));
        }
      }
    }
  }
}