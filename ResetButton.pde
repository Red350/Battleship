class ResetButton extends Button
{
  ResetButton(String name, PVector pos, int w, int h, color c)
  {
    super(c);
    this.name = name;
    this.pos = pos;
    this.w = w;
    this.h = h;
  }
  
  void mouseClicked()
  {
    if(super.mouseOver)
    {
      state = State.SETUP;
      reset();
    }
  }
}