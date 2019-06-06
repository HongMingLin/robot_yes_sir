class RedDot {
  PVector boxPosOffset;
  PVector dotSize;//=new PVector(100, 100);
  private PVector nowXY=new PVector(0, 0);
  private PVector fromXY=new PVector(0, 0);
  private PVector targetXY=new PVector(0, 0);
  long startMillis=0;
  float movingPercent=1;
  float movingDurition=0;
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
    
    float xx=map(in.x,0,1,-windowHalfSize.x+ledSizeHalf.x,windowHalfSize.x-ledSizeHalf.x);
    float yy=map(in.y,0,1,-windowHalfSize.y+ledSizeHalf.y,windowHalfSize.y-ledSizeHalf.y);
    nowXY.lerp(xx,yy,0, 0.018);
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
  void update() {
    updatePOI();

    noStroke();
    pushMatrix();
    translate(boxPosOffset.x, boxPosOffset.y);
    translate(windowSize.x/2, windowSize.y/2);
        translate(nowXY.x, nowXY.y);

    fill(255, 0, 0, 255);
    ellipse(0, 0, dotSize.x, dotSize.y);
    popMatrix();
  }
  RedDot(PVector bPO, PVector size) {
    boxPosOffset=bPO;
    dotSize=size;
    println("dotOffset.x"+boxPosOffset.x+", dotOffset.y"+boxPosOffset.y);
  }
}
