/* Button to move to the game screen */
class PlayButton extends Button
{
  PlayButton(String name, PVector pos, float w, float h, color c)
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

/* Button to the display the how to play page */
class HowToButton extends Button
{
  HowToButton(String name, PVector pos, float w, float h, color c)
  {
    super(name,pos,w,h,c);
  }
  
  void mouseClicked()
  {
    if(super.mouseOver)
    {
      state = State.CONTROLS;
    }
  }
}