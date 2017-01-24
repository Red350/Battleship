class Ship extends GameObject
{
  int size;
  float w, h;
  color c;
  boolean selected;
  boolean orientation;  // true is horizontal, false is vertical
  boolean placed;
  int cellI, cellJ;
  
  Ship(float x, float y, int size)
  {
    this(size);
    pos = new PVector(x, y);
  }
  
  Ship(int size)
  {
    this.size = size;
    w = (size * cellSize) - shipGap * 2;
    h = cellSize - shipGap * 2;
    orientation = true;  // Ship starts horizontal
    
    selected = false;
    placed = false;
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
    // Have to change how mouse over is being checked depending on the orientation
    // of the ship
    float tempW, tempH;
    if(orientation)
    {
      tempW = w;
      tempH = h;
    } else {
      tempW = h;
      tempH = w;
    }
    
    if (mouseX > pos.x && mouseX < pos.x + tempW && mouseY > pos.y && mouseY < pos.y + tempH)
    {
      if(!selected)
      {
        if(placed)
        {
          myGrid.remove(this);
        }
        selected = true;
        selectedShip = this;
      } else {
        selected = false;
        selectedShip = null;
      }
    }
  }
}