abstract class AI
{
  ArrayList<PVector> targets;
  Mode mode;
  
  void seekShot()
  {
    int i = (int)random(targets.size());
    int result =  myGrid.AICheckHit(myShips, targets.get(i));
    targets.remove(i);
    switch(result)
    {
      case 0:
        println("I missed :(");
        break;
      case 1:
        println("Got 'em");
        break;
      case 2:
        println("GG no re");
        break;
      case -1:
        println("I am broken, help");
        break;
    }
  }
}