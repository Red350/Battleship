/* Grid is made up of 10x10 of these cells.
 * Stores information mostly for the purposes of rendering the cell.
 */
class Cell extends GameObject
{
  float size;
  boolean occupied; // Is there a ship in this cell
  boolean hit;      // Is the cell hit
  boolean lastHit;  // Is this the most recently targeted cell
  boolean sunk;     // Has the ship in this cell been sunk
  int hovered;      // Is the mouse over this cell
  
  Cell(float x, float y, float size)
  {
    pos = new PVector(x, y);
    this.size = size;
    occupied = false;
    hit = false;
    lastHit = false;
    sunk = false;
    c = #00FF00;
  }
  
  void render()
  {
    stroke(c);
    switch(hovered)
    {
      case 0:
        noFill();
        break;
      case 1:
        fill(#005500);
        break;
      case 2:
        fill(#550000);
    }
    
    strokeWeight(1);
    rect(pos.x, pos.y, size, size);
    if(hit)
    {
      // Set the correct strokeWeight
      if(lastHit)
      {
        strokeWeight(3);
      } else {
        strokeWeight(1);
      }
      
      // Set the correct colour
      if(occupied)
      {
        if(sunk)
        {
          stroke(#FFFF00);
        } else {
          stroke(#00FF00);
        }
      } else {
        stroke(#FF0000);
      }
      
      line(pos.x,pos.y,pos.x+size,pos.y+size);
      line(pos.x,pos.y+size,pos.x+size,pos.y);
    }
  }
  
  void updateHover()
  {
    if(mouseOver())
    {
      hovered = 1;
    } else {
      hovered = 0;
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