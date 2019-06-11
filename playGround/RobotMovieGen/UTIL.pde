void drawBlock(){
  stroke(200);
  for(int i=0;i<3;i++){
    float blockW=movieSize.x/robotArray.x;
    float wx=blockW+(i*blockW);
    line(wx ,0,wx,movieSize.y);
       //textSize(15*(1+sin(millis()*TWO_PI/2000)/2));
    //text(i,wx ,30);

  }
  for(int i=0;i<2;i++){
    float wy=(movieSize.y/robotArray.y)+(i*(movieSize.y/robotArray.y));
    line(0,wy,movieSize.x,wy);
    textSize(30);
    text(i,0,wy);
  }
}
String logHeader() {
  return "["+SDF.format( new java.util.Date() )+"]";
}

class  FadeOutCalc {
  long start_ms=0;
  long dst_ms=1; 

  void set(long period_ms)
  {
    set(period_ms, System.currentTimeMillis());
  }
  void set(long period_ms, long curTime_ms)
  {
    start_ms = curTime_ms;
    dst_ms = start_ms+period_ms;
  }

  void reset()
  {
    CubicBezierParam(0.333, 0.666);
  }
  float v1, v2;
  void CubicBezierParam(float v1, float v2)
  {
    this.v1=v1;
    this.v2=v2;
  }

  float CubicBezier(float t, float p0, float p1, float p2, float p3) {
    if (t>1)t=1;
    else if (t<0)t=0;
    float _1_t=(1-t);
    return p0*(_1_t*_1_t*_1_t) + 3*((_1_t*_1_t*t*p1)+(_1_t*t*t*p2)) + t*t*t*p3;
  }

  float getAlpha()
  {
    long now = System.currentTimeMillis();
    return getAlpha(now);
  }
  float getAlpha(long curTime_ms)
  {
    long now = curTime_ms;
    //println("start_ms:"+start_ms+ " curTime_ms:"+curTime_ms+" dst_ms:"+dst_ms);
    if (now<start_ms)return 0;
    if (now>dst_ms)return 1;
    float ratio = (float)(now-start_ms)/(dst_ms-start_ms);

    //return ratio;
    return CubicBezier(ratio, 0, v1, v2, 1);
  }
}
