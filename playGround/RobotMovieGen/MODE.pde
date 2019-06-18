
enum MODE{
  MOVIE,SCALE,ROTATE,EYE,QLAB,SEQ_GB,MOUSE_GB,MOUSE_RED,CIRCLE_XY,CIRCLE_RED,STOP;
  private static MODE[] vals = values();
  public MODE next()
  {
    int now = this.ordinal()+1;
    return vals[(now) % vals.length];
  }
}
