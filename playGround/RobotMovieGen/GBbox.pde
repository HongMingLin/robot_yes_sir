
class GBbox {
  int[] minMidMax={60, 80, 100};
  int ID=0;
  private PVector boxSize;//=new PVector(100, 100);
  private PVector minBoxSize;//=new PVector(60*scale.x, 60*scale.y);
  private PVector XYOffset;
  private PVector nowBoxSize;
  private PVector nowXY=new PVector(0, 0);
  private PVector fromXY=new PVector(0, 0);
  private PVector targetXY=new PVector(0, 0);
  float scale=1.0f;
  private float rotate=00f;
  long startMillis=0;
  float movingPercent=1;
  float movingDurition=0;

  void handleMouseEvent(MouseEvent e) {
    if (SCALE_ROTATE) {
      scale+= e.getCount()*0.0001;
      if (scale<0.6)scale=0.6f;
      if (scale>2)scale=2f;
    } else {
      rotate+= e.getCount()*0.001;
      if (rotate<-QUARTER_PI)rotate=-QUARTER_PI;
      if (rotate>QUARTER_PI)rotate=QUARTER_PI;
    }
  }
  void goXY(float x, float y, float t) {
    goXY(new PVector(x, y), t);
  }
  void goXY(PVector in, float t) {
    movingDurition=t;
    movingPercent=0;
    startMillis=millis();
    fromXY=nowXY.copy();
    targetXY=in.copy();
  }
  void setXY(float x, float y) {
    setXY(new PVector(x, y));
  }
  void setXY(PVector in) {

    float xx=map(in.x, 0, 1, -windowHalfSize.x+ledSizeHalf.x, windowHalfSize.x-ledSizeHalf.x);
    float yy=map(in.y, 0, 1, -windowHalfSize.y+ledSizeHalf.y, windowHalfSize.y-ledSizeHalf.y);
    nowXY.lerp(xx, yy, 0, 0.018);
    //println(nowXY);
  }

  PVector lowpassFilter(PVector in) {
    return in.lerp(in, 0.18);
  }
  void updatePOI() {
    if (movingPercent>=1)return;
    long now=millis();
    movingPercent=(now-startMillis)/(float)movingDurition;
    println("movingPercent="+movingPercent);
    if (movingPercent>1)
      movingPercent=1;
    nowXY=PVector.lerp(fromXY, targetXY, movingPercent);
  }
  void drawx() {
    updatePOI();
    blendMode(ADD);
    noStroke(); 
    pushMatrix();
    translate(-boxSize.x/2.0, -boxSize.y/2.0);
    translate(XYOffset.x, XYOffset.y);    
    translate(windowSize.x/2.0, windowSize.y/2.0);
    translate(nowXY.x, nowXY.y);
    fill(255);
    translate(boxSize.x/2.0, boxSize.y/2.0);
    rotate(rotate);
    scale(scale);
    nowBoxSize=PVector.mult(boxSize, scale);
    translate(-boxSize.x/2.0, - boxSize.y/2.0);
    rectMode(CORNER);
    fill(0, 0, 255);
    scale(scale);
    rect(0, 0, boxSize.x/2.0, boxSize.y);
    fill(0, 255, 0);
    translate(boxSize.x/2.0, 0);
    rect(0, 0, boxSize.x/2.0, boxSize.y);

    popMatrix();
  }
  GBbox(int id, PVector bPO, PVector scale) {
    ID=id;
    XYOffset=bPO;
    boxSize=new PVector(minMidMax[2]*scale.x, minMidMax[2]*scale.y);
    minBoxSize=new PVector(minMidMax[0]*scale.x, minMidMax[0]*scale.y);
    nowBoxSize=new PVector(0, 0);
    println("boxSize.x"+boxSize.x+", boxSize.y"+boxSize.y);
  }
  void set_XYOffset(float x, float y) {
    XYOffset.x=x;
    XYOffset.y=y;
  }
}
