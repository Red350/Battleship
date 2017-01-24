class Ship extends GameObject
{
  int size;
  int w, h;
  color c;
  boolean hover;
  boolean selected;
  boolean orientation;  // true is horizontal, false is vertical
  
  Ship(float x, float y, int size)
  {
    pos = new PVector(x, y);
    this.size = size;
    w = (size * cellSize) - shipGap * 2;
    h = cellSize - shipGap * 2;
    orientation = true;  // Ship starts horizontal
    
    hover = false;
    selected = false;
    c = #FF0000;
  }
  
  void render()
  {
    stroke(c);
    noFill();
    if(this.equals(selectedShip))
    {
      stroke(120);
    }
    if(orientation)
    {
      rect(pos.x, pos.y, w, h);
    } else {
      rect(pos.x, pos.y, h, w);
    }
  }
  
  void keyPressed()
  {
    orientation = !orientation;
  }
  
  void update()
  {
    if(selected)
    {
      pos.x = mouseX - h / 2;
      pos.y = mouseY - h / 2;
    }
  }
  
  void mouseClicked()
  {
    if (mouseX > pos.x && mouseX < pos.x + w && mouseY > pos.y && mouseY < pos.y + h)
    {
      if(!selected)
      {
        selected = true;
        selectedShip = this;
      } else {
        selected = false;
        selectedShip = null;
      }
    }
  }
}