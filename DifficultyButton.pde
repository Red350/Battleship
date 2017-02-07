abstract class DifficultyButton extends Button
{
  boolean selected;
  DifficultyButton(String name, PVector pos, float w, float h, color c)
  {
    super(name,pos,w,h,c);
  }
  void mouseClicked()
  {
  }
  
  void render()
  {
    update();
    color temp, buttonColor, textColor;
    
    if(selected)
    {
      temp = c;
    } else {
      temp = #666666;
    }
    
    if(mouseOver)
    {
      buttonColor = temp;
      textColor = 0;
    } else {
      buttonColor = 0;
      textColor = temp;
    }
    
    stroke(temp);
    strokeWeight(1);
    fill(buttonColor);
    rect(pos.x,pos.y,w,h);
    textAlign(CENTER, CENTER);
    fill(textColor);
    text(name,pos.x+w/2,pos.y+h/2);
  }
}

class EasyButton extends DifficultyButton
{  
  
  EasyButton(String name, PVector pos, float w, float h, color c)
  {
    super(name,pos,w,h,c);
    selected = false;
  }
  
  void mouseClicked()
  {
    if(super.mouseOver)
    {
      difficulty = 0;
      selected = true;
      mediumButton.selected = false;
      hardButton.selected = false;
    }
  }
}

class MediumButton extends DifficultyButton
{  
  MediumButton(String name, PVector pos, float w, float h, color c)
  {
    super(name,pos,w,h,c);
    selected = false;
  }
  
  void mouseClicked()
  {
    if(super.mouseOver)
    {
      difficulty = 1;
      selected = true;
      easyButton.selected = false;
      hardButton.selected = false;
    }
  }
}

class HardButton extends DifficultyButton
{  
  HardButton(String name, PVector pos, float w, float h, color c)
  {
    super(name,pos,w,h,c);
    selected = true;
  }
  
  void mouseClicked()
  {
    if(super.mouseOver)
    {
      difficulty = 2;
      selected = true;
      easyButton.selected = false;
      mediumButton.selected = false;
    }
  }
}