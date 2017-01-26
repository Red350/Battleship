class StartButton extends Button
{
  StartButton(String name, PVector pos, int w, int h, color c)
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
      if(numPlaced == 5)
      {
        super.mouseOver = false;
        state = State.PLAYING;
        info = "Game has begun, your turn";
        myGrid.printOccupiedCells();
        enemyGrid.printOccupiedCells();
      } else {
        info = "You must place all ships before starting";
      }
    }
  }
}