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
  
  void randomiseShips(Ship[] s, Grid g)
  {
    int attempts = 0;
    for(int i = 0; i < 5; i++)
    {
      while(!g.placeShip(s[i],(int)random(10),(int)random(10)))
      {
        attempts++;
      }
    }
    println("Number attempts: " + attempts);
  } 
}