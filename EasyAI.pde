class EasyAI extends AI
{
  
  EasyAI()
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
  }
}