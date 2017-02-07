class RandomiseButton extends Button
{
  RandomiseButton(String name, PVector pos, int w, int h, color c)
  {
    super(name,pos,w,h,c);
  }
  
  void mouseClicked()
  {
    if(super.mouseOver)
    {
      myGrid.reset();
      ai.randomiseShips(myShips, myGrid);
    }
  }
}

class PlayButton extends Button
{
  PlayButton(String name, PVector pos, int w, int h, color c)
  {
    super(name,pos,w,h,c);
  }
  
  void mouseClicked()
  {
    if(super.mouseOver)
    {
      reset();
    }
  }
}

class ResetButton extends Button
{
  ResetButton(String name, PVector pos, int w, int h, color c)
  {
    super(name,pos,w,h,c);
  }
  
  void mouseClicked()
  {
    if(super.mouseOver)
    {
      reset();
    }
  }
}

class MainMenuButton extends Button
{
  MainMenuButton(String name, PVector pos, int w, int h, color c)
  {
    super(name,pos,w,h,c);
  }
  
  void mouseClicked()
  {
    if(super.mouseOver)
    {
      state = State.MENU;
    }
  }
}