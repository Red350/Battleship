class Cell extends GameObject
{
  float size;
  
  Cell(float x, float y, float size)
  {
    pos = new PVector(x, y);
    this.size = size;
    c = #00FF00;
  }
  
  void render()
  {
    stroke(c);
    noFill();
    rect(pos.x, pos.y, size, size);
  }
  
  boolean mouseOver()
  {
    if(mouseX > pos.x && mouseX < pos.x + size && mouseY > pos.y && mouseY < pos.y + size)
    {
      return true;
    }
    return false;
  }
}