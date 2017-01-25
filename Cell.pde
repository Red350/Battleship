class Cell extends GameObject
{
  float size;
  boolean occupied;
  boolean hit;
  boolean lastHit;
  
  Cell(float x, float y, float size)
  {
    pos = new PVector(x, y);
    this.size = size;
    occupied = false;
    hit = false;
    lastHit = false;
    c = #00FF00;
  }
  
  void render()
  {
    stroke(c);
    noFill();
    strokeWeight(1);
    rect(pos.x, pos.y, size, size);
    if(hit)
    {
      if(occupied)
      {
        if(lastHit)
        {
          strokeWeight(3);
          stroke(#00FF00);
        } else {
          strokeWeight(1);
          stroke(#00FF00);
        }
      } else {
        if(lastHit)
        {
          strokeWeight(3);
          stroke(#FF0000);
        } else {
          strokeWeight(1);
          stroke(#FF0000);
        }
      }
      
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