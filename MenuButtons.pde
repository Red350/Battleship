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