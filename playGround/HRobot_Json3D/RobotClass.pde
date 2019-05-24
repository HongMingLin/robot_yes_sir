class HRobot {
  
  PVector limit_xyz=new PVector(Window_W, Window_D, Window_H);
  PVector limit_x0y0z0=new PVector(Window_W, Window_D, Window_H);
  PVector limit_xyz_d2=new PVector(limit_xyz.x/2, limit_xyz.y/2, limit_xyz.z/2);

  private PVector XYZ=new PVector();
  PVector fXYZ=new PVector();
  String strXYZ="";
  String sX="";
  String sY="";
  String sZ="";
  PVector CC_XYZ=new PVector();
  private PVector ABC=new PVector();
  
  PVector updateXYZformat(){
    sX=(XYZ.x<=0?"":"+")+nf(XYZ.x,3,2);
    sY=(XYZ.y<=0?"":"+")+nf(XYZ.y,3,2);
    sZ=(XYZ.z<=0?"":"+")+nf(XYZ.z,3,2);
    fXYZ=new PVector(Float.parseFloat(nf(XYZ.x,3,2)),Float.parseFloat(nf(XYZ.y,3,2)),Float.parseFloat(nf(XYZ.z,3,2)));

    return fXYZ;
  }
  void setX(float i){
    XYZ.x=i;
  }
  void setY(float i){
    XYZ.y=i;
  }
  void setZ(float i){
    XYZ.z=i;
  }
  void setCC_XYZ_NOW() {
    CC_XYZ=XYZ;
  }
  void setXYZ(PVector in) {
    XYZ=checkSAFE(in);
  }
  void addXYZ(PVector in) {
     XYZ=checkSAFE(in.add(XYZ));
  }
  PVector checkSAFE(PVector in) {
    if (in.x>  limit_xyz_d2.x)
      in.x= limit_xyz_d2.x;
    else if (in.x< -limit_xyz_d2.x)
      in.x= -limit_xyz_d2.x;

    if (in.y>  limit_xyz_d2.y)
      in.y= limit_xyz_d2.y;
    else if (in.y< -limit_xyz_d2.y)
      in.y= -limit_xyz_d2.y;

    if (in.z>  limit_xyz_d2.z)
      in.z= limit_xyz_d2.z;
    else if (in.z< -limit_xyz_d2.z)
      in.z= -limit_xyz_d2.z;

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
