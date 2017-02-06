class StartButton extends Button
{
  StartButton(String name, PVector pos, int w, int h, color c)
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
        info = "Game has begun, your turn";
      } else {
        info = "You must place all ships before starting";
      }
    }
  }
}