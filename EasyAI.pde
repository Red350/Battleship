class EasyAI extends AI
{
  
  EasyAI()
  {
    targets = new ArrayList<PVector>(100);
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        targets.add(new PVector(i,j));
      }
    }
  }
  
  void printTargets()
  {
    for(PVector target : targets)
    {
      println("(" + (int)target.x + "," + (int)target.y + ")");
    }
  }
}