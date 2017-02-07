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
  
  void shoot(Grid g, Ship[] ships)
  {}
  
  void randomiseShips(Ship[] s, Grid g)
  {
   int x, y;
   for(int i = 0; i < 5; i++)
    {
      x = (int)random(10);
      y = (int)random(10);
      while(!g.checkShipPlaceable(s[i],x,y))
      {
        x = (int)random(10);
        y = (int)random(10);
        // Trying to place ship
      }
      g.placeShip(s[i],x,y);
      // Place the graphical representation of the ship
      // (Hidden from the player until the game ends)
      s[i].lockToGrid(g,x,y);
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