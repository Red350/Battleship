/* Randomises the players ship positions */
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

/* Starts the game if all the ships are placed */
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
        infoQueue.add("GAME HAS BEGUN, YOUR TURN");
      } else {
        infoQueue.remove();
        infoQueue.add("YOU MUST PLACE ALL SHIPS BEFORE STARTING");
      }
    }
  }
}

/* Reset the game */
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

/* Return to main menu */
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