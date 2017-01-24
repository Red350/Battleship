class Cell extends GameObject
{
  float size;
  boolean occupied;
  boolean hit;
  
  Cell(float x, float y, float size)
  {
    pos = new PVector(x, y);
    this.size = size;
    occupied = false;
    hit = false;
    c = #00FF00;
  }
  
  void render()
  {
    stroke(c);
    if(occupied)
    {
      fill(255);
    } else {
      noFill();
    }
    rect(pos.x, pos.y, size, size);
    if(hit)
    {
      stroke(#FF0000);
      line(pos.x,pos.y,pos.x+size,pos.y+size);
      line(pos.x,pos.y+size,pos.x+size,pos.y);
    }
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