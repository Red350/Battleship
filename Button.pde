abstract class Button
{
  PVector pos;
  int w,h;
  String name;
  boolean mouseOver;
  color c;
  
  Button(color c)
  {
    this.c = c;
  }
  
  void update()
  {
    if(mouseX > pos.x && mouseX < pos.x + w && mouseY > pos.y && mouseY < pos.y + h)
    {
      mouseOver = true;
    } else {
      mouseOver = false;
    }
  }
  
  void render()
  {
    if(mouseOver)
    {
      fill(c);
    } else {
      noFill();
    }
    stroke(c);
    rect(pos.x,pos.y,w,h);
    textAlign(CENTER, CENTER);
    textSize(20);
    fill(c);
    text(name,pos.x+w/2,pos.y+h/2);
  }
  
  void mouseClicked(){}
}