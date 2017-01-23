class Ship extends GameObject
{
  int size;
  int w, h;
  color c;
  boolean hover;
  boolean selected;
  
  Ship(float x, float y, int size)
  {
    pos = new PVector(x, y);
    this.size = size;
    w = (size * cellSize)-20;
    h = cellSize-20;
    
    hover = false;
    selected = false;
    c = #FF0000;
  }
  
  void render()
  {
    stroke(c);
    noFill();
    rect(pos.x, pos.y, w, h);
  }
  
  void update()
  {
    if(selected)
    {
      pos.x = mouseX - w / 2;
      pos.y = mouseY - h / 2;
    }
  }
  
  void mouseClicked()
  {
    if (mouseX > pos.x && mouseX < pos.x + w && mouseY > pos.y && mouseY < pos.y + h)
    {
      selected = !selected;
    }
  }
  
  //void mouseOver()
  //{
  //  if (mouseX > pos.x && mouseX < pos.x + w && mouseY > pos.y && mouseY < pos.y + h)
  //  {
  //    if(mousePressed)
  //    {
  //      selected = !selected;
  //    }
  //    hover = true;
  //    println("hover!");
  //  }
  //  else
  //  {
  //    hover = false;
  //  }
  //}
}