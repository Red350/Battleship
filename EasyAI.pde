class EasyAI extends AI
{
  
  EasyAI()
  {
    super();
    reset();
  }
  
  void reset()
  {
    targets = new ArrayList<PVector>();
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        targets.add(new PVector(i,j));
      }
    }
  }
  
  void shoot()
  {
    int i = (int)random(targets.size());
    int result =  myGrid.AICheckHit(myShips, targets.get(i));
    targets.remove(i);
    switch(result)
    {
      case 0:
        println("I missed :(");
        info = "Computer missed";
        break;
      case 1:
        println("Got 'em");
        info = "Computer hit";
        break;
      case 2:
        println("GG no re");
        info = "Computer sunk your battleship!";
        break;
      case -1:
        println("I am broken, help");
        info = "Computer is broken";
        break;
    }
  }
}