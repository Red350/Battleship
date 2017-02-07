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
  
  void updateInfo(int result)
  {
    switch(result)
    {
      case 0:
        infoQueue.remove();
        infoQueue.add("Computer missed. Your turn");
        break;
      case 1:
        infoQueue.remove();
        infoQueue.add("Computer hit. Your turn");
        break;
      case 2:
        infoQueue.remove();
        infoQueue.add("Computer sunk your battleship! Your turn");
        break;
      case -1:
        infoQueue.remove();
        infoQueue.add("Computer is broken, call a programmer. Also your turn I guess...");
        break;
    }
  }
  
  void randomiseShips(Ship[] s, Grid g)
  {
   int x, y;
   numPlaced = 0;
   for(int i = 0; i < 5; i++)
    {
      s[i].orientation = (random(1)<0.5)?true:false;
      x = (int)random(10);
      y = (int)random(10);
      while(!g.checkShipPlaceable(s[i],x,y))
      {
        // Generate new orientation and position until the ship is placeable
        s[i].orientation = (random(1)<0.5)?true:false;
        x = (int)random(10);
        y = (int)random(10);
      }
      g.placeShip(s[i],x,y);
      
      // Place the graphical representation of the ship
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