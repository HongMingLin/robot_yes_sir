enum WHICHROBOT {
  R4F1(1), R4F2(2), R4F3(3), R4F4(4), 
    R3F1(5), R3F2(6), R3F3(7), R3F4(8), 
    R2F1(9), R2F2(10), R2F3(11), R2F4(12);
  private int value;
  private WHICHROBOT(int value) {
    this.value = value;
  }
  public int value() {
    return value;
  }
  private static WHICHROBOT[] vals = values();
  public WHICHROBOT next()
  {
    int now = this.ordinal()+1;
    return vals[(now) % vals.length];
  }
}
enum ALLMODE {
  PLAY, STOP, ESTOP;
  private static ALLMODE[] vals = values();
  public ALLMODE next()
  {
    int now = this.ordinal()+1;
    return vals[(now) % vals.length];
  }
}
enum RunMODE {
  STOP, M_MOUSE_XYZ, M_MOUSE_ABC, XYZ_CIRCLE,ABC_CIRCLE;
  private static RunMODE[] vals = values();
  public RunMODE next()
  {
    int now = this.ordinal()+1;
    return vals[(now) % vals.length];
  }
}
class HRobot {

  PVector SAFEx0y0z0=new PVector(-Window_W/2, 5, -Window_H/2);
  PVector SAFEx1y1z1=new PVector(Window_W/2, Window_D/2, Window_H/2);


  private PVector realXYZ=new PVector();
  private PVector XYZ=new PVector(0, 0, 0);
  private PVector normalizeXYZ=new PVector();
  PVector fXYZ=new PVector();
  String strXYZ="";
  String sX="";
  String sY="";
  String sZ="";
  PVector CC_XYZ=new PVector();
  private PVector ABC=new PVector();
  RunMODE RM=RunMODE.M_MOUSE_XYZ;
  float mouseWheele_e=0;
  void handleMouseEvent(MouseEvent event) {
    mouseWheele_e=event.getCount();
  }
  void UPDATE() {
    float xx=0, yy=0, zz=0;
    globalNowSin=millis()*(TWO_PI/globalCRICLE_Time);
    //println("RM"+RM);
    switch(RM) {
    case STOP:
      break;
    case XYZ_CIRCLE:

      xx=CC_XYZ.x+(15*sin(globalNowSin));
      zz=CC_XYZ.z+(15*cos(globalNowSin));
      yy=XYZ.y+(mouseWheele_e*0.1);
      setXYZ_lowPassFilter(new PVector(xx, yy, zz));
      break;
    case M_MOUSE_XYZ:

      xx=lerp(SAFEx0y0z0.x, SAFEx1y1z1.x, (mouseX/(float)appW));
      zz=lerp(SAFEx1y1z1.z, SAFEx0y0z0.z, (mouseY/(float)appH));
      yy=XYZ.y+(mouseWheele_e*0.1);
      setXYZ_lowPassFilter(new PVector(xx, yy, zz));
      break;
    case ABC_CIRCLE:

      zz=(10*sin(globalNowSin));
      xx=(10*cos(globalNowSin));
      ABC.x=xx;
      ABC.z=zz;
      
      break;
    case M_MOUSE_ABC:
      zz=lerp(-10, 10, (mouseX/(float)appW));
      xx=lerp(10, -10, (mouseY/(float)appH));

      ABC.x=xx;
      ABC.z=zz;

      break;
    }
  }
  PVector transXYZformat() {
    sX=(XYZ.x<=0?"":"+")+nf(XYZ.x, 3, 2);
    sY=(XYZ.y<=0?"":"+")+nf(XYZ.y, 3, 2);
    sZ=(XYZ.z<=0?"":"+")+nf(XYZ.z, 3, 2);
    fXYZ=new PVector(Float.parseFloat(nf(XYZ.x, 3, 2)), Float.parseFloat(nf(XYZ.y, 3, 2)), Float.parseFloat(nf(XYZ.z, 3, 2)));

    return fXYZ;
  }
  void setX(float i) {
    XYZ.x=i;
  }
  void setY(float i) {
    XYZ.y=i;
  }
  void setZ(float i) {
    XYZ.z=i;
  }
  void setCC_XYZ_NOW() {
    CC_XYZ=XYZ.copy();
  }

  void setXYZ_lowPassFilter(PVector in) {

    XYZ=checkSAFE(XYZ.lerp(in.x, in.y, in.z, 0.1));
  }

  void setXYZ(PVector in) {
    XYZ=checkSAFE(in);
  }
  void addXYZ(PVector in) {
    XYZ=checkSAFE(in.add(XYZ));
  }
  void checkSAFESpeed() {
    normalizeXYZ=XYZ.sub(realXYZ).normalize();
  }
  PVector checkSAFE(PVector in) {
    if (in.x>  SAFEx1y1z1.x)
      in.x= SAFEx1y1z1.x;
    else if (in.x< SAFEx0y0z0.x)
      in.x= SAFEx0y0z0.x;

    if (in.y>  SAFEx1y1z1.y)
      in.y= SAFEx1y1z1.y;
    else if (in.y< SAFEx0y0z0.y)
      in.y= SAFEx0y0z0.y;

    if (in.z>  SAFEx1y1z1.z)
      in.z= SAFEx1y1z1.z;
    else if (in.z< SAFEx0y0z0.z)
      in.z= SAFEx0y0z0.z;

    return in;
  }
}
class LEDPanel {
  PVector boxPosOffset;
  PVector dotSize;//=new PVector(100, 100);

  LEDPanel(PVector bPO, PVector size) {
    boxPosOffset=bPO;
    dotSize=size;
    println("dotOffset.x"+boxPosOffset.x+", dotOffset.y"+boxPosOffset.y);
  }
  float yyy=0;
  void update() {
    noStroke();
    pushMatrix();
    translate(boxPosOffset.x, 0, boxPosOffset.y);
    translate(windowSize.x/2, 0, windowSize.y/2);

    fill(255, 0, 0, 255);
    ellipse(0, 0, dotSize.x, dotSize.y);
    noFill();
    stroke(255);
    drawToolBox();
    rotateX(HALF_PI);
    rect(0, 0, windowSize.x, windowSize.z);

    popMatrix();
  }
}
float cm2mm(float in) {
  return in*10;
}
void send2robot() {

  json.setString("X", String.valueOf(cm2mm( HRs[whichRobot].XYZ.x)));
  json.setString("Y", String.valueOf(cm2mm( HRs[whichRobot].XYZ.y)));
  json.setString("Z", String.valueOf(cm2mm( HRs[whichRobot].XYZ.z)));

  //float a=lerp(-70, 58, (mouseX/(float)Window_X));
  //float b=lerp(-89, 88, Bpercent);
  //float c=lerp(-180, 180, (mouseY/(float)Window_Y));
  //ROBOT_ABC.lerp(a, b, c, 0.1);
  json.setString("A", String.valueOf(HRs[whichRobot].ABC.x) );
  json.setString("B", String.valueOf(0) );
  json.setString("C", String.valueOf(HRs[whichRobot].ABC.z) );

  String outJ=json.toString().replaceAll(" ", "");
  outJ=outJ.replaceAll("[^\\x20-\\x7e]", "");
  println(outJ);
  //u.send(printBB("TX",outJ),R_IP,R_PORT);
  u.send(outJ, R_IP, R_PORT);
}
