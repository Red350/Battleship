/* Button base class */
abstract class Button
{
  PVector pos;
  float w,h;
  String name;
  boolean mouseOver;
  color c;
  
  Button(String name, PVector pos, float w, float h, color c)
  {
    this.name = name;
    this.pos = pos;
    this.w = w;
    this.h = h;
    this.c = c;
  }
  
  Button(){}
  
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
    update();
    color textColor;
    color buttonColor;
    if(mouseOver)
    {
      buttonColor = c;
      textColor = 0;
    } else {
      buttonColor = 0;
      textColor = c;
    }
    
    stroke(c);
    strokeWeight(1);
    fill(buttonColor);
    rect(pos.x,pos.y,w,h);
    textAlign(CENTER, CENTER);
    textFont(buttonFont);
    fill(textColor);
    text(name,pos.x+w/2,pos.y+h/2);
  }
  
  void mouseClicked(){}
}