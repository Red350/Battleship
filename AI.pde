abstract class AI
{
  ArrayList<PVector> targets;
  Mode mode;
  int lastShot;
  int shotsTaken;
  
  AI()
  {
    mode = Mode.SEEK;
    lastShot = 0;
    shotsTaken = 0;
  }
  
  void reset()
  {}
  
  void shoot()
  {}
  
  void randomiseShips(Ship[] s, Grid g)
  {
    for(int i = 0; i < 5; i++)
    {
      while(!g.placeShip(s[i],(int)random(10),(int)random(10)))
      {
        // Trying to place ship
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