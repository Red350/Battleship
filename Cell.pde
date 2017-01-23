class Cell extends GameObject
{
  int size;
  
  Cell(float x, float y)
  {
    pos.x = x;
    pos.y = y;
    c = #00FF00;
    size = 50;
  }
  
  void render()
  {
    rect(pos.x, pos.y, size, size);
  }
}