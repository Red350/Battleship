class RandomiseButton extends Button
{
  RandomiseButton(String name, PVector pos, float w, float h, color c)
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

class StartButton extends Button
{
  StartButton(String name, PVector pos, float w, float h, color c)
  {
    super(name,pos,w,h,c);
  }
  
  void mouseClicked()
  {
    if(super.mouseOver)
    {
      if(numPlaced == 5)
      {
        super.mouseOver = false;
        state = State.PLAYING;
        myGrid.clearHovered();
        infoQueue.remove();
        infoQueue.add("Game has begun, your turn");
      } else {
        infoQueue.remove();
        infoQueue.add("You must place all ships before starting");
      }
    }
  }
}

class ResetButton extends Button
{
  ResetButton(String name, PVector pos, float w, float h, color c)
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
  MainMenuButton(String name, PVector pos, float w, float h, color c)
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