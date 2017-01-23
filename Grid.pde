class Grid extends GameObject
{
  Cell[][] cells = new Cell[10][10];
  float size;
  
  Grid(float x, float y, float size)
  {
    pos = new PVector(x, y);
    this.size = size;
    
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        cells[i][j] = new Cell(x + (size/10) * i, y + (size/10) * j, size/10);
      }
    }
  }
  
  void render()
  {
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        cells[i][j].render();
      }
    }
  }
}