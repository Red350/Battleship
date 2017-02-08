/*
 * Very simple AI that never enters hunt mode.
 * Simply targets a random target each turn
 * regardless of outcome of previous shot.
 */

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
  
  void shoot(Grid g, Ship[] ships)
  {
    int i = (int)random(targets.size());
    int result =  g.AICheckHit(ships, targets.get(i));
    updateInfo(result);
    targets.remove(i);
  }
}