

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

class ControlsButton extends Button
{
  ControlsButton(String name, PVector pos, int w, int h, color c)
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